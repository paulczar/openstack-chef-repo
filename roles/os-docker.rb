name "os-docker"
description "configure nova node to run docker drivers"
run_list(
  "role[os-base]",
  "recipe[docker]",
  "recipe[openstack-docker::nova-driver]",
  "recipe[openstack-docker::glance-db-backend]"
)