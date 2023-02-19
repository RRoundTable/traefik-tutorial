# Ingress Route with Traefik

This tutorial is for ingress route within the same namespace and over the namespaces.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/): v1.29.0
- [Helm](https://helm.sh/docs/intro/install/): v3.9.2

## Setup

Create minikube cluster.

```
make cluster
```

## Deploy traefik

Deploy traefik with middleware.

```
make traefik
```

![](https://doc.traefik.io/traefik/assets/img/middleware/overview.png)

Attached to the routers, pieces of middleware are a means of tweaking the requests before they are sent to your service (or before the answer from the services are sent to the clients).

There are several available middleware in Traefik, some can modify the request, the headers, some are in charge of redirections, some add authentication, and so on.

Middlewares that use the same protocol can be combined into chains to fit every scenario.

The middleware converts the input url to `/`.

- input: `/hello-world/v1`
- output: `/`


Check traefik is running. And the middleware is deployed.


```
kubectl get pod
```
```
NAME                                    READY   STATUS    RESTARTS   AGE
traefik-5486b5f4f7-np2xx                1/1     Running   0          12m
```


```
kubectl get middleware
```
```
NAME           AGE
replace-path   13m
```

## Deploy hello-world-v1

Deploy `hello-world-v1` with ingressroute.

```
make hello-world-v1
```

Check `hello-world-v1` is running.

```
kubectl get pod
```

```
NAME                                    READY   STATUS    RESTARTS   AGE
hello-world-v1-hello-6d9b7c4755-q4dj4   1/1     Running   0          13m
hello-world-v1-hello-6d9b7c4755-s4ljw   1/1     Running   0          13m
traefik-5486b5f4f7-np2xx                1/1     Running   0          13m
```
Check ingressroute.

```
kubectl get ingressroute
NAME                   AGE
hello-world-v1-hello   14m
```

## Deploy hello-world-v2

Deploy `hello-world-v2` with ingressroute.

```
make hello-world-v2
```

Check `hello-world-v2` is running.

```
kubectl get pod
```

```
NAME                                    READY   STATUS    RESTARTS   AGE
hello-world-v1-hello-6d9b7c4755-q4dj4   1/1     Running   0          13m
hello-world-v1-hello-6d9b7c4755-s4ljw   1/1     Running   0          13m
hello-world-v2-hello-8594bb66f9-sknjj   1/1     Running   0          13m
hello-world-v2-hello-8594bb66f9-ss8fl   1/1     Running   0          13m
```
Check ingressroute.

```
kubectl get ingressroute
NAME                   AGE
hello-world-v1-hello   14m
hello-world-v2-hello   14m
```

## Deploy hello-world-v1 to test namespace

Deploy `hello-world-v1` in `test` namespace  with ingressroute.

```
make test-hello-world-v1
```

traefik should be allowed to reference resources in the other namespace that traefik is not.

```
providers:
  kubernetesCRD:
    allowCrossNamespace: true
```


Check `hello-world-v1` in `test` namespace.

```
kubectl get pod -n test
```

```
NAME                                    READY   STATUS    RESTARTS   AGE
hello-world-v1-hello-6d9b7c4755-qrrk8   1/1     Running   0          48s
hello-world-v1-hello-6d9b7c4755-rxv7x   1/1     Running   0          48s
```


Check ingressroute in `default` namespace.

```
kubectl get ingressroute
```

```
NAME                        AGE
hello-world-v1-hello        18m
hello-world-v2-hello        18m
test-hello-world-v1-hello   4s
traefik-dashboard           18m
```

## Test

```
# in new tunnel
make tunnel
```

Request to `hello-world-v1` in `default` namespace.

```
curl localhost:8080/hello-world/v1
```


Request to `hello-world-v2` in `default` namespace.

```
curl localhost:8080/hello-world/v2
```


Request to `hello-world-v1` in `test` namespace.

```
curl localhost:8080/test/hello-world/v1
```

All responses will be

```
<pre>
Hello World


                                       ##         .
                                 ## ## ##        ==
                              ## ## ## ## ##    ===
                           /""""""""""""""""\___/ ===
                      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
                           \______ o          _,/
                            \      \       _,'
                             `'--.._\..--''
</pre>
```

## References

- https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/#kind-ingressroute
- https://doc.traefik.io/traefik/middlewares/overview/
- https://doc.traefik.io/traefik/providers/kubernetes-crd/#allowcrossnamespace
