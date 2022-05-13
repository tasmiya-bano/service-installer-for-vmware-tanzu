# TKGm Private Deployment on Azure Playbook

[[_TOC_]]

## TLDR

Modify provider.tf and/or terraform.tfvars as necessary for each TF config directory. Carry values from outputs or Key Vault into resultant config.yaml to then execute a cmd line execution of the management cluster.

## Terraform Infrastructure as Code

This repository should be forked and modified to fit your use case. The examples given were designed to use an Azure Storage Account as a remote backend for Terraform's state management. "Keepers" below, is a prerequisite and does not get stored in a remote state (in fact, it establishes a place remote state can be stored).

The following components are divided in such a way that steps can be skipped if the answers to those features are provided by another, either pre-existent service or Central IT-provided. Each component supplies a set of resources that are intended to be passed forward, ideally through secret storage within a secure vault.

**In most cases of automation, we are making some assumptions on the consumer's behalf. I have tried to highlight those (outside of variables) below in case you need to modify those opinions!**

### Assumptions

**Tag Names** - In addition to those listed within the terraform.tfvars files, "StartDate" is in use within the code as an _origin date_ in case it's important to track that for resources. It's set once when the resource is created, and it should never be changed thereafter (by Terraform). Additional tags can be added to the map var type in terraform.tfvars.

**Azure Cloud** - This has never been built for anything outside of the standard "AzureCloud." Your mileage may vary on China or Government types.

**Naming** - the naming practice used herein could follow [published Microsoft Cloud Adoption Framework](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming). In short, that's:  
> `<resource-type>-<app>-<env>-<region>-###`

You will likely have to modify this to fit your customer's needs. The liberties I've taken over this framework are as follows:  
> `<resource-type>-<bu>-<app>-<env>-<region-abbrv>-###`
where _###_ is useful where multiples are generated (automatic). Otherwise, it's not used. What's more, the naming standard is entirely based upon the various _prefix_ vars collected in terraform.tfvars. You are allowed to format those prefixes however you like, so the the rules above are just suggestions. The only enforcement takes place at the resource level where _<resource-type>_ is prepended to your prefix per Microsoft's guidelines where applicable.

- Resource-Type is aligned to [Microsoft published guidelines](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations) where possible
- region-abbrv can (and shoulbe) be an abbreviation. My examples are country-first and 4 characters:

