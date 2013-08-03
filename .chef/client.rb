chef_validation_client_name   = ENV['chef_validation_client_name'] || "chef-validator"
chef_validation_key           = ENV['chef_validation_key'] || "//etc/chef/client.pem"
#chef_server_url               = ENV['chef_server_url'] || "https://chef"
chef_server_url               = ENV['chef_server_url'] || "http://localhost:8889"

log_level                   :info
log_location                STDOUT
chef_server_url             chef_server_url
validation_client_name      chef_validation_client_name
validation_key              chef_validation_key