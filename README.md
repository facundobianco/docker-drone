## Docker container for Drone 0.4

I created this container because [official docker image](https://hub.docker.com/r/drone/drone)
doesn't work on my Debian 8.3 relese ([issue #1466](https://github.com/drone/drone/issues/1466)).

This *drone* is building from source into a cointainer following the 
[instructions](https://github.com/drone/drone#from-source) from the Drone team.

## Apache2.4 virtualhost

I attached the [configuration](001-drone.conf) for running
Drone behind Apache reverse proxy (instead of [NGinx](http://readme.drone.io/setup/misc/nginx)).

Before to start Apache, you should load those modules

```
for MODN in headers proxy proxy_http ssl ; do a2enmod ${MODN} ; done
```

## How to run it

```
docker build -t drone1466 .
docker run -v /var/lib/drone:/var/lib/drone /var/lib/drone:/var/lib/drone \
           -v /var/run/docker.sock:/var/run/docker.sock \
           --env-file /etc/drone/dronerc \
           -p 127.0.0.1:8000:8000 \
           -d --restart=always --name=drone drone1466
```
