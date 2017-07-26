# [ReactionCommerce](http://reactioncommerce.com/)

### Docs

The Reaction Commerce official docs are
[here](https://docs.reactioncommerce.com/)

This template implements the same method as found
[here](https://docs.reactioncommerce.com/reaction-docs/master/deploying-reaction-using-docker)

### MongoDB

This initial version pulls up its own mongodb just like the official
docker-compose.yml, if you have a mongo stack already running try the
`1.4.0-rancher2` version

### Traefik

For external access you'll need to setup [traefik](https://github.com/rancher/community-catalog/tree/master/templates/traefik), all the appropriate
labels will be set when you set the hostname and domain below

### Support

There are experimental versions of this template in this catalog [here](https://github.com/ohmydocker/ohmydocker-catalog) which implement
other setups.  Issues, PRs, etc are welcome there.
