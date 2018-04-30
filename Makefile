DEPLOY=kube

create-vms:
	cd deployment-manager && gcloud deployment-manager deployments create $(DEPLOY) --config config.yaml

destroy-vms:
	cd deployment-manager && gcloud deployment-manager deployments delete $(DEPLOY) -q

install-kismatic:
	cd kismatic && ./ket.sh install

remove-kismatic:
	cd kismatic && ./ket.sh remove

prepare-kubernetes:
	cd kismatic && ./update-plan.sh
	cd kismatic && ./kismatic install validate -f $(DEPLOY)-cluster.yaml

install-kubernetes:
	cd kismatic && ./kismatic install apply -f $(DEPLOY)-cluster.yaml
	test -d ~/.kube || mkdir -p ~/.kube/
	test -f ~/.kube/config && cp -p ~/.kube/config ~/.kube/config.$(DEPLOY)-backup
	cp kismatic/generated/kubeconfig ~/.kube/config
