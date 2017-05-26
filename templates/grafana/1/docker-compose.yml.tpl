version: '2'
services:
  grafana:
    image: grafana/grafana:4.3.1
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${admin_password}
      GF_SECURITY_ADMIN_USER: ${admin_username}
      GF_SECURITY_SECRET_KEY: ${secret_key}
      GF_SERVER_DOMAIN: ${http_host}
      GF_SERVER_ROOT_URL: ${http_protocol}://${http_host}
      {{- if (.Values.extra_params) }}
      ${extra_params}
      {{- end}}
    labels: 
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.container.hostname_override: container_name
      io.rancher.sidekicks: grafana-volume
  grafana-lb:
    image: rancher/lb-service-haproxy:v0.7.1
    ports:
    - 443:443/tcp
    - 80:80/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: 'true'
  grafana-volume:
    network_mode: none
    labels:
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.container.hostname_override: container_name
      io.rancher.container.start_once: true
    environment:
      - SERVICE_UID=0
      - SERVICE_GID=0
      - SERVICE_VOLUME=/var/lib/grafana
    volumes:
      - grafana-volume:/var/lib/grafana
    image: rawmind/alpine-volume:0.0.2-1
volumes:
  grafana-volume:
    driver: local
    per_container: true
