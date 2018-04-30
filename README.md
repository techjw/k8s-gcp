## Kubernetes on Google Cloud Platform via Kismatic Enterprise Toolkit
The focus of this code is to deploy a basic Kubernetes cluster into Google Cloud Platform for testing and training purposes.
Upon successful completion, the following VM infrastructure will have been provisioned:
  * 1 k8s master node, with etcd co-located
  * 1 k8s worker node
  * 1 k8s ingress controller node

All instances are configured with public IPs, however firewall rules will only allow SSH and kubeapi access from the CIDR block (`local_cidr`) defined in [config.yaml](deployment-manager/config.yaml), or the default value as set in [infra.jinja.schema](deployment-manager/infra.jinja.schema) if no `local_cidr` is provided.

Additionally, the following support infrastructure will be provisioned:
  * Custom network with a single subnet
  * Firewall rules for SSH, kubeapi, and internal network traffic
  * An instance group per component: masters, workers, ingress controllers
  * External TCP load balancer for the Kubernetes API

### Prerequisites
* Google Cloud Platform account (https://console.cloud.google.com/freetrial)
* Google Cloud SDK (https://cloud.google.com/sdk/)

### Customization
Customize [deployment-manager/config.yaml](deployment-manager/config.yaml) for your desired cluster setup. Some critical configurations are as seen below:

| Infra Key     | Description       |
| ------------- | ----------------- |
| `local_cidr`  | The source CIDR block to allow inbound access |
| `subnet_cidr` | CIDR block allocation for the subnet |
| `region`      | GCP region to execute deployment |

The following properties are available for ingress, workers, and masters:

| Common VM Key | Description       |
| ------------- | ----------------- |
| `region`      | GCP region to execute deployment, must match across all resources |
| `zone`        | GCP regional zone to deploy VMs into |
| `machineType` | GCP machine type for VMs |
| `instances`   | Number of VMs to deploy |
| `diskSizeGb`  | Size for the VM persistent boot disk |

Below is an example from `config.yaml`, where the region has been modified from the default for the resources:
```
resources:
  - name: infra
    type: infra.jinja
    properties:
      region: us-central1
  - name: masters
    type: masters.jinja
    properties:
      region: us-central1
      zone: us-central1-b
  - name: workers
    type: workers.jinja
    properties:
      region: us-central1
      zone: us-central1-b
  - name: ingress
    type: ingress.jinja
    properties:
      region: us-central1
      zone: us-central1-b
```

### Provision and Build a cluster
1. Deploy the GCP template (sets up the infrastructure and VMs):
  ```
  make create-vms
  ```

2. Update the values in [kismatic/env.cfg](kismatic/env.cfg)
  * Replace the GCE user and SSH key values
  * Update the IP addresses with the private and public IPs for your provisioned VMs and load balancer.
  * _Optional_: change the deployment name (will prefix all provisioned resource names)

3. Once the deployment completes, setup and execute Kismatic Enterprise Toolkit:
  ```
  make install-kismatic
  make prepare-kubernetes
  make install-kubernetes
  ```

4. When finished with the cluster, you may destroy all the resources that were provisioned. To do so, run the following:
  ```
  make destroy-vms
  make remove-kismatic
  ```
