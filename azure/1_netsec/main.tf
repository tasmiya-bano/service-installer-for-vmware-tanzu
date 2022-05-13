#---------------------------------------------
#  RESOURCE GROUP
#---------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-0"
  location = var.location

  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

#---------------------------------------------
#  RESOURCES
#---------------------------------------------
module "vnet_base" {
  source            = "../modules/vnet"
  local_data        = local.base_inputs
  dns_list          = []
  boot_diag_sa_name = var.boot_diag_sa_name
}

module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

#===================
#   DNS
#===================
# module "priv_dns_gen" {
#   source = ""

#   dom_env             = "s"
#   dom_loc             = "use2"
#   dom_spoke           = "2m"
#   vnet_id             = module.vnet_base.vnet_id
#   resource_group_name = azurerm_resource_group.rg.name
#   bu_group_name       = "[AAD Group]" # For group assignment of DNS contributor rights
# }