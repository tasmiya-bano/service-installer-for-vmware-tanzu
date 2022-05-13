locals {
  tkgm_jump_net       = "172.19.119.0/28"
  tkgm_wrkr_net       = "172.19.119.64/26"
  tkgm_ctrl_net       = "172.19.119.192/26"
  tkgm_share_ctrl_net = "172.19.119.16/28"
  tkgm_share_wrkr_net = "172.19.119.128/26"
}

#===================
#   TKGM Management Cluster Tier
#===================
module "tkgm_worker_nodes" {
  source        = "../modules/worker_subnet"
  local_data    = local.local_data
  flow_log_data = module.vnet_base.flow_log_data
  subnet_settings = {
    "TKGM-Worker" = { "network" = local.tkgm_wrkr_net, "service_endpoints" = [], "allow_plink_endpoints" = false }
  }
}

module "general_tier" {
  source        = "../modules/general_subnet"
  local_data    = local.local_data
  flow_log_data = module.vnet_base.flow_log_data
  subnet_settings = {
    "TKGM-Controller" = { "network" = local.tkgm_ctrl_net, "service_endpoints" = [], "allow_plink_endpoints" = false }
    "TKGM-JumpNet"    = { "network" = local.tkgm_jump_net, "service_endpoints" = [], "allow_plink_endpoints" = true }
    "TKGM-SharedCtrl" = { "network" = local.tkgm_share_ctrl_net, "service_endpoints" = [], "allow_plink_endpoints" = false }
    "TKGM-SharedWrkr" = { "network" = local.tkgm_share_wrkr_net, "service_endpoints" = [], "allow_plink_endpoints" = false }
  }
}