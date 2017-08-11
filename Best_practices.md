# Best catalog package practices


## First steps 

Lets start with a simple example of a web service with a db for persistence. 

- Simplest initial package:

docker-compose.yml
```
version: '2'
services:
  web:
    image: <web_image>:latest
    ports:
      - ${web_port}:80
    environment:
      DB_HOST: db
      DB_PORT: ${db_port}
      DB_NAME: demo
      DB_USER: user
      DB_PASS: pass
    links:
      - db:db
  db:
    image: <db_image>
    ports:
      - ${db_port}:${db_port}
    environment:
      DB_PORT: ${db_port}
      DB_NAME: demo
      DB_USER: user
      DB_PASS: pass
```

Note: DB_HOST could be static value. db link is the variable part.

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: web_port
      description: "public port to access the web"
      label: "Web Port"
      required: true
      default: "80"
      type: "int"
    - variable: db_port
      description: "public port to access the db"
      label: "Db Port"
      required: true
      default: "3306"
      type: "int"
services:
  web:
    scale: 1
    retain_ip: true
  db:
    scale: 1
    retain_ip: true
```

## Best practices

- Use concrete images versions 

Packages has to be easy reproducible and latest isn't.

docker-compose.yml
```
.
.
    image: <web_image>:<web_version>
.
.
    image: <db_image>:<db_version>

```

- Use healthchecks

Tcp and http healtchecks are available. 
When you start a service with healthcheck, service has an additional state that is ```Initializing```, that is the time between you start the container until service is started. Once healthcheck return ok, service state transition from ```Initializing``` to ```Started```.


rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: web_port
      description: "public port to access the web"
      label: "Web Port"
      required: true
      default: "80"
      type: "int"
    - variable: db_port
      description: "public port to access the db"
      label: "Db Port"
      required: true
      default: "3306"
      type: "int"
services:
  web:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      initializing_timeout: 60000
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
      reinitializing_timeout: 60000
  db:
    scale: 1
    retain_ip: true
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: ${db_port}
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      strategy: recreate
      reinitializing_timeout: 60000
```

*Note: If your service take mora than 60 seconds to start, adjust accordingly ```initializing_timeout (ms)``` and ```reinitializing_timeout (ms)``` in healtcheck parameters.

- Use variables with default values 

Due to versatility, don't hardcode variables, use variables with default values instead.

docker-compose.yml
```
version: '2'
services:
  web:
    image: <web_image>:<web_version>
    ports:
      - ${web_port}:80
    environment:
      DB_HOST: db
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
    links:
      - db:db
  db:
    image: <db_image>:<db_version>
    ports:
      - ${db_port}:${db_port}
    environment:
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
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
    - variable: web_port
      description: "public port to access the web"
      label: "Web Port"
      required: true
      default: "80"
      type: "int"
    - variable: db_port
      description: "public port to access the db"
      label: "Db Port"
      required: true
      default: "3306"
      type: "int"
    - variable: db_name
      description: "db name to connect"
      label: "Db Name"
      required: true
      default: "demo"
      type: "string"
    - variable: db_user
      description: "db user to auth"
      label: "Db User"
      required: true
      default: "user"
      type: "string"
    - variable: db_pass
      description: "db pass to auth"
      label: "Db Password"
      required: true
      default: "pass"
      type: "password"
services:
  web:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      initializing_timeout: 60000
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
      reinitializing_timeout: 60000
  db:
    scale: 1
    retain_ip: true
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: ${db_port}
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      strategy: recreate
      reinitializing_timeout: 60000
```

- Use loadbalancers

Instead of exposing port directly from the service docker, use lb.

docker-compose.yml
```
version: '2'
services:
  web:
    image: <web_image>:<web_version>
    environment:
      DB_HOST: db
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
    links:
      - db:db
  db:
    image: <db_image>:<db_version>
    environment:
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${web_port}:${web_port}/tcp
      - ${db_port}:${db_port}/tcp
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
    - variable: web_port
      description: "public port to access the web"
      label: "Web Port"
      required: true
      default: "80"
      type: "int"
    - variable: db_port
      description: "public port to access the db"
      label: "Db Port"
      required: true
      default: "3306"
      type: "int"
    - variable: db_name
      description: "db name to connect"
      label: "Db Name"
      required: true
      default: "demo"
      type: "string"
    - variable: db_user
      description: "db user to auth"
      label: "Db User"
      required: true
      default: "user"
      type: "string"
    - variable: db_pass
      description: "db pass to auth"
      label: "Db Password"
      required: true
      default: "pass"
      type: "password"
services:
  web:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      initializing_timeout: 60000
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
      reinitializing_timeout: 60000
  db:
    scale: 1
    retain_ip: true
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: ${db_port}
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      strategy: recreate
      reinitializing_timeout: 60000
  lb:
    scale: 1
    start_on_create: true
    lb_config:
      certs: []
      port_rules:
      - priority: 1
        protocol: http
        service: web
        source_port: ${web_port}
        target_port: 80
      - priority: 2
        protocol: tcp
        service: db
        source_port: ${db_port}
        target_port: ${db_port}
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: 42
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      reinitializing_timeout: 60000
```

- Expose just needed ports

Do you really need to expose db port?? Probably not....  

