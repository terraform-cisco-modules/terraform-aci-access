/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extDomP"
 - Distinguished Name: "uni/l3dom-{{name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > L3 Domains: {{name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_domain_profile" "domains_layer3" {
  depends_on = [
    aci_vlan_pool.pools_vlan
  ]
  for_each                  = local.domains_layer3
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                      = each.key
  relation_infra_rs_vlan_ns = aci_vlan_pool.pools_vlan[each.value.vlan_pool].id
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "physDomP"
 - Distinguished Name: "uni/infra/phys-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > Physical Domains: {{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_physical_domain" "domains_physical" {
  depends_on = [
    aci_vlan_pool.pools_vlan
  ]
  for_each                  = local.domains_physical
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                      = each.key
  relation_infra_rs_vlan_ns = aci_vlan_pool.pools_vlan[each.value.vlan_pool].id
}
