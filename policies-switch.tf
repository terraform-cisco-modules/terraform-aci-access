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
    for v in [local.vpc_domain] : "default" => v if v.create == true && length(
    regexall("^([5-9]|[1-9][0-9])\\.", local.apic_version)) > 0
  }
  class_name = "vpcInstPol"
  dn         = "uni/fabric/vpcInst-${each.key}"
  content = length(regexall("^([5-9]|[1-9][0-9])\\.", local.apic_version)) > 0 ? {
    deadIntvl       = each.value.peer_dead_interval
    delayRestoreTmr = each.value.delay_restore_timer
    descr           = each.value.description
    name            = each.key
    } : {
    deadIntvl = each.value.peer_dead_interval
    descr     = each.value.description
    name      = each.key
  }
}
