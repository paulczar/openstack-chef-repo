#!/bin/bash

source /home/vagrant/openrc

#echo some basic house keeping
#echo ------------------------

#cho - Create really small flavor
#FLAVOR_ID=42
#nova flavor-create m1.demo $FLAVOR_ID 256 0 1

#echo - add 3306 and 80 to default security group
#nova secgroup-add-rule default tcp 3306 3306 0.0.0.0/0
#nova secgroup-add-rule default tcp 80 80 0.0.0.0/0

echo
echo MySQL Servers
echo -------------
echo -n "- boot mysql01 ."

tee /tmp/mysql01.txt <<EOF > /dev/null
#docker
image: paulczar/mysql
cmd: "mysqld_safe --server-id=1 --log-bin=mysql-bin --log-slave-updates=1  --auto_increment_increment=2 --auto_increment_offset=1"
EOF

MYSQL01_ID=$(nova boot --flavor m1.tiny --image docker mysql01 --user-data /tmp/mysql01.txt | grep '| id' | awk '{print $4}')
nova show $MYSQL01_ID | grep ACTIVE > /dev/null
until [ $? -eq 0 ]; do
  sleep 1
  nova show $MYSQL01_ID | grep ACTIVE > /dev/null
  echo -n "."
done
MYSQL01_IP=$(nova show $MYSQL01_ID | grep 'public network' | awk '{print $5}')
echo " - $MYSQL01_IP"

echo -n "- boot mysql02 ."

tee /tmp/mysql02.txt <<EOF > /dev/null
#docker
image: paulczar/mysql
cmd: "mysqld_safe --server-id=2 --log-bin=mysql-bin --log-slave-updates=1  --auto_increment_increment=2 --auto_increment_offset=2"
EOF


MYSQL02_ID=$(nova boot --flavor m1.tiny --image docker mysql02 --user-data /tmp/mysql02.txt | grep '| id' | awk '{print $4}')
nova show $MYSQL02_ID | grep ACTIVE > /dev/null
until [ $? -eq 0 ]; do
  sleep 1
  nova show $MYSQL02_ID | grep ACTIVE > /dev/null
  echo -n "."
done
MYSQL02_IP=$(nova show $MYSQL02_ID | grep 'public network' | awk '{print $5}')
echo " - $MYSQL02_IP"

echo "- Sleep for 5 seconds, give MySQL a chance to start"
sleep 5

echo "- Creat replication user"

mysql -uroot -proot -h $MYSQL01_IP -AN -e 'GRANT REPLICATION SLAVE ON *.* TO "replication"@"%" IDENTIFIED BY "password";'
mysql -uroot -proot -h $MYSQL01_IP -AN -e 'flush privileges;'


echo "- Export Data from MySQL01 to MySQL02"

mysqldump -uroot -proot -h $MYSQL01_IP --single-transaction --all-databases \
  --flush-privileges | mysql -uroot -proot -h $MYSQL02_IP

echo "- Set MySQL01 as master on MySQL02"

MYSQL01_Position=$(mysql -uroot -proot -h $MYSQL01_IP -e "show master status \G" | grep Position | awk '{print $2}')
MYSQL01_File=$(mysql -uroot -proot -h $MYSQL01_IP -e "show master status \G"     | grep File     | awk '{print $2}')

mysql -uroot -proot -h $MYSQL02_IP -AN -e "CHANGE MASTER TO master_host='$MYSQL01_IP', master_port=3306, \
  master_user='replication', master_password='password', master_log_file='$MYSQL01_File', \
  master_log_pos=$MYSQL01_Position;"

echo "- Set MySQL02 as master on MySQL01"

MYSQL02_Position=$(mysql -uroot -proot -h $MYSQL02_IP -e "show master status \G" | grep Position | awk '{print $2}')
MYSQL02_File=$(mysql -uroot -proot -h $MYSQL02_IP -e "show master status \G"     | grep File     | awk '{print $2}')

mysql -uroot -proot -h $MYSQL01_IP -AN -e "CHANGE MASTER TO master_host='$MYSQL02_IP', master_port=3306, \
  master_user='replication', master_password='password', master_log_file='$MYSQL02_File', \
  master_log_pos=$MYSQL02_Position;"

echo "- Start Slave on both Servers"
mysql -uroot -proot -h $MYSQL01_IP -AN -e "start slave;"
mysql -uroot -proot -h $MYSQL02_IP -AN -e "start slave;"

echo "- Create database 'wordpress' on MySQL01"

mysql -uroot -proot -h $MYSQL01_IP -e "create database wordpress;"

echo "- Sleep 2 seconds, then check that database 'wordpress' exists on MySQL02"

sleep 2
mysql -uroot -proot -h $MYSQL02_IP -e "show databases; \G" | grep wordpress


echo 
echo "Create MySQL Load Balancer"
echo "--------------------------"

echo -n "- Create HAProxy-MySQL"

mysql -uroot -proot -h $MYSQL01_IP -AN -e "GRANT USAGE ON *.* TO 'haproxy'@'%';"

tee /tmp/haproxy-mysql.txt <<EOF > /dev/null
#docker
image: paulczar/haproxy-mysql
cmd: "/haproxy/start 'server Primary $MYSQL01_IP:3306' 'server Secondary $MYSQL02_IP:3306'"
EOF

HAPROXY_MYSQL=$(nova boot --flavor m1.tiny --image docker haproxy-mysql --user-data /tmp/haproxy-mysql.txt | grep '| id' | awk '{print $4}')
nova show $HAPROXY_MYSQL | grep ACTIVE > /dev/null
until [ $? -eq 0 ]; do
  sleep 1
  nova show $HAPROXY_MYSQL | grep ACTIVE > /dev/null
  echo -n "."
done
HAPROXY_MYSQL_IP=$(nova show $HAPROXY_MYSQL | grep 'public network' | awk '{print $5}')
echo " - $HAPROXY_MYSQL_IP"

echo "- Check our haproxy works"
echo "   (should show alternating server_id)"

#mysql -uroot -proot -h $HAPROXY_MYSQL_IP -e 'show variables like "server_id"' | grep server_id
#mysql -uroot -proot -h $HAPROXY_MYSQL_IP -e 'show variables like "server_id"' | grep server_id
#mysql -uroot -proot -h $HAPROXY_MYSQL_IP -e 'show variables like "server_id"' | grep server_id
#mysql -uroot -proot -h $HAPROXY_MYSQL_IP -e 'show variables like "server_id"' | grep server_id
