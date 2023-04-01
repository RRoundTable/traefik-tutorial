# traefik and prometheus 

![](https://doc.traefik.io/traefik/assets/img/quickstart-diagram.png)

Traefik creates, for each container, a corresponding service and router.

![](https://doc.traefik.io/traefik/assets/img/routers.png)

- The [service](https://doc.traefik.io/traefik/routing/services/) automatically gets a server per instance of the container
- A [router](https://doc.traefik.io/traefik/routing/routers/) is in charge of connecting incoming requests to the services that can handle them. In the process, routers may use pieces of middleware to update the request, or act before forwarding the request to the service.


## Setup


Create  traefik and whoami service and prometheus.

```
docker compose up
```

Add host `whoami.com` to `/etc/host`

```
127.0.0.1   whoami.local 
```

## Test

Click http://whoami.local/


## Reference

- https://doc.traefik.io/traefik/reference/dynamic-configuration/docker/
- https://doc.traefik.io/traefik/routing/routers/#rule
