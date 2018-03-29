version: '2'
services:
  infoblox:
    image: rancher/external-dns:v0.7.8
    expose:
     - 1000
    environment:
      INFOBLOX_URL: ${INFOBLOX_URL}
      INFOBLOX_USER_NAME: ${INFOBLOX_USER_NAME}
      INFOBLOX_PASSWORD: ${INFOBLOX_PASSWORD}
      INFOBLOX_SECRET: '/run/secrets/${INFOBLOX_SECRET}'
      ROOT_DOMAIN: ${ROOT_DOMAIN}
      SSL_VERIFY: ${SSL_VERIFY}
      USE_COOKIES: ${USE_COOKIES}
      TTL: ${TTL}
    labels:
      io.rancher.container.create_agent: "true"
      io.rancher.container.agent.role: "external-dns"
    {{- if eq .Values.INFOBLOX_SECRET ""}}
    command: -provider=infoblox
    {{- else}}
    entrypoint:
      - bash
      - -c
      - 'INFOBLOX_PASSWORD=$$(cat $${INFOBLOX_SECRET}) /usr/bin/rancher-entrypoint.sh -provider=infoblox'
    secrets:
      - mode: '0444'
        uid: '0'
        gid: '0'
        source: '${INFOBLOX_SECRET}'
        target: ''
secrets:
  ${INFOBLOX_SECRET}:
    external: 'true' 
  {{- end}}
