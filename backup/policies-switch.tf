/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vpcInstPol"
 - Distinguished Name: "uni/fabric/vpcInst-{name}"
GUI Location:
 - Fabric -> Access Policies -> Policies -> Switch -> VPC Domain -> Create VPC Domain Policy
*/
resource "aci_vpc_domain_policy" "vpc_domain_policies" {
  for_each    = local.vpc_domain_policies
  annotation  = each.value.annotation
  dead_intvl  = each.value.dead_interval
  description = each.value.description
  name        = each.key
}
