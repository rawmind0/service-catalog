# Vamp Gateway Agent (Experimental)

### Info:

 This template creates vamp gateway agent (vga) on top of Rancher. The configuration is generated with automatically from Rancher metadata. 
 
 
### Usage:

 Select vamp-gateway-agent from catalog. 

 Select the number of vga's nodes to create.

 Change the following vamp default parameters, if you need:

 - vga_scale: "1"				#Number of vga's to deploy.
 - vga_key_type: "zookeeper"	#Vga key store backend: zookeeper | etcd | consul
 - vga_key_port: "2181"			#Vga key port to connect to
 - vga_key: "zookeeper/zk"		#Vga key service to link to (Must be deployed before from the catalog)
 - vga_logstash_port: "10001"	#Vga logstash port to connect
 - vga_logstash: "logstash/logstash-collector"		#Vga logstash service to connect to
 
 Click deploy.
 
 Vga can now be accessed over the Rancher network. 
