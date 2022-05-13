#####################################
# Subscription vars:
#####################################
sub_id       = ""               # Azure Subscription ID
tenant_id    = ""               # Azure (Active Directory) Tenant ID - needed for KeyVault role permissions
location     = "e.g. East US 2" # Azure region name
prefix       = ""               # Concatenated with resource abbreviations and other elements to produce standardized names
prefix_short = ""               # Shortened and simplified version of above - needed for certain names like Storage Accounts

#####################################
# TKG Vars
#####################################
additional_tags = {
  ServiceName  = "e.g. FedEx TKGm PoC"
  BusinessUnit = "e.g. MAPBU"
  Environment  = "e.g. Sandbox"
  OwnerEmail   = "e.g. ogradin@vmware.com"
}