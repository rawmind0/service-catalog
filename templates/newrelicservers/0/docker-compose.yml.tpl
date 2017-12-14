newrelic-servers:
  environment:
    NEW_RELIC_LICENSE_KEY: ${NEW_RELIC_LICENSE_KEY}
{{- if (.Values.FORWARD_PROXY)}}
    FORWARD_PROXY: ${FORWARD_PROXY}
{{- end}}
  labels:
    io.rancher.scheduler.global: 'true'
    io.rancher.container.pull_image: always
    io.rancher.scheduler.affinity:host_label_ne: ${HOST_EXCLUDE_LABEL}
  tty: true
  image: uzyexe/newrelic:2.3.0.132
  volumes:
  - /dev:/dev
  - /sys/fs/cgroup:/sys/fs/cgroup:ro
  - /var/run/docker.sock:/var/run/docker.sock:ro
  stdin_open: true
  net: host
