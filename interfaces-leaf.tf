/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccPortGrp"
 - Distinguished Name: "uni/infra/funcprof/accportgrp-{name}"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > Leaf Access Port > {name}

_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_access_port_policy_group" "map" {
  depends_on = [
    aci_attachable_access_entity_profile.map,
    aci_cdp_interface_policy.map,
    aci_interface_fc_policy.map,
    aci_l2_interface_policy.map,
    aci_fabric_if_pol.map,
    aci_lldp_interface_policy.map,
    aci_miscabling_protocol_interface_policy.map,
    aci_port_security_policy.map,
    aci_spanning_tree_interface_policy.map
  ]
  for_each    = local.leaf_interfaces_policy_groups_access
  description = each.value.description
  name        = each.key
  # class: infraAttEntityP
  relation_infra_rs_att_ent_p = length(compact([each.value.attachable_entity_profile])
  ) > 0 ? "uni/infra/attentp-${each.value.attachable_entity_profile}" : ""
  # class: cdpIfPol
  relation_infra_rs_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  # class: coppIfPol
  relation_infra_rs_copp_if_pol = length(compact([each.value.copp_interface_policy])
  ) > 0 ? "uni/infra/coppifpol-${each.value.copp_interface_policy}" : ""
  # class: dwdmIfPol
  relation_infra_rs_dwdm_if_pol = length(compact([each.value.dwdm_policy])
  ) > 0 ? "uni/infra/dwdmifpol-${each.value.dwdm_policy}" : ""
  # class: fcIfPol
  relation_infra_rs_fc_if_pol = length(compact([each.value.fibre_channel_interface_policy])
  ) > 0 ? "uni/infra/fcIfPol-${each.value.fibre_channel_interface_policy}" : ""
  # class: fabricHIfPol
  relation_infra_rs_h_if_pol = length(compact([each.value.link_level_policy])
  ) > 0 ? "uni/infra/hintfpol-${each.value.link_level_policy}" : ""
  # class: l2IfPol
  relation_infra_rs_l2_if_pol = length(compact([each.value.l2_interface_policy])
  ) > 0 ? "uni/infra/l2IfP-${each.value.l2_interface_policy}" : ""
  # class: l2PortAuthPol
  relation_infra_rs_l2_port_auth_pol = length(compact([each.value.dot1x_port_authentication_policy])
  ) > 0 ? "uni/infra/portauthpol-${each.value.dot1x_port_authentication_policy}" : ""
  # class: l2PortSecurityPol
  relation_infra_rs_l2_port_security_pol = length(compact([each.value.port_security_policy])
  ) > 0 ? "uni/infra/portsecurityP-${each.value.port_security_policy}" : ""
  # class: lldpIfPol
  relation_infra_rs_lldp_if_pol = length(compact([each.value.lldp_interface_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_interface_policy}" : ""
  # class: macsecIfPol
  relation_infra_rs_macsec_if_pol = length(compact([each.value.macsec_policy])
  ) > 0 ? "uni/infra/macsecifp-${each.value.macsec_policy}" : ""
  # class: mcpIfPol
  relation_infra_rs_mcp_if_pol = length(compact([each.value.mcp_interface_policy])
  ) > 0 ? "uni/infra/mcpIfP-${each.value.mcp_interface_policy}" : ""
  # class: monFabricPol
  relation_infra_rs_mon_if_infra_pol = length(compact([each.value.monitoring_policy])
  ) > 0 ? "uni/infra/moninfra-${each.value.monitoring_policy}" : ""
  # class: netflowMonitorPol
  dynamic "relation_infra_rs_netflow_monitor_pol" {
    for_each = each.value.netflow_monitor_policies
    content {
      flt_type  = relation_infra_rs_netflow_monitor_pol.value.ip_filter_type
      target_dn = "uni/infra/monitorpol-${relation_infra_rs_netflow_monitor_pol.value.netflow_monitor_policy}"
    }
  }
  # class: poeIfPol
  relation_infra_rs_poe_if_pol = length(compact([each.value.poe_interface_policy])
  ) > 0 ? "uni/infra/poeIfP-${each.value.poe_interface_policy}" : ""
  # class: qosDppPol
  relation_infra_rs_qos_egress_dpp_if_pol = length(compact([each.value.data_plane_policing_egress])
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_egress}" : ""
  # class: qosDppPol
  relation_infra_rs_qos_ingress_dpp_if_pol = length(compact([each.value.data_plane_policing_ingress])
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_ingress}" : ""
  # class: qosPfcIfPol
  relation_infra_rs_qos_pfc_if_pol = length(compact([each.value.priority_flow_control_policy])
  ) > 0 ? "uni/infra/pfc-${each.value.priority_flow_control_policy}" : ""
  # class: qosSdIfPol
  relation_infra_rs_qos_sd_if_pol = length(compact([each.value.slow_drain_policy])
  ) > 0 ? "uni/infra/qossdpol-${each.value.slow_drain_policy}" : ""
  ## class: spanVDestGrp
  #relation_infra_rs_span_v_dest_grp = length(compact(each.value.vspan_destination_groups)
  #) > 0 ? [for s in each.value.span_source_groups : "uni/infra/vdestgrp-${s}"] : []
  ## class: spanVSrcGrp
  #relation_infra_rs_span_v_src_grp = length(compact(each.value.vspan_source_groups)
  #) > 0 ? [for s in each.value.span_source_groups : "uni/infra/vsrcgrp-${s}"] : []
  # class: stormctrlIfPol
  relation_infra_rs_stormctrl_if_pol = length(compact([each.value.storm_control_policy])
  ) > 0 ? "uni/infra/stormctrlifp-${each.value.storm_control_policy}" : ""
  # class: stpIfPol
  relation_infra_rs_stp_if_pol = length(compact([each.value.spanning_tree_interface_policy])
  ) > 0 ? "uni/infra/ifPol-${each.value.spanning_tree_interface_policy}" : ""
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/funcprof/accportgrp-{name}/alias"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > Leaf Access Port > {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "leaf_interfaces_policy_groups_access_global_alias" {
  depends_on = [
    aci_leaf_access_port_policy_group.map,
  ]
  for_each   = { for k, v in local.leaf_interfaces_policy_groups_access : k => v if v.global_alias != "" }
  class_name = "tagAliasInst"
  dn         = "uni/infra/funcprof/accportgrp-${each.key}"
  content = {
    name = each.value.global_alias
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraBrkoutPortGrp"
 - Distinguished Name: "uni/infra/funcprof/brkoutportgrp-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Interface > Leaf Interfaces > Policy Groups > Leaf Breakout Port Group:{{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_breakout_port_group" "map" {
  for_each    = local.leaf_interfaces_policy_groups_breakout
  brkout_map  = each.value.breakout_map
  description = each.value.description
  name        = each.key
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccBndlGrp"
 - Distinguished Name: "uni/infra/funcprof/accbundle-{{Name}}"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > [PC or VPC] Interface > {{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_access_bundle_policy_group" "map" {
  depends_on = [
    aci_attachable_access_entity_profile.map,
    aci_cdp_interface_policy.map,
    aci_interface_fc_policy.map,
    aci_l2_interface_policy.map,
    aci_lacp_policy.map,
    aci_fabric_if_pol.map,
    aci_lldp_interface_policy.map,
    aci_miscabling_protocol_interface_policy.map,
    aci_port_security_policy.map,
    aci_spanning_tree_interface_policy.map
  ]
  for_each    = local.leaf_interfaces_policy_groups_bundle
  description = each.value.description
  lag_t       = each.value.link_aggregation_type == "vpc" ? "node" : "link"
  name        = each.key
  # class: infraAttEntityP
  relation_infra_rs_att_ent_p = length(compact([each.value.attachable_entity_profile])
  ) > 0 ? "uni/infra/attentp-${each.value.attachable_entity_profile}" : ""
  # class: cdpIfPol
  relation_infra_rs_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  # class: coppIfPol
  relation_infra_rs_copp_if_pol = length(compact([each.value.copp_interface_policy])
  ) > 0 ? "uni/infra/coppifpol-${each.value.copp_interface_policy}" : ""
  # class: fcIfPol
  relation_infra_rs_fc_if_pol = length(compact([each.value.fibre_channel_interface_policy])
  ) > 0 ? "uni/infra/fcIfPol-${each.value.fibre_channel_interface_policy}" : ""
  # class: fabricHIfPol
  relation_infra_rs_h_if_pol = length(compact([each.value.link_level_policy])
  ) > 0 ? "uni/infra/hintfpol-${each.value.link_level_policy}" : ""
  # class: l2IfPol
  relation_infra_rs_l2_if_pol = length(compact([each.value.l2_interface_policy])
  ) > 0 ? "uni/infra/l2IfP-${each.value.l2_interface_policy}" : ""
  # class: l2PortSecurityPol
  relation_infra_rs_l2_port_security_pol = length(compact([each.value.port_security_policy])
  ) > 0 ? "uni/infra/portsecurityP-${each.value.port_security_policy}" : ""
  # class: lacpLagPol
  relation_infra_rs_lacp_pol = length(compact([each.value.port_channel_policy])
  ) > 0 ? "uni/infra/lacplagp-${each.value.port_channel_policy}" : ""
  # class: lldpIfPol
  relation_infra_rs_lldp_if_pol = length(compact([each.value.lldp_interface_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_interface_policy}" : ""
  # class: macsecIfPol
  relation_infra_rs_macsec_if_pol = length(compact([each.value.macsec_policy])
  ) > 0 ? "uni/infra/macsecifp-${each.value.macsec_policy}" : ""
  # class: mcpIfPol
  relation_infra_rs_mcp_if_pol = length(compact([each.value.mcp_interface_policy])
  ) > 0 ? "uni/infra/mcpIfP-${each.value.mcp_interface_policy}" : ""
  # class: monFabricPol
  relation_infra_rs_mon_if_infra_pol = length(compact([each.value.monitoring_policy])
  ) > 0 ? "uni/infra/moninfra-${each.value.monitoring_policy}" : ""
  # class: netflowMonitorPol
  dynamic "relation_infra_rs_netflow_monitor_pol" {
    for_each = each.value.netflow_monitor_policies
    content {
      flt_type  = relation_infra_rs_netflow_monitor_pol.value.ip_filter_type
      target_dn = "uni/infra/monitorpol-${relation_infra_rs_netflow_monitor_pol.value.netflow_monitor_policy}"
    }
  }
  # class: qosDppPol
  relation_infra_rs_qos_egress_dpp_if_pol = length(compact([each.value.data_plane_policing_egress])
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_egress}" : ""
  # class: qosDppPol
  relation_infra_rs_qos_ingress_dpp_if_pol = length(compact([each.value.data_plane_policing_ingress])
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_ingress}" : ""
  # class: qosPfcIfPol
  relation_infra_rs_qos_pfc_if_pol = length(compact([each.value.priority_flow_control_policy])
  ) > 0 ? "uni/infra/pfc-${each.value.priority_flow_control_policy}" : ""
  # class: qosSdIfPol
  relation_infra_rs_qos_sd_if_pol = length(compact([each.value.slow_drain_policy])
  ) > 0 ? "uni/infra/qossdpol-${each.value.slow_drain_policy}" : ""
  ## class: spanVDestGrp
  #relation_infra_rs_span_v_dest_grp = length(compact(each.value.vspan_destination_groups)
  #) > 0 ? [for s in each.value.vspan_destination_groups : "uni/infra/vdestgrp-${s}"] : []
  ## class: spanVSrcGrp
  #relation_infra_rs_span_v_src_grp = length(compact(each.value.vspan_source_groups)
  #) > 0 ? [for s in each.value.vspan_source_groups : "uni/infra/vsrcgrp-${s}"] : []
  # class: stormctrlIfPol
  relation_infra_rs_stormctrl_if_pol = length(compact([each.value.storm_control_policy])
  ) > 0 ? "uni/infra/stormctrlifp-${each.value.storm_control_policy}" : ""
  # class: stpIfPol
  relation_infra_rs_stp_if_pol = length(compact([each.value.spanning_tree_interface_policy])
  ) > 0 ? "uni/infra/ifPol-${each.value.spanning_tree_interface_policy}" : ""
}
