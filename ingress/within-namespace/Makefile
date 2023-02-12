PROFILE_NAME=traefik-ingress-within-namespace

cluster:
	minikube start driver=docker --profile=$(PROFILE_NAME)
	eval $(minikube docker-env)  # for using host docker images

finalize:
	minikube delete --profile=$(PROFILE_NAME)

traefik:
	helm repo add traefik https://helm.traefik.io/traefik
	helm dependency build charts/traefik
	helm install traefik charts/traefik

tunnel:
	minikube tunnel --profile=$(PROFILE_NAME)

hello-world-v1:
	minikube image build -t hello-world:v1 . --profile $(PROFILE_NAME)
	helm install hello-world-v1 charts/hello-world-v1
