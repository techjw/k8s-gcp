DEPLOY=kube

cluster-vms:
	cd deployment-manager && gcloud deployment-manager create $(DEPLOY) -f config.yaml

destroy-vms:
	cd deployment-manager && gcloud deployment-manager delete $(DEPLOY) -q

kismatic:
	cd kismatic && ./ket.sh install

remove-kismatic:
	cd kismatic && ./ket.sh remove

prepare-kubernetes:
	cd kismatic
	./update-plan.sh
	./kismatic install validate -f $(DEPLOY)-cluster.yaml

kubernetes:
	cd kismatic
	./kismatic install apply -f $(DEPLOY)-cluster.yaml
	cp generated/kubeconfig .
	mkdir ~/.kube/
	cp kubeconfig ~/.kube/config
