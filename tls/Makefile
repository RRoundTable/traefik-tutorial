PROFILE_NAME=traefik-ingress-within-namespace

cluster:
	minikube start driver=docker --profile=$(PROFILE_NAME)
	eval $(minikube docker-env)  # for using host docker images

finalize:
	minikube delete --profile=$(PROFILE_NAME)

cluster-init:
	kubectl create namespace test

traefik:
	helm repo add traefik https://helm.traefik.io/traefik
	helm dependency build charts/traefik
	helm install traefik charts/traefik

tunnel:
	minikube tunnel --profile=$(PROFILE_NAME)

hello-world:
	minikube image build -t hello-world:v1 . --profile $(PROFILE_NAME)
	helm install --values charts/hello-world/values.yaml hello-world charts/hello-world

