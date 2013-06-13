name "vagrant"
description "Example environment defineing the network and database settings you're going to use with OpenStack. The networks will be used in the libraries provided by the osops-utils cookbook. This example is for FlatDHCP with 2 physical networks."

override_attributes(
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "openstack" => {
    "developer_mode" => true
  },
   "glance" => {
     "image_upload" => true,
     "images" => ["cirros"],
     "image" => {
       "cirros" => "http://hypnotoad/cirros-0.3.0-x86_64-disk.img"
     }
   },
   "osops_networks" => {
     "public" => "33.33.33.0/24",
     "management" => "33.33.33.0/24",
     "nova" => "33.33.33.0/24"
   },  
   "nova" => {
     "network" => {
       "fixed_range" => "192.168.100.0/24",
       "public_interface" => "eth0"
     },
      "libvirt": { 
        "virt_type": "qemu" 
      },     
     "networks" => [
       {
         "label" => "public",
         "ipv4_cidr" => "192.168.100.0/24",
         "num_networks" => "1",
         "network_size" => "255",
         "bridge" => "br100",
         "bridge_dev" => "eth0",
         "dns1" => "8.8.8.8",
         "dns2" => "8.8.4.4"
       }
     ]
   }
  )
