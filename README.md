breakerbox-docker
==================

This role runs [Breakerbox] container to provide a dashboard and dynamic config
tool for micro-service containers registered with Consul. 
(It is assumed that the micro-service application is instrumented with Tenacity 
library.)
It uses consul-template to create auto-generate breakerbox config.properties file.

In the context of service object as explained in [Registrator] documentation, 
note that each listening port is considered a service.

## Assumptions

This role assumes that 
- Docker Engine is installed *locally*
- service discovery backend is Consul
- services are registered on Consul using [Registrator]
- consul-template is installed and running as a service.  You may choose to 
  apply `wunzeco.consul-template` role to help with this but it is not enforced 
  as a dependency of this role to allow you the flexibility of installing
  consul-template by any means of your choosing.

So it may help to familiarise yourself with Registrator, consul and consul-template.


## Example

Run breakerbox container and create config.properties for a service (say 
servicename is `myapp-8080`)

```
- hosts: myhost

  vars:
    breakerbox_docker_consul_host: "<consul_host_ip|fqdn>"
    breakerbox_docker_consul_port: 8500
    breakerbox_docker_service_name: "myapp-8080"

  roles:
    - wunzeco.breakerbox-docker

```

> **IMPORTANT to note:**
>
>    Registrator considers anything listening on a port a **service**. So if a
>    container listens on multiple ports, it has multiple services.
>    (source: http://gliderlabs.com/registrator/latest/user/services/)

## Dependencies
none

[Registrator]: http://gliderlabs.com/registrator/latest/
[Breakerbox]: https://github.com/yammer/breakerbox
