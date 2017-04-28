version: '2'
services:
  agent:
    image: drone/drone:0.5
    environment:
      DRONE_SERVER: ws://drone:8000/ws/broker
      DRONE_SECRET: ${drone_secret}
    stdin_open: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    tty: true
    links:
      - server:drone
    command:
      - agent
    labels:
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.container.hostname_override: container_name
  server:
    image: drone/drone:0.5
    environment:
      DRONE_SECRET: ${drone_secret}
      DRONE_OPEN: ${drone_open}
      DRONE_ADMIN: ${drone_admins}
      DRONE_ORGS: ${drone_orgs}
{{- if eq .Values.drone_driver "github"}}
      DRONE_GITHUB: true
      DRONE_GITHUB_CLIENT: ${drone_driver_client}
      DRONE_GITHUB_SECRET: ${drone_driver_secret}
{{- end}}
{{- if eq .Values.drone_driver "bitbucket"}}
      DRONE_BITBUCKET: true
      DRONE_BITBUCKET_CLIENT: ${drone_driver_client}
      DRONE_BITBUCKET_SECRET: ${drone_driver_secret}
{{- end}}
{{- if eq .Values.drone_driver "gitlab"}}
      DRONE_GITLAB: ${drone_gitlab}
      DRONE_GITLAB_CLIENT: ${drone_driver_secret}
      DRONE_GITLAB_SECRET: ${drone_driver_secret}
      DRONE_GITLAB_URL: ${drone_driver_url}
{{- end}}
{{- if eq .Values.drone_driver "gogs"}}
      DRONE_GOGS: ${drone_gogs}
      DRONE_GOGS_URL: ${drone_driver_url}
{{- end}}
      DATABASE_DRIVER: ${database_driver}
      DATABASE_CONFIG: ${database_link}
    stdin_open: true
    tty: true
    labels:
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.container.hostname_override: container_name
{{- if eq .Values.database_driver "sqlite3"}}
      io.rancher.sidekicks: server-volume
    volumes_from:
      - server-volume
  server-volume:
    image: rawmind/alpine-volume:0.0.2-1
    environment:
      SERVICE_GID: '0'
      SERVICE_UID: '0'
      SERVICE_VOLUME: /var/lib/drone
    network_mode: none
    volumes:
      - /var/lib/drone
    labels:
      io.rancher.container.start_once: 'true'
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.container.hostname_override: container_name
{{- end}}
  lb:
    image: rancher/load-balancer-service
    ports:
      - ${host_port}:${host_port}/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: 'true'