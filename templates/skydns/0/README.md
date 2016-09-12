# Skydns (Experimental)

### Info:

 This template deploys a skydns service.
 
 
### Usage:

 Select skydns from catalog. 

 Change the following skydns default parameters, if you need:

- skydns_scale=3
- skydns_etcd="http://etcd:2379"	# Multiple values separated by ,
- skydns_addr="0.0.0.0:53"
- skydns_domain="dev.local"
- skydns_nameservers="8.8.8.8:53,8.8.4.4:53"
- skydns_path_prefix="skydns"
- skydns_ndots="2"
 
 Click deploy.
 
 skydns can now be accessed over the Rancher network. 

