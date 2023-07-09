/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extDomP"
 - Distinguished Name: "uni/l3dom-{{name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > L3 Domains: {{name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_domain_profile" "map" {
  depends_on = [
    aci_vlan_pool.vlan_pools
  ]
  for_each                  = local.l3_domains
  name                      = each.key
  relation_infra_rs_vlan_ns = aci_vlan_pool.vlan_pools[each.value.vlan_pool].id
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "physDomP"
 - Distinguished Name: "uni/infra/phys-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > Physical Domains: {{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_physical_domain" "map" {
  depends_on = [
    aci_vlan_pool.vlan_pools
  ]
  for_each                  = local.physical_domains
  name                      = each.key
  relation_infra_rs_vlan_ns = aci_vlan_pool.vlan_pools[each.value.vlan_pool].id
}
