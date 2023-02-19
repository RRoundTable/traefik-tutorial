PROFILE_NAME=traefik-ingress

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

hello-world-v1:
	minikube image build -t hello-world:v1 . --profile $(PROFILE_NAME)
	helm install --values charts/hello-world/values-v1.yaml hello-world-v1 charts/hello-world

test-hello-world-v1:
	minikube image build -t hello-world:v1 . --profile $(PROFILE_NAME)
	helm install --create-namespace --namespace test --values charts/hello-world/values-test-v1.yaml hello-world-v1 charts/hello-world

hello-world-v2:
	minikube image build -t hello-world:v2 . --profile $(PROFILE_NAME)
	helm install --values charts/hello-world/values-v2.yaml hello-world-v2 charts/hello-world
