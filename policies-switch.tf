/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vpcInstPol"
 - Distinguished Name: "uni/fabric/vpcInst-{name}"
GUI Location:
 - Fabric -> Access Policies -> Policies -> Switch -> VPC Domain -> Create VPC Domain Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "vpc_domain_policy" {
  for_each = {
    for v in [local.vpc_domain] : "default" => v if v.create == true
  }
  class_name = "vpcInstPol"
  dn         = "uni/fabric/vpcInst-${each.key}"
  content = {
    descr           = each.value.description
    name            = each.key
    deadIntvl       = each.value.peer_dead_interval
    delayRestoreTmr = each.value.delay_restore_timer
  }
}
#resource "aci_vpc_domain_policy" "map" {
#  for_each = {
#    for v in [local.vpc_domain] : "default" => v if v.create == true
#  }
#  dead_intvl  = each.value.peer_dead_interval
#  description = each.value.description
#  name        = each.key
#}
