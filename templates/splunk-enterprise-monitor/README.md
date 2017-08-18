# STCL-Tech Splunk Enterprise Monitor

### Info:

 This custom catalog item presents an STCL-Tech modified installation of Splunk Enterprise Monitor for Docker using the [official Splunk image](https://hub.docker.com/r/splunk/splunk/)

 This image comes with some data inputs activated (e.g., file monitor of docker host JSON logs, HTTP Event Collector, Syslog, etc.). It also includes the Docker app which has dashboards to help you analyze collected logs and docker information such as stats, events, tops, and inspect from your running images.

 Once launched, the Splunk Enterprise Monitor UI will be available at http://<HOST_IP_OR_DNS_NAME>:8000

 *NOTE* UI access is dependent on Rancher host security group rules.