docker-compose.yml
```
version: '2'
services:
  web:
    image: <web_image>:<web_version>
    environment:
      DB_HOST: db
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
    links:
      - db:db
  db:
    image: <db_image>:<db_version>
    environment:
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${web_port}:${web_port}/tcp
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
    - variable: web_port
      description: "public port to access the web"
      label: "Web Port"
      required: true
      default: "80"
      type: "int"
    - variable: db_port
      description: "public port to access the db"
      label: "Db Port"
      required: true
      default: "3306"
      type: "int"
    - variable: db_name
      description: "db name to connect"
      label: "Db Name"
      required: true
      default: "demo"
      type: "string"
    - variable: db_user
      description: "db user to auth"
      label: "Db User"
      required: true
      default: "user"
      type: "string"
    - variable: db_pass
      description: "db pass to auth"
      label: "Db Password"
      required: true
      default: "pass"
      type: "password"
services:
  web:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      initializing_timeout: 60000
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
      reinitializing_timeout: 60000
  db:
    scale: 1
    retain_ip: true
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: ${db_port}
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      strategy: recreate
      reinitializing_timeout: 60000
  lb:
    scale: 1
    start_on_create: true
    lb_config:
      certs: []
      port_rules:
      - priority: 1
        protocol: http
        service: web
        source_port: ${web_port}
        target_port: 80
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: 42
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      reinitializing_timeout: 60000
```

- Use volumes

Depending of the service, may need volumes to manage persistence properly. 
Package would be more versatile if you could choose different drivers for neede volumes.

docker-compose.yml
```
version: '2'
services:
  web:
    image: <web_image>:<web_version>
    volumes:
      - web_data:<PATH>
    environment:
      DB_HOST: db
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
    links:
      - db:db
  db:
    image: <db_image>:<db_version>
    volumes:
      - db_data:<PATH>
    environment:
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${web_port}:${web_port}/tcp
volumes:
  web_data:
    driver: ${volume_driver}
  db_data:
    driver: ${volume_driver}
    per_container: true
```

Note: use volumes ```per_container: true``` if every service instance needs a volume.

rancher-compose.yml
```
version: '2'
catalog:
  name: <name>
  version: <version>
  description: <description>
  uuid: <uuid>
  questions:    
    - variable: web_port
      description: "public port to access the web"
      label: "Web Port"
      required: true
      default: "80"
      type: "int"
    - variable: db_port
      description: "public port to access the db"
      label: "Db Port"
      required: true
      default: "3306"
      type: "int"
    - variable: db_name
      description: "db name to connect"
      label: "Db Name"
      required: true
      default: "demo"
      type: "string"
    - variable: db_user
      description: "db user to auth"
      label: "Db User"
      required: true
      default: "user"
      type: "string"
    - variable: db_pass
      description: "db pass to auth"
      label: "Db Password"
      required: true
      default: "pass"
      type: "password"
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
  web:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      initializing_timeout: 60000
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
      reinitializing_timeout: 60000
  db:
    scale: 1
    retain_ip: true
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: ${db_port}
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      strategy: recreate
      reinitializing_timeout: 60000
  lb:
    scale: 1
    start_on_create: true
    lb_config:
      certs: []
      port_rules:
      - priority: 1
        protocol: http
        service: web
        source_port: ${web_port}
        target_port: 80
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: 42
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      reinitializing_timeout: 60000
```



- Use go templating 

Latests catalog version permits to use go templating in docker-compose.yml to allow scripting in packages. Its needed to rename docker-compose.yml to docker-compose.yml.tpl

Example feature: 
Reuse already created db packages and link service, instead of deploying db service.

For exampe, if we set db_link variable, we configure our service to connect with an external db. If not, we deploy an internal database service.

docker-compose.yml.tpl
```
version: '2'
services:
  web:
    image: <web_image>:<web_version>
    volumes:
      - web_data:<PATH>
    environment:
      DB_HOST: db
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
{{- if ne .Values.db_link ""}}
    external_links:
      - ${db_link}:db
{{- else}}
    links:
      - db:db
  db:
    image: <db_image>:<db_version>
    volumes:
      - db_data:<PATH>
    environment:
      DB_PORT: ${db_port}
      DB_NAME: ${db_name}
      DB_USER: ${db_user}
      DB_PASS: ${db_pass}
{{- end}}
  lb:
    image: rancher/lb-service-haproxy:v0.6.4
    ports:
      - ${web_port}:${web_port}/tcp
volumes:
  web_data:
    driver: ${volume_driver}
{{- if eq .Values.db_link ""}} 
  db_data:
    driver: ${volume_driver}
    per_container: true
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
    - variable: web_port
      description: "public port to access the web"
      label: "Web Port"
      required: true
      default: "80"
      type: "int"
    - variable: db_port
      description: "public port to access the db"
      label: "Db Port"
      required: true
      default: "3306"
      type: "int"
    - variable: db_name
      description: "db name to connect"
      label: "Db Name"
      required: true
      default: "demo"
      type: "string"
    - variable: db_user
      description: "db user to auth"
      label: "Db User"
      required: true
      default: "user"
      type: "string"
    - variable: db_pass
      description: "db pass to auth"
      label: "Db Password"
      required: true
      default: "pass"
      type: "password"
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
    - variable: "db_link"
      description: |
        External db link
      label: "External db"
      default: ""
      required: false
      type: "service"
services:
  web:
    scale: 1
    retain_ip: true
    health_check:
      port: 80
      interval: 5000
      unhealthy_threshold: 3
      initializing_timeout: 60000
      request_line: 'GET / HTTP/1.0'
      healthy_threshold: 2
      response_timeout: 5000 
      reinitializing_timeout: 60000
  db:
    scale: 1
    retain_ip: true
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: ${db_port}
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      strategy: recreate
      reinitializing_timeout: 60000
  lb:
    scale: 1
    start_on_create: true
    lb_config:
      certs: []
      port_rules:
      - priority: 1
        protocol: http
        service: web
        source_port: ${web_port}
        target_port: 80
    health_check:
      healthy_threshold: 2
      response_timeout: 2000
      port: 42
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      reinitializing_timeout: 60000
```
