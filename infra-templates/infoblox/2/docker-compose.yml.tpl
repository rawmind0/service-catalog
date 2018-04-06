version: '2'
services:
  infoblox:
    image: rancher/external-dns:v0.7.10
    command: -provider=infoblox
    expose:
     - 1000
    environment:
      INFOBLOX_URL: ${INFOBLOX_URL}
      INFOBLOX_USER_NAME: ${INFOBLOX_USER_NAME}
      INFOBLOX_PASSWORD: ${INFOBLOX_PASSWORD}
      INFOBLOX_SECRET: '/run/secrets/infoblox-pass'
      ROOT_DOMAIN: ${ROOT_DOMAIN}
      SSL_VERIFY: ${SSL_VERIFY}
      USE_COOKIES: ${USE_COOKIES}
      TTL: ${TTL}
    labels:
      io.rancher.container.create_agent: "true"
      io.rancher.container.agent.role: "external-dns"
{{- if eq .Values.INFOBLOX_PASSWORD ""}}
    secrets:
      - mode: '0444'
        uid: '0'
        gid: '0'
        source: 'infoblox-pass'
        target: ''
secrets:
  infoblox-pass:
    external: 'true' 
{{- end}}
