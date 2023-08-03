/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvnsVlanInstP"
 - Distinguished name: "uni/infra/vlanns-[{name}]-{allocation_mode}"
GUI Location:
 - Fabric > Access Policies > Pools > VLAN:[{name}]
_______________________________________________________________________________________________________________________
*/
resource "aci_vlan_pool" "vlan_pools" {
  for_each    = local.vlan_pools
  annotation  = "orchestrator:terraform"
  alloc_mode  = each.value.allocation_mode
  description = each.value.description
  name        = each.key
}

resource "aci_ranges" "vlans" {
  depends_on = [
    aci_vlan_pool.vlan_pools
  ]
  for_each     = local.vlan_ranges
  description  = each.value.description
  alloc_mode   = each.value.allocation_mode
  from         = "vlan-${each.value.from}"
  to           = "vlan-${each.value.to}"
  role         = each.value.role
  vlan_pool_dn = aci_vlan_pool.vlan_pools[each.value.vlan_pool].id
}
