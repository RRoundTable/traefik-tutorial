# TLS in Docker

![](https://doc.traefik.io/traefik/assets/img/quickstart-diagram.png)

Traefik creates, for each container, a corresponding service and router.

![](https://doc.traefik.io/traefik/assets/img/routers.png)

- The [service](https://doc.traefik.io/traefik/routing/services/) automatically gets a server per instance of the container
- A [router](https://doc.traefik.io/traefik/routing/routers/) is in charge of connecting incoming requests to the services that can handle them. In the process, routers may use pieces of middleware to update the request, or act before forwarding the request to the service.


## Setup

```
docker compose up
```

## Router

### Entrypoint

EntryPoints are the network entry points into Traefik. They define the port which will receive the packets, and whether to listen for TCP or UDP.

We can configure entrypoint of router. It means that router can receive the request from entrypoint. 

For example, 
```
  whoami:
    labels:
      - "traefik.http.routers.whoami.entrypoints=web"
```

### PathPrefix

Match request prefix path

```
PathPrefix(`/whoami`)

# Matching
- /whoami/bench
- /whoami

# Not Matching
- /whoami1
- /who
```


### ReplacePathRex

Replace url with regex.


For example,

```
  whoami:
    labels:
      - "traefik.http.middlewares.replacepathregex.replacepathregex.regex=^/whoami/(.*)"
      - "traefik.http.middlewares.replacepathregex.replacepathregex.replacement=/$$2"
```

```
request url                 in container

http://127.0.0.1/whoami1 -> /
http://127.0.0.1/whoami2 -> /

http://127.0.0.1/whoami1/bench -> /bench
```


## Test

```
curl 127.0.0.1/whoami
```

```
Hostname: c18f0da817cf
IP: 127.0.0.1
IP: 172.19.0.2 # container ip
RemoteAddr: 172.19.0.4:54160
GET /whoami HTTP/1.1
Host: 127.0.0.1
User-Agent: curl/7.77.0
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 172.19.0.1
X-Forwarded-Host: 127.0.0.1
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: 803884019f91
X-Real-Ip: 172.19.0.1
```

```
curl 127.0.0.1/whoami/bench
```
```
1%
```


## Generate Certificate for TLS

Create `certifiactes` directory.

```
mkdir certificates
```

```
openssl req  -nodes -new -x509  -keyout certificates/whoami.local.key -out certificates/whoami.local.crt -config openssl.conf -days 365
```

Generate private key and certificate for `whoami.local` subject.


```
openssl req -x510 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=whoami.local Inc./CN=whoami.local' -keyout certificates/whoami.local.key -out certificates/whoami.local.crt
```

```
tree certificates
```

```
certificates
├── whoami.local.crt
└── whoami.local.key
```


## Reference

- https://doc.traefik.io/traefik/reference/dynamic-configuration/docker/
- https://doc.traefik.io/traefik/routing/routers/#rule
- https://doc.traefik.io/traefik/middlewares/http/replacepathregex/#regex
