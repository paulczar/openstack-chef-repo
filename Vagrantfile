# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "Use a newer version of Vagrant (1.2.1+)"
end


# Allows us to pick a different box by setting Environment Variables
BOX_NAME = ENV['BOX_NAME'] || "stackforge-openstack"
#BOX_NAME = ENV['BOX_NAME'] || "precise64"
BOX_URI = ENV['BOX_URI'] || "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"

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


  config.vm.define :chef do |config|
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.hostname = "chef"
    config.vm.network :private_network, ip: "33.33.33.50"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = {
          "chef-server" => {
              "version" => :latest
          }
      }
      chef.run_list = [
        "recipe[chef-server::default]"
      ]
    end

    config.vm.provision :shell, :inline => <<-SCRIPT
        mkdir -p /vagrant/.chef
        cp /etc/chef-server/admin.pem /vagrant/.chef/
        cp /etc/chef-server/chef-validator.pem /vagrant/.chef/
        chown vagrant /vagrant/.chef/*
        apt-get -y install libxslt-dev libxml2-dev # stupid Nokogiri!
        gem install spiceweasel --no-ri --no-rdo
        echo "Chef server installed!!"
        echo "Running Spiceweasel to upload and configure cookbooks"
        echo "This will take some time ... be patient."
        mkdir -p ~/.berkshelf
        cd /vagrant
        spiceweasel --execute /vagrant/infrastructure.yml
        cd /vagrant/nodes/; for i in $(ls *.json); do knife node from file $i; done
    SCRIPT
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", 2]
        vb.customize ["modifyvm", :id, "--memory", 1024]
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
      echo 33.33.33.50 chef >> /etc/hosts
      mkdir -p /etc/chef
      cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
      cp /vagrant/.chef/client.rb /etc/chef/client.rb
      chef-client
      #echo "restart all the services for shits n giggles..."
      #cd /etc/init.d/; for i in $(ls nova-*); do service $i restart; done
      #sleep 10
      sudo nova-manage service list
      echo "##################################"
      echo "#     Openstack Installed        #"
      echo "#   visit https://33.33.33.60    #"
      echo "#   default username: admin      #"
      echo "#   default password: admin      #"
      echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 1024]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
  end

#  I used this to create the stackforge-openstack box 
#  config.vm.define :base do |config|
#    config.vm.hostname = "base"
#    config.vm.box = "precise64"
#    config.vm.box_url = BOX_URI
#    config.ssh.max_tries = 40
#    config.ssh.timeout   = 120
#    config.ssh.forward_agent = true
#  end

end
