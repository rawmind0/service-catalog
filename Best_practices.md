# Best catalog package practices

- Use concrete versions instead of implicit or explicit latest.

docker-compose.yml
```
version: '2'
services:
  service:
    image: <docker_image>:0.0.1
```
Instead of...

docker-compose.yml
```
version: '2'
services:
  service:
    image: <docker_image>:latest
```

Or...

docker-compose.yml
```
version: '2'
services:
  service:
    image: <docker_image>
```

- Use healthchecks

rancher-compose.yml
```
version: '2'
services:
  service:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
 ```

 Instead of...

 rancher-compose.yml
```
version: '2'
services:
  service:
    scale: 1
    retain_ip: true
 ```


- Use lb instead of exposing port directly.

docker-compose.yml
```
version: '2'
services:
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${public_port}:${public_port}
  service:
    image: <docker_image>:<version>
```

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: public_port
      description: "public port to access the service"
      label: "Public Port"
      required: true
      default: "80"
      type: "int"
services:
  lb:
    scale: 1
    lb_config:
      certs: []
      port_rules:
      - protocol: http
        service: service
        source_port: ${public_port}
        target_port: 80
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      port: 42
      unhealthy_threshold: 3
  service:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
 ```

Instead of...

docker-compose.yml
```
version: '2'
services:
  service:
    image: <docker_image>:<version>
    ports:
      - ${public_port}:80
```

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: public_port
      description: "public port to access the service"
      label: "Public Port"
      required: true
      default: "80"
      type: "int"
services:
  service:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
 ```


- Use decoupled volumes with selectable driver.

docker-compose.yml
```
version: '2'
services:
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${public_port}:${public_port}
  service:
    image: <docker_image>:<version>
    volumes:
      - service_data:<PATH>
volumes:
  service_data:
    driver: ${volume_driver}
```

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: public_port
      description: "public port to access the service"
      label: "Public Port"
      required: true
      default: "80"
      type: "int"
    - variable: volume_driver
      description: "Volume driver to use with this service"
      label: "Volume driver"
      required: true
      default: "local"
      type: enum
      options:
        - local
        - rancher-nfs
        - rancher-efs
        - rancher-ebs
services:
  lb:
    scale: 1
    lb_config:
      certs: []
      port_rules:
      - protocol: http
        service: service
        source_port: ${public_port}
        target_port: 80
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      port: 42
      unhealthy_threshold: 3
  service:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
 ```

Instead of...

 docker-compose.yml
```
version: '2'
services:
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${public_port}:${public_port}
  service:
    image: <docker_image>:<version>
    volumes:
      - service_data:<PATH>
volumes:
  service_data:
    driver: <FIXED>
```

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: public_port
      description: "public port to access the service"
      label: "Public Port"
      required: true
      default: "80"
      type: "int"
services:
  lb:
    scale: 1
    lb_config:
      certs: []
      port_rules:
      - protocol: http
        service: service
        source_port: ${public_port}
        target_port: 80
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      port: 42
      unhealthy_threshold: 3
  service:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
 ```

- Use go templating in docker-compose.yml.tpl to allow different deployment modes.

For exampe, if we set public_port variable, we configure and deploy a lb.

docker-compose.yml.tpl
```
version: '2'
services:
{{- if (.Values.public_port)}}
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${public_port}:${public_port}
{{- end}}
  service:
    image: <docker_image>:<version>
    volumes:
      - service_data:<PATH>
volumes:
  service_data:
    driver: ${volume_driver}
```

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: public_port
      description: "public port to access the service"
      label: "Public Port"
      required: false
      default: ""
      type: "int"
    - variable: volume_driver
      description: "Volume driver to use with this service"
      label: "Volume driver"
      required: true
      default: "local"
      type: enum
      options:
        - local
        - rancher-nfs
        - rancher-efs
        - rancher-ebs
services:
  lb:
    scale: 1
    lb_config:
      certs: []
      port_rules:
      - protocol: http
        service: service
        source_port: ${public_port}
        target_port: 80
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      port: 42
      unhealthy_threshold: 3
  service:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
 ```


- Reuse already created packages and link services.

For exampe, if we set db_link variable, we configure our service to connect with an external db. If not, we deploy an internal database service.

docker-compose.yml.tpl
```
version: '2'
services:
{{- if (.Values.public_port)}}
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${public_port}:${public_port}
{{- end}}
  service:
    image: <docker_image>:<version>
    volumes:
      - service_data:<PATH>
{{- if ne .Values.db_link ""}}
    external_links:
      - ${db_link}:db
{{- else}}
  db:
    image: <docker_image>:<version>
    volumes:
      - db_data:<PATH>
{{- end}}
volumes:
  service_data:
    driver: ${volume_driver}
{{- if eq .Values.db_link ""}} 
  db_data:
    driver: ${volume_driver}
{{- end}}
```

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: public_port
      description: "public port to access the service"
      label: "Public Port"
      required: true
      default: "80"
      type: "int"
    - variable: "db_link"
        description: |
          External db link
        label: "External db"
        default: ""
        required: false
        type: "service"
    - variable: volume_driver
      description: "Volume driver to use with this service"
      label: "Volume driver"
      required: true
      default: "local"
      type: enum
      options:
        - local
        - rancher-nfs
        - rancher-efs
        - rancher-ebs
services:
  lb:
    scale: 1
    lb_config:
      certs: []
      port_rules:
      - protocol: http
        service: service
        source_port: ${public_port}
        target_port: 80
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      port: 42
      unhealthy_threshold: 3
  service:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
 ```

