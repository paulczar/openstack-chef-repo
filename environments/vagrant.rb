name "vagrant"
description "Example environment defineing the network and database settings you're going to use with OpenStack. The networks will be used in the libraries provided by the osops-utils cookbook. This example is for FlatDHCP with 2 physical networks."

override_attributes(
  "mysql" => {
    "server_root_password" => "root",
    "server_debian_password" => "root",
    "server_repl_password" => "root",
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "docker" => {
    "bind_uri" => "tcp://127.0.0.1:4243"
  },
  "lxc" => {
    "allowed_types" => [ "ubuntu" ]
  },
  "openstack" => {
    "auth" => {
      "validate_certs" => false
    },
    "endpoints" => {
      "compute-api" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "8774",
        "path"   => "/v2/%(tenant_id)s"
      },
      "compute-ec2-admin" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "8773",
        "path"   => "/services/Admin"
      },
      "compute-ec2-api" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "8773",
        "path"   => "/services/Cloud"
      },
      "compute-xvpvnc" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "6081",
        "path"   => "/console"
      },
      "compute-novnc" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "6080",
        "path"   => "/vnc_auto.html"
      },
      "image-api" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "9292",
        "path"   => "/v2"
      },
      "image-registry" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "9191",
        "path"   => "/v2"
      },
      "identity-api" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "5000",
        "path"   => "/v2.0"
      },
      "identity-admin" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "35357",
        "path"   => "/v2.0"
      },
      "volume-api" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "8776",
        "path"   => "/v1/%(tenant_id)s"
      },
      "metering-api" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "8777",
        "path"   => "/v1"
      },
      "network-api" => {
        "host"   => "33.33.33.60",
        "scheme" => "http",
        "port"   => "9696",
        "path"   => "/v2"
      }
    },    
    "developer_mode" => true,
    "identity" => {
      "bind_interface" => "lo" 
    },
   "image" => {
     "image_upload" => false,
     "data_api" => "glance.db.docker.api",
     "upload_images" => ["cirros"],
     "upload_image" => {
       "cirros" => "https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img"
     },
     "identity_service_chef_role" => "allinone-compute"
   },
   "block-storage" => {
     "keystone_service_chef_role" => "allinone-compute"
   },
   "dashboard" => {
     "keystone_service_chef_role" => "allinone-compute",
     "debug" => "true",
   },
   "network" => {
    "rabbit_server_chef_role" => "allinone-compute"
   },
   "compute" => {
     "identity_service_chef_role" => "allinone-compute",
     "driver" => "docker.DockerDriver",
     "config" => {
        "ram_allocation_ratio" => 5.0
     },
     "network" => {
       "fixed_range" => "192.168.100.0/24",
       "public_interface" => "eth2"
      },
      "libvirt" => { 
       "virt_type" => "qemu" 
      },     
      "networks" => [
       {
         "label" => "public",
         "ipv4_cidr" => "192.168.100.0/24",
         "num_networks" => "1",
         "network_size" => "255",
         "bridge" => "br100",
         "bridge_dev" => "eth2",
         "dns1" => "8.8.8.8",
         "dns2" => "8.8.4.4"
       }
     ]
   }
  }
  )
