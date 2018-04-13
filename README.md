## Kubernetes on Azure via Kismatic Enterprise Toolkit
The focus of this code is to deploy a minimal Kubernetes cluster into Microsoft Azure for testing and training purposes.
Upon successful completion, the following VM infrastructure will have been provisioned:
  * Bastion node (public IP, restricted access to SSH)
  * 1 k8s master node, with etcd co-located (public IP, restricted access to SSH and k8s API)
  * 2 k8s worker nodes, 1 node configured with nginx ingress controller (private IP only)

### Prerequisites
* Microsoft Azure account (https://azure.microsoft.com/en-us/free/)
* Azure CLI 2.0 (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* Terraform v0.11+ (https://www.terraform.io/downloads.html)

### Usage
Create a customized `terraform/terraform.tfvars` file ([tfvars file reference](https://www.terraform.io/intro/getting-started/variables.html#from-a-file)), key configurations are:

| Key               | Description       |
| ----------------- | ----------------- |
| `local_ip_cidr`   | Your local machine IP address (x.x.x.x/32) or CIDR range to allow access to the bastion node and cluster |
| `tenant_id`       | Your Azure account tenant ID (can be found via Azure CLI command `az account show`) |
| `subscription_id` | An Azure subscription ID from the above account/tenant (`az account list`) |
| `aadclient_id` / `aadclient_secret` | Active Directory application client ID and secret (AZ Portal > AAD > App registrations)|

Other settings can be configured such as VM sizes and the Azure region, as listed in `terraform/variables.tf`.

Prepare and execute the cluster VM builds:
  1. `make ssh-keypair`
  1. `make plan-cluster-vms`
  1. `make cluster-vms`

Once the build completes, the final step of running Kismatic must be run from the bastion node.
  1. Use the ssh connection command from the Terraform output to login to the bastion node
  1. `make validate-k8s-cluster`
  1. `make k8s-cluster`

When finished with the cluster, you may destroy all the resources that were provisioned. To do so, run the following from your local workstation:
  1. `make destroy-cluster-vms`
