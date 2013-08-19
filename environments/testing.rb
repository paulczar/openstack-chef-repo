name "testing"
description "Environment used in testing the upstream cookbooks and reference Chef repository"

override_attributes(
  "mysql" => {
    "server_root_password" => "root",
    "server_debian_password" => "root",
    "server_repl_password" => "root",
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "lxc" => {
    "allowed_types" => [ "ubuntu" ]
  },  
  "openstack" => {
    "auth" => {
      "validate_certs" => false
    },
    "block-storage" => {
      "syslog" => {
        "use" => false
      },
      "api" => {
        "ratelimit" => "False"
      },
      "debug" => true,
      "image_api_chef_role" => "os-image",
      "identity_service_chef_role" => "os-identity",
      "rabbit_server_chef_role" => "os-ops-messaging",
      "rabbit" => {
        "host" => "33.33.33.60"
      },
    },
    "compute" => {
      "config" => {
         "ram_allocation_ratio" => 5.0
       },
       "syslog" => {
        "use" => false
      },
      "driver" => "docker.DockerDriver",
      "libvirt" => {
        "bind_interface" => "eth1",
        "virt_type" => "qemu" 
      },
      "novnc_proxy" => {
        "bind_interface" => "eth1"
      },
      "xvpvnc_proxy" => {
        "bind_interface" => "eth1"
      },
      "rabbit" => {
        "host" => "33.33.33.60"
      },
      "image_api_chef_role" => "os-image",
      "identity_service_chef_role" => "os-identity",
      "nova_setup_chef_role" => "os-compute-api",
      "rabbit_server_chef_role" => "os-ops-messaging",
      "ratelimit" => {  # Disable ratelimiting so Tempest doesn't have issues.
        "api" => {
          "enabled" => false
        },
        "volume" => {
          "enabled" => false
        }
      },
      "network" => {
       "fixed_range"      => "192.168.100.0/24",
       "public_interface" => "eth2"
      },
      "networks" => [
       {
          "label"        => "public",
          "ipv4_cidr"    => "192.168.100.0/24",
          "num_networks" => "1",
          "network_size" => "255",
          "bridge"       => "br100",
          "bridge_dev"   => "eth2",
          "dns1"         => "8.8.8.8",
          "dns2"         => "8.8.4.4"
        }
      ]
    },
    "db" => {
      "bind_interface" => "eth1",
      "compute" => {
        "host" => "33.33.33.60"
      },
      "identity" => {
        "host" => "33.33.33.60"
      },
      "image" => {
        "host" => "33.33.33.60"
      },
      "network" => {
        "host" => "33.33.33.60"
      },
      "volume" => {
        "host" => "33.33.33.60"
      },
      "dashboard" => {
        "host" => "33.33.33.60"
      },
      "metering" => {
        "host" => "33.33.33.60"
      }
    },
    "developer_mode" => true,
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
    "identity" => {
      "admin_user"     => "admin",
      "bind_interface" => "eth1",
      "catalog"        => {
        "backend" => "templated"
      },
      "debug" => true,
      "rabbit_server_chef_role" => "os-ops-messaging",
      "rabbit" => {
        "host" => "33.33.33.60"
      },
      "roles" => [
        "admin",
        "keystone_admin",
        "keystone_service_admin",
        "member",
        "netadmin",
        "sysadmin"
      ],
      "syslog" => {
        "use" => false
      },
      "tenants" => [
        "admin",
        "service",
        "demo"
      ],
      "users" => {
        "admin" => {
          "password"       => "admin",
          "default_tenant" => "admin",
          "roles"          => { # Each key is the role name, each value is a list of tenants
            "admin"                  => [
              "admin"
            ],
            "keystone_admin"         => [
              "admin"
            ],
            "keystone_service_admin" => [
              "admin"
            ]
          }
        },
        "demo" => {
          "password"       => "demo",
          "default_tenant" => "demo",
          "roles"          => { # Each key is the role name, each value is a list of tenants
            "sysadmin" => [
              "demo"
            ],
            "netadmin" => [
              "demo"
            ],
            "member"   => [
              "demo"
            ]
          }
        }
      }
    },
    "image" => {
      "api" => {
        "bind_interface" => "eth1"
      },
      "rabbit" => {
        "host" => "33.33.33.60"
      },
      "debug" => true,
      "identity_service_chef_role" => "os-identity",
      "image_upload" => false,
      "rabbit_server_chef_role" => "os-ops-messaging",
      "registry" => {
        "bind_interface" => "eth1"
      },
      "syslog" => {
        "use" => false
      },
      "upload_image" => {
        "cirros" => "http://hypnotoad/cirros-0.3.0-x86_64-disk.img",
      },
      "upload_images" => [
        "cirros"
      ]
    },
    "network" => {
      "rabbit" => {
        "host" => "33.33.33.60"
      },
      "rabbit_server_chef_role" => "os-ops-messaging"
    },
    "mq" => {
      "bind_interface" => "eth1",
      "host" => "33.33.33.60",
      "user" => "guest",
      "vhost" => "/nova"
    }
  },
  "queue" => {
    "host" => "33.33.33.60",
    "user" => "guest",
    "vhost" => "/nova"
  }
)