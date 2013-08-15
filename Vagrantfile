# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "Use a newer version of Vagrant (1.2.1+)"
end


# Allows us to pick a different box by setting Environment Variables
BOX_NAME = ENV['BOX_NAME'] || "stackforge-openstack"
#BOX_NAME = ENV['BOX_NAME'] || "precise64"
BOX_URI = ENV['BOX_URI'] || "https://s3.amazonaws.com/paul-cz-misc/stackforge-openstack.box"

# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
#host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"


Vagrant.configure("2") do |config|
  # Cachier - speeds up subsequent runs.
  # vagrant plugin install vagrant-cachier
  config.cache.auto_detect = true
  #config.cache.enable_nfs  = true

  # Map .chef dir to /root/.chef to help knife etc.
  config.vm.synced_folder ".chef", "/root/.chef"
  # use the config.json and allow caching of cookbooks in berkshelf.
  config.vm.synced_folder ".berkshelf", "/root/.berkshelf"

  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = true
  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile-vagrant"

  if BOX_NAME != "stackforge-openstack"
    # Ensure Chef 11.x is installed for provisioning
    config.omnibus.chef_version = :latest

    # enable avahi / mdns
    config.vm.provision :shell, :inline => <<-SCRIPT
      apt-get -y install avahi-daemon
      echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
    SCRIPT

    # bootstrap all nodes with general apps.
    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = {
          "languages" => {
            "ruby" => {
              "default_version" => "1.9.1"
            }
          }
      }
      chef.run_list = [
        "recipe[apt::default]",
        "recipe[ruby::default]",
        "recipe[build-essential::default]",
        "recipe[git::default]"
      ]
    end
  end

  config.vm.define :allinone do |config|
    config.vm.hostname = "allinone"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.60"
    config.vm.network :private_network, ip: "192.168.100.60"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :shell, :inline => <<-SCRIPT
      ifconfig eth2 promisc
      mkdir -p /etc/chef
      cp /vagrant/.chef/client.pem /etc/chef/client.pem
      cp /vagrant/.chef/client.rb  /etc/chef/client.rb
      apt-get -y install libxslt-dev libxml2-dev # stupid Nokogiri!
      gem install chef-zero --no-ri --no-rdo
      gem install berkshelf --no-ri --no-rdo
      chef-zero -d
      cd /vagrant           
      knife environment from file environments/*
      knife node from file nodes/*
      knife role from file roles/* 
      berks upload 
      chef-client
      echo give everything a few seconds to settle down...
      sleep 10
      cp /root/openrc /home/vagrant/openrc
      chown vagrant:vagrant /home/vagrant/openrc
      nova-manage service list
      echo "Run the below to test :-"
      echo "vagrant ssh"
      echo "source /home/vagrant/openrc"
      echo "glance image-create --name cirros --is-public true --container-format bare --disk-format qcow2 --location https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img"
      echo "nova boot omgponies --image cirros --flavor 1"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 1024]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
  end

end
