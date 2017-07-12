# Drupal

### Info:

This template creates a drupal server and its database.

You could choose between mysql or postgres as database. 


### Usage:

Select Drupal from catalog.

- Choose public port, exposed throught a rancher lb.
- Choose db type.
- Set db name, username and password.
- Click launch.

IMPORTANT: Database is linked to drupal server with "db" hostname. Set ADVANCED OPTIONS - Database host: db
 

### Source, bugs and enhances

 If you found bugs or need enhance, you can open ticket on github:
 - [Drupal official site](https://www.drupal.org/)
 - [Drupal Server docker image](https://hub.docker.com/_/drupal/)
 - [Mysql Server docker image](https://hub.docker.com/_/mysql/)
 - [Postgres Server docker image](https://hub.docker.com/_/postgres/)