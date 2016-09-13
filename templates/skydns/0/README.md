# Skydns (Experimental)

### Info:

 This template deploys a skydns service.
 
 
### Usage:

 Select skydns from catalog. 

 Change the following skydns default parameters, if you need:

- skydns_scale=3					# Service scale
- skydns_etcd="http://etcd:2379"	# Multiple values separated by ,
- skydns_addr="0.0.0.0:53"			# Address to bind
- skydns_domain="dev.local"			# Skydns authorizative domain
- skydns_no_rec="true"				# Disable skydns forward recursion
- skydns_nameservers=""				# Dns forwarders. <host>:<port> Multiple values separated by ,
- skydns_path_prefix="skydns"		# skydns etcd prefix
- skydns_ndots="1"					# Minimum dot at name to forward query
 
 Click deploy.
 
 skydns can now be accessed over the Rancher network. 

