# Artifactory 
	
Artifactory is a universal Binary Repository Manager for use by build tools (like Maven and Gradle), 
dependency management tools (like Ivy and NuGet) and build servers (like Jenkins, Hudson, TeamCity and Bamboo).
 
Repository managers serve two purposes: they act as highly configurable proxies between your organization and 
external repositories and they also provide build servers with a deployment destination for your internally 
generated artifacts.


version: '2'
services:
  test:
    image: rawmind/rancher-tools:3.5-3
    stdin_open: true
    entrypoint:
    - /bin/bash
    volumes:
    - /etc/haproxy/certs
    - /opt/tools
    tty: true
    labels:
      io.rancher.container.agent.role: system
      io.rancher.container.start_once: 'true'
      io.rancher.container.create_agent: 'true'
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
    - 8080:8080/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.sidekicks: test
      io.rancher.container.create_agent: 'true'
  web-test:
    log_driver: ''
    labels:
      traefik.domain: local,internal
      traefik.port: '8080'
      traefik.enable: 'true'
      traefik.alias: 'web1,web2'
      traefik.acme: 'false'
      traefik.sticky: 'false'
      io.rancher.container.hostname_override: container_name
    tty: true
    log_opt: {}
    image: rawmind/web-test



version: '2'
services:
  lb:
    scale: 1
    lb_config:
      certs: []
      default_cert: "artifactory"
      port_rules:
      - protocol: https
        service: web-test
        source_port: 8080
        target_port: 8080
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      port: 42
      unhealthy_threshold: 3