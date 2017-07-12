# Drupal

### Info

This template creates a drupal server and its database.

You could choose between mysql or postgres as database. 


### Usage

Select Drupal from catalog.

- Choose public port, exposed throught a rancher lb.
- Choose db type.
- Set db name, username and password.
- Click launch.

### Configuration

When you first connect to drupal, follow the navigation path configuring correct database backend, mysql or postgres.

On both cases, database is linked to drupal server with "db" hostname. Set ADVANCED OPTIONS - Database host: db
 

### References

 - [Drupal official site](https://www.drupal.org/)
 - [Drupal Server docker image](https://hub.docker.com/_/drupal/)
 - [Mysql Server docker image](https://hub.docker.com/_/mysql/)
 - [Postgres Server docker image](https://hub.docker.com/_/postgres/)
 - [Rancher Load Balancers](http://rancher.com/docs/rancher/v1.6/en/cattle/adding-load-balancers/)