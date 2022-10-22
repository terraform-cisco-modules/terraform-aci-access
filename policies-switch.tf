/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vpcInstPol"
 - Distinguished Name: "uni/fabric/vpcInst-{name}"
GUI Location:
 - Fabric -> Access Policies -> Policies -> Switch -> VPC Domain -> Create VPC Domain Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_vpc_domain_policy" "vpc_domain" {
  for_each = {
    for v in toset(["default"]) : "default" => v if local.recommended_settings.vpc_domain == true
  }
  annotation  = coalesce(local.vpc.annotation, var.annotation)
  dead_intvl  = local.vpc.dead_interval
  description = local.vpc.description
  name        = each.key
}
