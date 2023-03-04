/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccNodePGrp"
 - Distinguished Name: "uni/infra/funcprof/accnodepgrp-{name}"
GUI Location:
 - Fabric > Access Policies > Switches > Leaf Switches > Policy Groups: {name}

802.1x Node Authentication Policy
 - Class: "l2NodeAuthPol"
 - Distinguished Name: "uni/infra/nodeauthpol-{dot1x_authentication_policy}"
BFD IPv4 Policy
 - Class: "bfdIpv4InstPol"
 - Distinguished Name: "uni/infra/bfdIpv4Inst-{bfd_ipv4_policy}"
BFD IPv6 Policy
 - Class: "bfdIpv6InstPol"
 - Distinguished Name: "uni/infra/bfdIpv6Inst-{bfd_ipv6_policy}"
BFD Multihop IPv4 Policy
 - Class: "bfdMhIpv4InstPol"
 - Distinguished Name: "uni/infra/bfdMhIpv4Inst-{bfd_multihop_ipv4_policy}"
BFD Multihop IPv6 Policy
 - Class: "bfdMhIpv6InstPol"
 - Distinguished Name: "uni/infra/bfdMhIpv6Inst-{bfd_multihop_ipv6_policy}"
CDP Policy
 - Class: "cdpIfPol"
 - Distinguished Name: "uni/infra/cdpIfP-{cdp_interface_policy}"
CoPP Leaf Policy
 - Class: "coppLeafProfile"
 - Distinguished Name: "uni/infra/coppleafp-{copp_leaf_policy}"
CoPP Pre-Filter
 - Class: "iaclLeafProfile"
 - Distinguished Name: "uni/infra/iaclleafp-{copp_pre_filter}"
Equipment Flash Config
 - Class: "equipmentFlashConfigPol"
 - Distinguished Name: "uni/infra/flashconfigpol-{equipment_flash_config}"
Fast Link Failover Policy
 - Class: "topoctrlFastLinkFailoverInstPol"
 - Distinguished Name: "uni/infra/fastlinkfailoverinstpol-{fast_link_failover_policy}"
Fibre Channel SAN Policy
 - Class: "fcFabricPol"
 - Distinguished Name: "uni/infra/fcfabricpol-{fibre_channel_san_policy}"
Fibre Channel Node Policy
 - Class: "fcInstPol"
 - Distinguished Name: "uni/infra/fcinstpol-{fibre_channel_node_policy}"
Forward Scale Profile Policy
 - Class: "topoctrlFwdScaleProfilePol"
 - Distinguished Name: "uni/infra/fwdscalepol-{forward_scale_profile_policy}"
LLDP Policy
 - Class: "lldpIfPol"
 - Distinguished Name: "uni/infra/lldpIfP-{lldp_interface_policy}"
Monitoring Policy
 - Class: "monInfraPol"
 - Distinguished Name: "uni/infra/moninfra-{monitoring_policy}"
Netflow Node Policy
 - Class: "netflowNodePol"
 - Distinguished Name: "uni/infra/nodepol-{netflow_node_policy}"
PoE Node Policy
 - Class: "poeInstPol"
 - Distinguished Name: "uni/infra/poeInstP-{poe_node_policy}"
Spanning Tree Policy (MSTP)
 - Class: "stpInstPol"
 - Distinguished Name: "uni/infra/mstpInstPol-{spanning_tree_policy}"
