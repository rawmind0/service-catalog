version: '2'
services:
  keepalived-master:
    restart: always
    image: arcts/keepalived:1.1.0
    network_mode: host
    cap_add:
      - NET_ADMIN
    environment:
      KEEPALIVED_AUTOCONF: true
      KEEPALIVED_STATE: MASTER
      KEEPALIVED_INTERFACE: ${interface}
      KEEPALIVED_VIRTUAL_ROUTER_ID: ${router_id}
      KEEPALIVED_UNICAST_SRC_IP: ${master_ip}
      KEEPALIVED_UNICAST_PEER_0: ${backup_ip}
      KEEPALIVED_TRACK_INTERFACE_1: ${interface}
      KEEPALIVED_VIRTUAL_IPADDRESS_1: "${virtual_ip}"
    labels:
      io.rancher.scheduler.affinity:host_label: ${host_label}=${master_label}
    {{- if eq .Values.UPDATE_SYSCTL "true" -}}
      io.rancher.sidekicks: keepalived-sysctl
    {{- end}}
  keepalived-backup:
    restart: always
    image: arcts/keepalived:1.1.0
    network_mode: host
    cap_add:
      - NET_ADMIN
    environment:
      KEEPALIVED_AUTOCONF: true
      KEEPALIVED_STATE: BACKUP
      KEEPALIVED_INTERFACE: ${interface}
      KEEPALIVED_VIRTUAL_ROUTER_ID: ${router_id}
      KEEPALIVED_UNICAST_SRC_IP: ${backup_ip}
      KEEPALIVED_UNICAST_PEER_0: ${master_ip}
      KEEPALIVED_TRACK_INTERFACE_1: ${interface}
      KEEPALIVED_VIRTUAL_IPADDRESS_1: "${virtual_ip}"
    labels:
      io.rancher.scheduler.affinity:host_label: ${host_label}=${backup_label}
{{- if eq .Values.UPDATE_SYSCTL "true" }}
      io.rancher.sidekicks: keepalived-sysctl
  keepalived-sysctl:
    labels:
      io.rancher.container.start_once: true
    network_mode: none  
    image: rawmind/alpine-sysctl:0.1-1
    privileged: true
    environment: 
      - "SYSCTL_KEY=net.ipv4.ip_nonlocal_bind" 
      - "SYSCTL_VALUE=1"
{{- end}}
