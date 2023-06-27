#!/bin/bash
./kind-with-rgy
kubectl create namespace pci-backend
kubectl create namespace pci-frontend
cd $HOME/github.com/hashicorp/consul-enterprise/
make dev-docker
docker tag consul-dev localhost:5000/consul-dev-ent
docker push localhost:5000/consul-dev-ent
cd -
rm -rf secrets
mkdir secrets
echo -n "1111111-2222-3333-4444-555555555555" > secrets/root-token.txt
echo -n "$(consul keygen)" > secrets/gossip-key.txt
(cd secrets ; consul tls ca create)
chmod 600 secrets/*
kubectl create secret generic consul \
  --from-file=root-token=secrets/root-token.txt \
  --from-file=gossip-key=secrets/gossip-key.txt \
  --from-file=ca-cert=secrets/consul-agent-ca.pem \
  --from-file=ca-key=secrets/consul-agent-ca-key.pem \
  --from-file=enterprise-license=${CONSUL_LICENSE_PATH}
kubectl apply -f pv/pv.yaml
kubectl apply -f pv/pvc.yaml
consul-k8s install -config-file values.yaml -namespace default -auto-approve
export CONSUL_HTTP_TOKEN='1111111-2222-3333-4444-555555555555'
export CONSUL_HTTP_ADDR=localhost:8501
export CONSUL_HTTP_SSL=true
export CONSUL_HTTP_SSL_VERIFY=false
sleep 5
kubectl port-forward services/consul-server 8501 &>/dev/null &
while ! curl -sSk -o /dev/null https://localhost:8501/v1/namespaces ; do sleep 1; done
consul namespace create -name pci-backend
consul namespace create -name pci-frontend
kubectl apply -f apps/1-install/opa-config-map.yaml
kubectl apply -f apps/1-install/fs.yaml
kubectl apply -f apps/1-install/api.yaml
kubectl apply -f apps/1-install/web.yaml
kubectl apply -f apps/1-install/pci-backend-db.yaml -n pci-backend
kubectl apply -f apps/1-install/pci-frontend-web.yaml -n pci-frontend
kubectl apply -f apps/1-install/intentions.yaml
kubectl apply -f apps/1-install/service-defaults.yaml
kubectl port-forward services/web 9090 &> /dev/null &