_______________________________________________________________________________________________________________________
*/
resource "aci_access_switch_policy_group" "switches_leaf_policy_groups" {
  depends_on = [
    aci_cdp_interface_policy.cdp_interface,
    aci_interface_fc_policy.fibre_channel_interface,
    aci_l2_interface_policy.l2_interface,
    aci_fabric_if_pol.link_level,
    aci_lldp_interface_policy.lldp_interface,
    aci_miscabling_protocol_interface_policy.mcp_interface,
    aci_lacp_policy.port_channel,
    aci_port_security_policy.port_security,
    aci_spanning_tree_interface_policy.spanning_tree_interface
  ]
  for_each    = local.switches_leaf_policy_groups
  annotation  = each.value.annotation
  description = each.value.description
  name        = each.key
  # class: bfdIpv4InstPol
  relation_infra_rs_bfd_ipv4_inst_pol = length(compact([each.value.bfd_ipv4_policy])
  ) > 0 ? "uni/infra/bfdIpv4Inst-${each.value.bfd_ipv4_policy}" : ""
  # class: bfdIpv6InstPol
  relation_infra_rs_bfd_ipv6_inst_pol = length(compact([each.value.bfd_ipv6_policy])
  ) > 0 ? "uni/infra/bfdIpv6Inst-${each.value.bfd_ipv6_policy}" : ""
  # class: bfdMhIpv4InstPol
  relation_infra_rs_bfd_mh_ipv4_inst_pol = length(regexall(
    "^([5-9]|[1-9][0-9]\\.", var.apic_version)
    ) > 0 && length(compact([each.value.bfd_multihop_ipv4_policy])
  ) > 0 ? "uni/infra/bfdMhIpv4Inst-${each.value.bfd_multihop_ipv4_policy}" : ""
  # class: bfdMhIpv6InstPol
  relation_infra_rs_bfd_mh_ipv6_inst_pol = length(regexall(
    "^([5-9]|[1-9][0-9]\\.", var.apic_version)
    ) > 0 && length(compact([each.value.bfd_multihop_ipv6_policy])
  ) > 0 ? "uni/infra/bfdMhIpv6Inst-${each.value.bfd_multihop_ipv6_policy}" : ""
  # class: equipmentFlashConfigPol
  relation_infra_rs_equipment_flash_config_pol = length(compact([each.value.equipment_flash_config])
  ) > 0 ? "uni/infra/flashconfigpol-${each.value.equipment_flash_config}" : ""
  # class: fcFabricPol
  relation_infra_rs_fc_fabric_pol = length(compact([each.value.fibre_channel_san_policy])
  ) > 0 ? "uni/infra/fcfabricpol-${each.value.fibre_channel_san_policy}" : ""
  # class: fcInstPol
  relation_infra_rs_fc_inst_pol = length(compact([each.value.fibre_channel_node_policy])
  ) > 0 ? "uni/infra/fcinstpol-${each.value.fibre_channel_node_policy}" : ""
  # class: iaclLeafProfile
  relation_infra_rs_iacl_leaf_profile = length(compact([each.value.copp_pre_filter])
  ) > 0 ? "uni/infra/iaclleafp-${each.value.copp_pre_filter}" : ""
  # class: l2NodeAuthPol
  relation_infra_rs_l2_node_auth_pol = length(compact([each.value.dot1x_node_authentication_policy])
  ) > 0 ? "uni/infra/nodeauthpol-${each.value.dot1x_node_authentication_policy}" : ""
  # class: coppLeafProfile
  relation_infra_rs_leaf_copp_profile = length(compact([each.value.copp_leaf_policy])
  ) > 0 ? "uni/infra/coppleafp-${each.value.copp_leaf_policy}" : ""
  # class: cdpIfPol
  relation_infra_rs_leaf_p_grp_to_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  # class: lldpIfPol
  relation_infra_rs_leaf_p_grp_to_lldp_if_pol = length(compact([each.value.lldp_interface_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_interface_policy}" : ""
  # class: monInfraPol
  relation_infra_rs_mon_node_infra_pol = length(compact([each.value.monitoring_policy])
  ) > 0 ? "uni/infra/moninfra-${each.value.monitoring_policy}" : ""
  # class: stpInstPol
  relation_infra_rs_mst_inst_pol = length(compact([each.value.spanning_tree_interface_policy])
  ) > 0 ? "uni/infra/mstpInstPol-${each.value.spanning_tree_interface_policy}" : ""
  # class: netflowNodePol
  relation_infra_rs_netflow_node_pol = length(compact([each.value.netflow_node_policy])
  ) > 0 ? "uni/infra/nodepol-${each.value.netflow_node_policy}" : ""
  # class: poeInstPol
  relation_infra_rs_poe_inst_pol = length(compact([each.value.poe_node_policy])
  ) > 0 ? "uni/infra/poeInstP-${each.value.poe_node_policy}" : ""
  # class: topoctrlFastLinkFailoverInstPol
  relation_infra_rs_topoctrl_fast_link_failover_inst_pol = length(compact([each.value.fast_link_failover_policy])
  ) > 0 ? "uni/infra/fastlinkfailoverinstpol-${each.value.fast_link_failover_policy}" : ""
  # class: topoctrlFwdScaleProfilePol
  relation_infra_rs_topoctrl_fwd_scale_prof_pol = length(compact([each.value.forward_scale_profile_policy])
  ) > 0 ? "uni/infra/fwdscalepol-${each.value.forward_scale_profile_policy}" : ""
}
