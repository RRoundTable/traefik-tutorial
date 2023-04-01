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

Add host `grafana.localhost` to `/etc/host`

```
127.0.0.1   grafana.localhost 
```

## Test

Click http://grafana.localhost

ID: admin
PW: foobar

Click Explore

<img width="936" alt="image" src="https://user-images.githubusercontent.com/27891090/229279811-26477139-4f26-484f-9df2-9de8accd2e71.png">





## Reference

- https://github.com/vegasbrianc/docker-traefik-prometheus
