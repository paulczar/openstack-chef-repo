# Description #

This repository contains examples of the roles, environments and other supporting files for deploying an OpenStack **Grizzly** reference architecture using Chef. This currently includes the 7 OpenStack core projects: Compute, Dashboard, Identity, Image, Network, Object and Block Storage.

Development of the latest Stable release will continue on the `master` branch and releases tagged with `7.0.X`. Once development starts against OpenStack `master` or `havana`, this branch will move to `grizzly` and the appropriate branches will continue development.

The documentation has been moved to the https://github.com/mattray/chef-docs repository for merging to https://github.com/opscode/chef-docs and eventual release to https://docs.opscode.com. Instructions for building the docs are included in the repository. There is additional documentation on the [OpenStack wiki](https://wiki.openstack.org/wiki/Chef/GettingStarted).

# Usage #

This repository uses Berkshelf (https://berkshelf.com) to manage downloading all of the proper cookbook versions, whether from Git or from the Opscode Community site (https://community.opscode.com). The preference is to eventually upstream all cookbook dependencies to the Opscode Community site. The [Berksfile](Berksfile) lists the current dependencies.

There is a Spiceweasel (http://bit.ly/spcwsl) [infrastructure.yml](infrastructure.yml) manifest documenting all the roles and environments required to deploy OpenStack.

To see the commands necessary to push all of the files to the Chef server, run the following command:

```
spiceweasel infrastructure.yml
```

To actually deploy the repository to your Chef server, run the following command:

```
spiceweasel -e infrastructure.yml
```

# Vagrant #

This repository can be used with Vagrant ( 1.2.1+ ).

Requires `vagrant-omnibus`, `vagrant-berkshelf`, `vagrant-cachier` vagrant plugins.
 
Uses a box I created that has some of the packages needed for the environment preinstalled. - https://s3.amazonaws.com/paul-cz-misc/stackforge-openstack.box.

If you wish to use a local box ( ubuntu 12.04 ) you can run this first `export BOX_NAME=precise64`,  or update it in the `Vagrantfile`  this will not only load your box but signal berkshelf and chef-solo to install any needed packages.

Example Usage:

```
git clone git@github.com:paulczar/openstack-chef-repo.git -b vagrant 
cd openstack-chef-repo
vagrant up
```


This will load up a vagrant VM using `Berkshelf-vagrant` to bootstrap it via Berkshelf and start a chef-zero service and then will load up the nodes, environment and roles to configure the infrastructure as explained above.

It will then run `chef-client` to configure itself as an all-in-one openstack server.

once running you can do the following:

```
vagrant ssh
source /home/vagrant/openrc
glance image-create --name cirros --is-public true --container-format bare --disk-format qcow2 --location https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img
nova boot omgponies --image cirros --flavor 1
```

# Cookbooks #

The cookbooks have been designed and written in such a way that they can be used to deploy individual service components on _any_ of the nodes in the infrastructure; in short they can be used for single node 'all-in-one' installs (for testing), right up to multi/many node production installs. In order to achieve this flexibility, they are configured by attributes which may be used to override search. Chef 10 or later is currently required, but the intention is to [move to Chef 11 with the `havana` release](https://bugs.launchpad.net/openstack-chef/+bug/1183540) to take advantage of features such as [partial search](http://docs.opscode.com/essentials_search_partial.html). Ruby 1.9.x is considered the minimum supported version of Ruby as well. Most users of this repository test with the full-stack Chef 11 client and a Chef server (Chef Solo is not explicity supported).

Each of the OpenStack services has its own cookbook and will eventually be available on the Chef Community site.

## OpenStack Block Storage ##

http://github.com/stackforge/cookbook-openstack-block-storage/

There is further documentation in the [OpenStack Block Storage cookbook README](http://github.com/stackforge/cookbook-openstack-block-storage/).

## OpenStack Compute ##

http://github.com/stackforge/cookbook-openstack-compute/

There is further documentation in the [OpenStack Compute cookbook README](http://github.com/stackforge/cookbook-openstack-compute/).

## OpenStack Dashboard ##

http://github.com/stackforge/cookbook-openstack-dashboard/

There is further documentation in the [OpenStack Dashboard cookbook README](http://github.com/stackforge/cookbook-openstack-dashboard/).

## OpenStack Identity ##

http://github.com/stackforge/cookbook-openstack-identity/

There is further documentation in the [OpenStack Identity cookbook README](http://github.com/stackforge/cookbook-openstack-identity/).

## OpenStack Image ##

http://github.com/stackforge/cookbook-openstack-image/

There is further documentation in the [OpenStack Image cookbook README](http://github.com/stackforge/cookbook-openstack-image/).

## OpenStack Network ##

Http://github.com/stackforge/cookbook-openstack-network/

There is further documentation in the [OpenStack Network cookbook README](http://github.com/stackforge/cookbook-openstack-network/).

## OpenStack Object Storage ##

http://github.com/stackforge/cookbook-openstack-object-storage/

There is further documentation in the [OpenStack Object Storage cookbook README](http://github.com/stackforge/cookbook-openstack-object-storage/).

# License and Author #

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author**           | Matt Ray (<matt@opscode.com>)            |
|                      |                                          |
| **Copyright**        | Copyright (c) 2011-2013 Opscode, Inc.    |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
