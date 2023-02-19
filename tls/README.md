# TLS with Traefik

This tutorial is for TLS with Traefik.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/): v1.29.0
- [Helm](https://helm.sh/docs/intro/install/): v3.9.2

## Setup

Create minikube cluster.

```
make cluster
```

## Generate Certificate for TLS

Create `certifiactes` directory.

```
mkdir certificates
```

Generate private key and certificate for `example.com` subject.

```
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=example.com' -keyout certificates/example.com.key -out certificates/example.com.crt
```

```
tree certificates
```

```
certificates
├── example.com.crt
└── example.com.key
```

Generate a certificate sigining request for `hello-world.example.com`

```
openssl req -out certificates/hello-world.example.com.csr -newkey rsa:2048 -nodes -keyout certificates.hello-world.example.com.key -subj "/CN=hello-world.example.com/0=hello-world organization"
```

Sign a certificate signing request for `hello-world.example.com` with root certificate and private key.


```
openssl x509 -req -sha256 -days 365 -CA certificates/example.com.crt -CAkey certificates/example.com.key -set_serial 0 -in certificates/hello-world.example.com.csr -out certificates/hello-world.example.com.crt
```

```
tree certificates
```

```
certificates
├── example.com.crt
├── example.com.key
├── hello-world.example.com.crt
└── hello-world.example.com.csr

```

Create `hello-world-cert` secret

```
kubectl create secret generic hello-world-cert --from-file=certificates/example.com.crt --from-file certificates/example.com.key
```


## Deploy traefik

Deploy traefik with middleware.

```
make traefik
```

