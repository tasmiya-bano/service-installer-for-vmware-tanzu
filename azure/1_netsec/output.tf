#---------------------------------------------
#   VNET INFORMATION
#---------------------------------------------

output "AZURE_CONTROL_PLANE_SUBNET_CIDR" {
  value = local.tkgm_ctrl_net
}

output "AZURE_CONTROL_PLANE_SUBNET_NAME" {
  value = element([for subnet in keys(module.general_tier.subnets) : subnet if length(regexall("control", lower(subnet))) > 0], 0)
}

output "AZURE_NODE_SUBNET_NAME" {
  value = element([for subnet in keys(module.tkgm_worker_nodes.subnets) : subnet if length(regexall("worker", lower(subnet))) > 0], 0)
}

output "AZURE_LOCATION" {
  description = "Region where these resources are deployed."
  value       = azurerm_resource_group.rg.location
}

output "AZURE_FRONTEND_PRIVATE_IP" {
  value = cidrhost(local.tkgm_ctrl_net, 4)
}

output "AZURE_NODE_SUBNET_CIDR" {
  value = local.tkgm_wrkr_net
}

output "AZURE_SUBSCRIPTION_ID" {
  value = var.sub_id
}

output "AZURE_TENANT_ID" {
  value = data.azurerm_subscription.this.tenant_id
}

output "AZURE_VNET_CIDR" {
  value = var.core_address_space
}

output "AZURE_VNET_NAME" {
  value = module.vnet_base.vnet_name
}

output "AZURE_VNET_RESOURCE_GROUP" {
  value = azurerm_resource_group.rg.name
}

output "CLUSTER_NAME" {
  value = var.tkg_cluster_name
}

#---------------------------------------------
#   SUBNET INFORMATION
#---------------------------------------------


#---------------------------------------------
#   Spoke DNS Zone (Private)
#---------------------------------------------
# output "dns_zone" {
#   value = module.priv_dns_gen.dns_zone
# }