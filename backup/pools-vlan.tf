/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvnsVlanInstP"
 - Distinguished name: "uni/infra/vlanns-[{name}]-{allocation_mode}"
GUI Location:
 - Fabric > Access Policies > Pools > VLAN:[{name}]
_______________________________________________________________________________________________________________________
*/
resource "aci_vlan_pool" "pools_vlan" {
  for_each    = local.pools_vlan
  annotation  = each.value.annotation
  alloc_mode  = each.value.allocation_mode
  description = each.value.description
  name        = each.key
}

resource "aci_ranges" "vlans" {
  depends_on = [
    aci_vlan_pool.pools_vlan
  ]
  for_each     = local.vlan_ranges
  annotation   = each.value.annotation
  description  = each.value.description
  alloc_mode   = each.value.allocation_mode
  from         = "vlan-${each.value.vlan}"
  to           = "vlan-${each.value.vlan}"
  role         = each.value.role
  vlan_pool_dn = aci_vlan_pool.pools_vlan[each.value.key1].id
}
