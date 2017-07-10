## What is inside Bamboo Stack?
* [Bamboo Server](https://hub.docker.com/r/matisq/bamboo-server/) + Sidekick with volume data
* Postgres Database + Sidekick with volume data
* [Scalable Bamboo Agents](https://hub.docker.com/r/matisq/bamboo-agent/)
* Load Balancer used for Bamboo Server

## Info
* In default Bamboo stack will create `bamboo` postgres database with `bamboo` user.  
* Additional variables `http_proxy` and `https_proxy` are included, which can be helpful in some cases.
* Once Bamboo Server will start, make sure you setup correct information in setup page.
* For easy upgrades there are sidekicks for both Postgres and Bamboo Server with dedicated storage.

## Bamboo Agents
Bamboo Agents will start automatically and connect to the Bamboo Server.  
Agents should be available in Bamboo Server in about 5 minutes after stack's start.

## How to setup Bamboo Stack in Rancher?
* Here you can find information how to setup Bamboo CI env: [How to setup Bamboo Stack in Rancher](https://github.com/matisku/bamboo-docker/blob/master/doc/README.md)
