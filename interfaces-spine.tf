/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpAccPortGrp"
 - Distinguished Name: "uni/infra/funcprof/spaccportgrp-{name}"
GUI Location:
 - Fabric > Interfaces > Spine Interfaces > Policy Groups > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_port_policy_group" "map" {
  depends_on = [
    aci_attachable_access_entity_profile.map,
    aci_cdp_interface_policy.map,
    aci_fabric_if_pol.map,
  ]
  for_each    = local.spine_interface_policy_groups
  description = each.value.description
  name        = each.key
  # class: infraAttEntityP
  relation_infra_rs_att_ent_p = length(compact([each.value.attachable_entity_profile])
  ) > 0 ? "uni/infra/attentp-${each.value.attachable_entity_profile}" : ""
  # class: cdpIfPol
  relation_infra_rs_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  # class: fabricHIfPol
  relation_infra_rs_h_if_pol = length(compact([each.value.link_level_policy])
  ) > 0 ? "uni/infra/hintfpol-${each.value.link_level_policy}" : ""
  # class: macsecIfPol
  relation_infra_rs_macsec_if_pol = length(compact([each.value.macsec_policy])
  ) > 0 ? "uni/infra/macsecifp-${each.value.macsec_policy}" : ""
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/funcprof/spaccportgrp-{name}/alias"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > Leaf Access Port > {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "spine_interface_policy_groups_global_alias" {
  depends_on = [
    aci_spine_port_policy_group.map,
  ]
  for_each   = { for k, v in local.spine_interface_policy_groups : k => v if v.global_alias != "" }
  class_name = "tagAliasInst"
  dn         = "uni/infra/funcprof/spaccportgrp-${each.key}"
  content = {
    name = each.value.global_alias
  }
}
