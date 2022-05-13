#####################################
# Subscription vars:
#####################################
sub_id       = "" # Azure Subscription ID
location     = "e.g. East US 2" # Azure region name
prefix       = "" # Concatenated with resource abbreviations and other elements to produce standardized names
prefix_short = "" # Shortened and simplified version of above - needed for certain names like Storage Accounts
vault_resource_group_name = "e.g. rg-fe-keepers-0" # this should be the keeper's Resource Group where the AKV lives
vault_name                = "e.g. kv-fe-keepers-7ddb" # our named vault from the output of 0_keepers

#####################################
# Tags
#####################################
additional_tags = {
  ServiceName  = "e.g. FedEx TKGm PoC"
  BusinessUnit = "e.g. MAPBU"
  Environment  = "e.g. Sandbox"
  OwnerEmail   = "e.g. ogradin@vmware.com"
}

#####################################
# Network vars:
#####################################
subnet_name           = "e.g. TKGM-JumpNet" # Subnet name taken from the VNET where it is defined
vnet_name             = "e.g. vnet-fe-useast2-poc-tkgm-netsec-0" # complete VNET name as defined in Azure
netsec_resource_group = "e.g. rg-fe-useast2-poc-tkgm-netsec-0" # complete resource group name where the VNET exists

#####################################
# Platform vars:
#####################################
boot_diag_sa_name = "feuse2snetsecbootdiag" # Storage Account name used for Boot Diagnostics - defined in 1_netsec