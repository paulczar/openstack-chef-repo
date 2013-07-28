name "vagrant"
description "Example environment defineing the network and database settings you're going to use with OpenStack. The networks will be used in the libraries provided by the osops-utils cookbook. This example is for FlatDHCP with 2 physical networks."

override_attributes(
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "openstack" => {
    "developer_mode" => true,
    "identity" => {
      "bind_interface" => "lo" 
    },
    "endpoints" => {
      "identity-api" => {
        "scheme" => "http"
      },
      "identity-admin" => {
        "scheme" => "http"
      },
      "compute-api" => {
        "scheme" => "http"
      },
      "compute-ec2-api" => {
        "scheme" => "http"
      },
      "compute-ec2-admin" => {
        "scheme" => "http"
      },
      "compute-xvpvnc" => {
        "scheme" => "http"
      },
      "compute-novnc" => {
        "scheme" => "http"
      },
      "network-api" => {
        "scheme" => "http"
      },
      "image-api" => {
        "scheme" => "http"
      },
      "image-registry" => {
        "scheme" => "http"
      },
      "volume-api" => {
        "scheme" => "http"
      },
      "metering-api" => {
        "scheme" => "http"
      },
    },
   "image" => {
     "image_upload" => false,
     "upload_images" => ["cirros"],
     "upload_image" => {
       "cirros" => "https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img"
     },
     "identity_service_chef_role" => "allinone-compute"
   },
#   "osops_networks" => {
#     "public" => "33.33.33.0/24",
#     "management" => "33.33.33.0/24",
#     "nova" => "33.33.33.0/24"
#   },  
   "block-storage" => {
     "keystone_service_chef_role" => "allinone-compute"
   },
   "dashboard" => {
     "keystone_service_chef_role" => "allinone-compute"
   },
   "network" => {
    "rabbit_server_chef_role" => "allinone-compute"
   },
   "compute" => {
     "identity_service_chef_role" => "allinone-compute",
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
