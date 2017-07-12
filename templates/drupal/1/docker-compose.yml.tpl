version: '2'
services:
  drupal:
    image: drupal:8.3.5-apache
    labels:
      io.rancher.sidekicks: drupal-datavolume
      io.rancher.container.pull_image: always
    links:
      - db:db
    volumes_from:
      - drupal-datavolume
    restart: always

  drupal-datavolume:
    network_mode: none
    image: "busybox"
    volumes:
      # Offitial recommended volumes https://hub.docker.com/_/drupal/ 
      - /var/www/html/modules
      - /var/www/html/profiles
      - /var/www/html/themes
      - /var/www/html/sites
    labels:
      io.rancher.container.start_once: true
    entrypoint: ["/bin/true"]
    volume_driver: local

  drupal-lb:
    image: rancher/lb-service-haproxy
    ports:
      - ${public_port}

  db:
    labels:
      io.rancher.sidekicks: db-datavolume
  {{- if eq .Values.DB_TYPE "postgres"}}
    image: postgres:9.6.3-alpine
    environment:
      POSTGRES_USER:  ${DB_USER}
      POSTGRES_PASSWORD:  ${DB_PASS}
      POSTGRES_DB:  ${DB_NAME}
  {{- end}}
  {{- if eq .Values.DB_TYPE "mysql"}}
    image: mysql:5.7.18
    environment:
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_ROOT_PASSWORD: ${DB_PASS}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASS}
  {{- end}}
    volumes_from:
      - db-datavolume
    restart: always

  db-datavolume:
    network_mode: none
    image: "busybox"
    volumes:
    {{- if eq .Values.DB_TYPE "postgres"}}
      - /var/lib/postgresql
    {{- end}}
    {{- if eq .Values.DB_TYPE "mysql"}}
      - /var/lib/mysql
    {{- end}}
    labels:
      io.rancher.container.start_once: true
    entrypoint: ["/bin/true"]
    volume_driver: local
