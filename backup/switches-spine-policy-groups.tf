/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpineAccNodePGrp"
 - Distinguished Name: "uni/infra/funcprof/spaccnodepgrp-{name}"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Policy Groups: {name}

BFD IPv4 Policy
 - Class: "bfdIpv4InstPol"
 - Distinguished Name: "uni/infra/bfdIpv4Inst-{bfd_ipv4_policy}"
BFD IPv6 Policy
 - Class: "bfdIpv6InstPol"
 - Distinguished Name: "uni/infra/bfdIpv6Inst-{bfd_ipv6_policy}"
CDP Policy
 - Class: "cdpIfPol"
 - Distinguished Name: "uni/infra/cdpIfP-{cdp_interface_policy}"
CoPP Spine Policy
 - Class: "coppSpineProfile"
 - Distinguished Name: "uni/infra/coppspinep-{copp_spine_policy}"
CoPP Pre-Filter
 - Class: "iaclSpineProfile"
 - Distinguished Name: "uni/infra/iaclspinep-{copp_pre_filter}"
LLDP Policy
 - Class: "lldpIfPol"
 - Distinguished Name: "uni/infra/lldpIfP-{lldp_interface_policy}"
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_switch_policy_group" "switches_spine_policy_groups" {
  for_each    = local.switches_spine_policy_groups
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  relation_infra_rs_iacl_spine_profile = length(compact([each.value.copp_pre_filter])
  ) > 0 ? "uni/infra/iaclspinep-${each.value.copp_pre_filter}" : ""
  relation_infra_rs_spine_bfd_ipv4_inst_pol = length(compact([each.value.bfd_ipv4_policy])
  ) > 0 ? "uni/infra/bfdIpv4Inst-${each.value.bfd_ipv4_policy}" : ""
  relation_infra_rs_spine_bfd_ipv6_inst_pol = length(compact([each.value.bfd_ipv6_policy])
  ) > 0 ? "uni/infra/bfdIpv6Inst-${each.value.bfd_ipv6_policy}" : ""
  relation_infra_rs_spine_copp_profile = length(compact([each.value.copp_spine_policy])
  ) > 0 ? "uni/infra/coppspinep-${each.value.copp_spine_policy}" : ""
  relation_infra_rs_spine_p_grp_to_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  relation_infra_rs_spine_p_grp_to_lldp_if_pol = length(compact([each.value.lldp_interface_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_interface_policy}" : ""
}
