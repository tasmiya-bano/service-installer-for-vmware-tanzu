#####################################
# Subscription vars:
#####################################
sub_id                    = ""                                # Azure Subscription ID
location                  = "e.g. East US 2"                  # Azure region name
prefix                    = "e.g. fe-useast2-poc-tkgm-netsec" # Concatenated with resource abbreviations and other elements to produce standardized names - must be unique
prefix_short              = "e.g. feuse2s"                    # Shortened and simplified version of above - needed for certain names like Storage Accounts
vault_resource_group_name = "e.g. rg-fe-keepers-0"            # this should be the keeper's Resource Group where the AKV lives
vault_name                = "e.g. kv-fe-keepers-7ddb"         # our named vault from the output of 0_keepers

#####################################
# TKG Vars
#####################################
additional_tags = {
  ServiceName  = "e.g. FedEx TKGm PoC"
  BusinessUnit = "e.g. MAPBU"
  Environment  = "e.g. Sandbox"
  OwnerEmail   = "e.g. ogradin@vmware.com"
}
tkg_cluster_name = "e.g. fe-use2-tkgm14-poc-0" # used as an output to the Vault for variable substitution in the cluster configuration file

#####################################
# Network vars:
#####################################
core_address_space = "e.g. 172.19.119.0/24" # VNET address space allocation - the largest unit to be subdivded by subnets

#####################################
# Platform vars:
#####################################
boot_diag_sa_name = "e.g. feuse2snetsecbootdiag" # defines the name of the storage account used for boot diagnostics hereon out. Should probably move this into the keepers