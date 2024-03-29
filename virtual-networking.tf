/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmDomP"
 - Distinguished Name: "uni/vmmp-{switch_provider}/dom-{name}"
GUI Location:
 - Virtual Networking -> {switch_provider} -> {domain_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_domain" "map" {
  depends_on = [
    aci_vlan_pool.vlan_pools
  ]
  for_each            = local.vmm_domains
  access_mode         = each.value.access_mode
  ctrl_knob           = each.value.control_knob
  delimiter           = each.value.delimiter
  enable_tag          = each.value.enable_tag_collection == true ? "yes" : "no"
  encap_mode          = each.value.encapsulation
  enf_pref            = each.value.enforcement
  ep_inventory_type   = each.value.endpoint_inventory_type
  ep_ret_time         = each.value.endpoint_retention_time
  mode                = each.value.switch_mode
  name                = each.key
  pref_encap_mode     = each.value.preferred_encapsulation
  provider_profile_dn = "uni/vmmp-${each.value.switch_provider}"
  relation_infra_rs_vlan_ns = length(compact([each.value.vlan_pool])
  ) > 0 ? aci_vlan_pool.vlan_pools[each.value.vlan_pool].id : ""
}

resource "aci_rest_managed" "vmm_domain_uplinks" {
  depends_on = [
    aci_vmm_domain.map
  ]
  for_each   = local.vmm_domains
  class_name = "vmmUplinkPCont"
  dn         = "uni/vmmp-${each.value.switch_provider}/dom-${each.key}/uplinkpcont"
  content = {
    numOfUplinks = each.value.numOfUplinks
  }
}

resource "aci_rest_managed" "vmm_uplinks" {
  depends_on = [
    aci_rest_managed.vmm_domain_uplinks
  ]
  for_each   = local.vmm_uplinks
  class_name = "vmmUplinkP"
  dn         = "uni/vmmp-${each.value.switch_provider}/dom-${each.value.domain}/uplinkpcont/uplinkp-${each.value.uplinkId}"
  content = {
    uplinkId   = each.value.uplinkId
    uplinkName = each.value.uplinkName
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmUsrAccP"
 - Distinguished Name: "uni/vmmp-{switch_provider}/dom-{name}/usracc-{name}"
GUI Location:
 - Virtual Networking -> {switch_provider} -> {domain_name} -> Credentials
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_credential" "map" {
  depends_on = [
    aci_vmm_domain.map
  ]
  for_each      = local.vmm_credentials
  description   = each.value.description
  name          = each.value.name
  vmm_domain_dn = aci_vmm_domain.map[each.value.domain].id
  pwd           = var.access_sensitive.virtual_networking.password[each.value.password]
  usr           = each.value.username
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmCtrlrP"
 - Distinguished Name: "uni/vmmp-{switch_provider}/dom-{name}/ctrlr-{name}"
GUI Location:
 - Virtual Networking -> {switch_provider} -> {domain_name} -> {controller_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_controller" "map" {
  depends_on = [
    aci_vmm_credential.map,
    aci_vmm_domain.map
  ]
  for_each            = local.vmm_controllers
  vmm_domain_dn       = aci_vmm_domain.map[each.value.domain].id
  name                = each.value.hostname
  dvs_version         = each.value.dvs_version
  host_or_ip          = each.value.hostname
  inventory_trig_st   = each.value.trigger_inventory_sync
  mode                = each.value.switch_mode
  port                = each.value.port
  root_cont_name      = each.value.datacenter
  scope               = each.value.switch_scope
  seq_num             = each.value.sequence_number
  stats_mode          = each.value.stats_collection
  vxlan_depl_pref     = each.value.switch_mode == "nsx" ? "nsx" : "vxlan"
  relation_vmm_rs_acc = aci_vmm_credential.map[each.value.dn_key].id
  # relation_vmm_rs_ctrlr_p_mon_pol = length(compact([each.value.monitoring_policy])
  # ) > 0 ? "uni/infra/moninfra-${each.value.monitoring_policy}" : ""
  # relation_vmm_rs_mgmt_e_pg = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
  # relation_vmm_rs_to_ext_dev_mgr  = [each.value.external_device_manager]
  relation_vmm_rs_vxlan_ns = length(compact([each.value.vxlan_pool])
  ) > 0 ? "uni/infra/vxlanns-${each.value.vxlan_pool}" : ""
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmVSwitchPolicyCont"
 - Distinguished Name: "uni/vmmp-{switch_provider}/dom-{name}/vswitchpolcont"
GUI Location:
 - Virtual Networking -> {switch_provider} -> {domain_name} -> VSwitch Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_vswitch_policy" "map" {
  depends_on = [
    aci_vmm_domain.map
  ]
  for_each      = local.vswitch_policies
  vmm_domain_dn = aci_vmm_domain.map[each.value.domain].id
  dynamic "relation_vmm_rs_vswitch_exporter_pol" {
    for_each = { for v in [each.value.netflow_export_policy_parameters] : v.netflow_export_policy => v if v.create == true }
    content {
      active_flow_time_out = relation_vmm_rs_vswitch_exporter_pol.value.active_flow_timeout
      idle_flow_time_out   = relation_vmm_rs_vswitch_exporter_pol.value.idle_flow_timeout
      sampling_rate        = relation_vmm_rs_vswitch_exporter_pol.value.sample_rate
      target_dn            = "uni/infra/vmmexporterpol-${relation_vmm_rs_vswitch_exporter_pol.value.netflow_export_policy}"
    }
  }
  relation_vmm_rs_vswitch_override_cdp_if_pol = length(compact([each.value.cdp_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_policy}" : ""
  relation_vmm_rs_vswitch_override_fw_pol = length(compact([each.value.firewall_policy])
  ) > 0 ? "uni/infra/fwP-${each.value.firewall_policy}" : ""
  relation_vmm_rs_vswitch_override_lacp_pol = length(compact([each.value.port_channel_policy])
  ) > 0 ? "uni/infra/lacplagp-${each.value.port_channel_policy}" : ""
  relation_vmm_rs_vswitch_override_lldp_if_pol = length(compact([each.value.lldp_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_policy}" : ""
  relation_vmm_rs_vswitch_override_mtu_pol = "uni/fabric/l2pol-${each.value.mtu_policy}"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "lacpEnhancedLagPol"
 - Distinguished Name: "uni/vmmp-{switch_provider}/dom-{name}/vswitchpolcont"
GUI Location:
 - Virtual Networking -> {switch_provider} -> {domain_name} -> VSwitch Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "vmm_ehanced_lag_policies" {
  depends_on = [
    aci_vswitch_policy.map
  ]
  for_each   = local.enhanced_lag_policies
  class_name = "lacpEnhancedLagPol"
  dn         = "uni/vmmp-${each.value.switch_provider}/dom-${each.value.domain}/enlacplagp-${each.value.name}"
  content = {
    id       = each.value.id
    lbmode   = each.value.load_balancing_mode
    mode     = each.value.mode
    name     = each.value.name
    numLinks = each.value.number_of_links
  }
}