> (see [Azure 4-Char Regions](https://confluence.eng.vmware.com/x/1gvER))
> `East US 2 = use2`

### Keepers

> "Keepers" are those resources that preempt the state-managed resources deployed by Terraform for this solution. They do not need to be dedicated to the TKGm solution! Keepers currently include a **Storage Account** for state and an **Azure Key Vault** for secret storage.

**IMPORTANT** Update `[terraform.tfvars](0_keepers/terraform.tfvars) for your environment

#### terraform.tfvars

- **sub\_id**: Azure Subscription ID
- **location**: Azure Region (_e.g. eastus2 or East US 2_)
- **prefix**: A prefix to resource names using your naming standards (_e.g. vmw-use2-svcname_)
- **prefix_short**: Some resources are limited in size and characters - this prefix solves for those (_e.g. vmwuse2svc_). **Can include 4-digits of randomized hexadecimal at the end**

> Tag values default to tags defined at the Subscription level, but are designed to be overriden by anything provided here

- **ServiceName**: Free text to name or describe your application, solution, or service
- **BusinessUnit**: Should align with a predetermined list of known BUs
- **Environment**: Should align with a predetermined list of environments
- **OwnerEmail**: A valid email for a responsible person or group of the resource(s)
- \<Optional Tags\>: _Such as RequestorEmail_

```Shell
`cd 0_keepers`
`terraform init`
`terraform validate`
`terraform apply`
```

### Network and Security

> NetSec should be replaced by a solution wherein the Central IT team provides these details where necessary. Specifically, Central IT should build the VNET to be in compliance with ExpressRoute requirements and allow the development team to add their own subnets and Network Security Groups (see [Azure Landing Zones](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture))

**IMPORTANT** Update `provider.tf` and `terraform.tfvars` for your environment

#### provider.tf

- **storage\_account\_name:** Storage account named pulled from the keepers.json where terraform state will be stored in perpetuity
- **container\_name:** Like a folder - generally "terraform-state"
- **key:** Further pathing for the storage and filename of your terraform state - must be unique (e.g. `bu/product/use2-s-net.tfstate`)
- **access\_key:** This can be found in your `keepers.json` and is the access_key credential used to read and write against the keeper storage account - SENSITIVE

#### terraform.tfvars (In addition to others listed previously...)

- **tkg\_cluster\_name:** The name passed into naming pertaining to the tanzu cli
- **core\_address\_space:** The VNET address space - it's the largest CIDR block specified for a network
- **boot\_diag\_sa\_name:** This name is passed to a storage account that is used for boot diagnostics - it should conform to Azure's naming requirements for storage accounts
- **vault_resource_group_name:** A Resource Group name provided by the output of `0_keepers`
- **vault_name:** The AKV name provided by the output of `0_keepers`

```Shell
cd ../1_netsec
terraform init
terraform validate
terraform apply
```

### DNS

> DNS, in this solution, represents a BIND9 forwarder for Azure Private DNS. In order for on-prem resources to resolve Private DNS resources, conditional or zone forwarding must be in place on-prem to point to these DNS servers.

**IMPORTANT** Update `provider.tf` and `terraform.tfvars` for your environment
#### provider.tf (same as above)

#### terraform.tfvars (In addition to others listed above...)
- **subnet\_name:** Subnet name where DNS Forwarders will allocate internal IP(s) (output from `1_netsec`)
- **vnet\_name:** The VNET name (pre-existing - is output from `1_netsec`)
- **netsec\_resource\_group:** The resource group name where the pre-existing VNET lives
- **bindvms:** Count of VMs to deploy to host BIND9
- **boot\_diag\_sa\_name:** Pre-generated boot diagnostics storage account name (output from `1_netsec`)

```Shell
cd ../2_dns
terraform init
terraform validate
terraform apply
```

### Bootstrap Pre-Reqs (TBD)

> This is a placeholder directory where scripts live to perform the cluster deployment after Terraform has created the infrastructure. Values are stored in the Azure Key Vault produced in 0_keepers and can be referenced to fill in values for the cluster and other config files.

Docker proxy config will need to be set. Add the following section to /etc/systemd/system/docker.service.d/http-proxy.conf:

```bash
[Service]
    Environment="HTTP_PROXY=proxy.target:port"
    Environment="HTTPS_PROXY=proxy.target:port"
    Environment="NO_PROXY=cidr_or_domains"
```

### Bootstrap VM

> The Bootstrap VM is used for TKGm deployment activities and is setup from the start with the tanzu CLI and related binaries.

**IMPORTANT** Update `provider.tf` and `terraform.tfvars` for your environment
#### provider.tf (same as above)

#### terraform.tfvars (In addition to others listed above...)
- **subnet\_name:** Subnet name where the bootstrap VM will allocate an internal IP (output from `1_netsec`)
- **vnet\_name:** The VNET name (pre-existing - is output from `1_netsec`)
- **netsec\_resource\_group:** The resource group name where the pre-existing VNET lives
- **boot\_diag\_sa\_name:** Pre-generated boot diagnostics storage account name (output from `1_netsec`)

```Shell
cd ../3_bootstrap
terraform init
terraform validate
terraform apply
```

> Creating the first management cluster is done through "kind" on the bootstrap VM and outputs from IaC above should be captured here for the resultant answer files.

### Final Steps

1) parse output (Key Vault, outputs, or state)
1) moustache templating for config.tmpl, pinniped-annotate.tmpl
1) scp config.yaml [ssh_vm]
1) scp pinniped-annotate.yaml [ssh_vm]
1) scp tkgm-install.sh [ssh_vm]
1) rexec tkgm-install.sh
