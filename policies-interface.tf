/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "cdpIfPol"
 - Distinguished Name: "uni/infra/cdpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > CDP Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_cdp_interface_policy" "map" {
  for_each    = local.cdp_interface
  admin_st    = each.value.admin_state
  description = each.value.description
  name        = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/cdpIfP-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > CDP Interface : {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "cdp_interface_global_alias" {
  depends_on = [
    aci_cdp_interface_policy.map,
  ]
  for_each   = { for k, v in local.cdp_interface : k => v if v.global_alias != "" }
  class_name = "tagAliasInst"
  dn         = "uni/infra/cdpIfP-${each.key}"
  content = {
    name = each.value.global_alias
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fcIfPol"
 - Distinguished Name: "uni/infra/fcIfPol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Fibre Channel Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_interface_fc_policy" "map" {
  for_each     = local.fibre_channel_interface
  automaxspeed = each.value.auto_max_speed
  description  = each.value.description
  fill_pattern = each.value.fill_pattern
  name         = each.key
  port_mode    = each.value.port_mode
  rx_bb_credit = each.value.receive_buffer_credit
  speed        = each.value.speed
  trunk_mode   = each.value.trunk_mode
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l2IfPol"
 - Distinguished Name: "uni/infra/l2IfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > L2 Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_l2_interface_policy" "map" {
  for_each    = local.l2_interface
  description = each.value.description
  name        = each.key
  qinq        = each.value.qinq
  vepa        = each.value.reflective_relay
  vlan_scope  = each.value.vlan_scope
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricHIfPol"
 - Distinguished Name: "uni/infra/hintfpol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Link Level : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_fabric_if_pol" "map" {
  for_each      = local.link_level
  auto_neg      = each.value.auto_negotiation
  description   = each.value.description
  fec_mode      = each.value.forwarding_error_correction
  link_debounce = each.value.link_debounce_interval
  name          = each.key
  speed         = each.value.speed
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/hintfpol-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Link Level : {name}: alias
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "link_level_global_alias" {
  depends_on = [
    aci_fabric_if_pol.map,
  ]
  for_each   = { for k, v in local.link_level : k => v if v.global_alias != "" }
  class_name = "tagAliasInst"
  dn         = "uni/infra/hintfpol-${each.key}"
  content = {
    name = each.value.global_alias
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "lldpIfPol"
 - Distinguished Name: "uni/infra/lldpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > LLDP Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_lldp_interface_policy" "map" {
  for_each    = local.lldp_interface
  admin_rx_st = each.value.receive_state
  admin_tx_st = each.value.transmit_state
  description = each.value.description
  name        = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/lldpIfP-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Link Level : {name}: alias
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "lldp_interface_global_alias" {
  depends_on = [
    aci_lldp_interface_policy.map,
  ]
  for_each   = { for k, v in local.lldp_interface : k => v if v.global_alias != "" }
  class_name = "tagAliasInst"
  dn         = "uni/infra/lldpIfP-${each.key}"
  content = {
    name = each.value.global_alias
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mcpIfPol"
 - Distinguished Name: "uni/infra/mcpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > MCP Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_miscabling_protocol_interface_policy" "map" {
  for_each    = local.mcp_interface
  admin_st    = each.value.admin_state
  description = each.value.description
  name        = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "lacpLagPol"
 - Distinguished Name: "uni/infra/lacplagp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Channel : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_lacp_policy" "map" {
  for_each = local.port_channel
  ctrl = anytrue(
    [each.value.control["fast_select_hot_standby_ports"
      ], each.value.control["graceful_convergence"
      ], each.value.control["load_defer_member_ports"
      ], each.value.control["suspend_individual_port"
      ], each.value.control["symmetric_hashing"]]) ? compact(concat(
      [length(regexall(true, each.value.control.fast_select_hot_standby_ports)
        ) > 0 ? "fast-sel-hot-stdby" : ""
        ], [length(regexall(true, each.value.control.graceful_convergence)
        ) > 0 ? "graceful-conv" : ""
        ], [length(regexall(true, each.value.control.load_defer_member_ports)
        ) > 0 ? "load-defer" : ""
        ], [length(regexall(true, each.value.control.suspend_individual_port)
        ) > 0 ? "susp-individual" : ""
        ], [length(regexall(true, each.value.control.symmetric_hashing)
    ) > 0 ? "symmetric-hash" : ""])) : [
  "fast-sel-hot-stdby", "graceful-conv", "susp-individual"]
  description = each.value.description
  max_links   = each.value.maximum_number_of_links
  min_links   = each.value.minimum_number_of_links
  name        = each.key
  mode        = each.value.mode
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/lacplagp-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Channel : {name}: alias
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "port_channel_global_alias" {
  depends_on = [
    aci_lacp_policy.map,
  ]
  for_each   = { for k, v in local.port_channel : k => v if v.global_alias != "" }
  class_name = "tagAliasInst"
  dn         = "uni/infra/lacplagp-${each.key}"
  content = {
    name = each.value.global_alias
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l2PortSecurityPol"
 - Distinguished Name: "uni/infra/portsecurityP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Security : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_port_security_policy" "map" {
  for_each    = local.port_security
  description = each.value.description
  maximum     = each.value.maximum_endpoints
  name        = each.key
  timeout     = each.value.port_security_timeout
  violation   = "protect"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "stpIfPol"
 - Distinguished Name: "uni/infra/ifPol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Spanning Tree Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spanning_tree_interface_policy" "map" {
  for_each = local.spanning_tree_interface
  ctrl = length(compact([each.value.bpdu_filter, each.value.bpdu_guard])) > 0 ? compact([
    each.value.bpdu_filter == "enabled" ? "bpdu-filter" : "",
    each.value.bpdu_guard == "enabled" ? "bpdu-guard" : ""]
  ) : ["unspecified"]
  description = each.value.description
  name        = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/ifPol-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Spanning Tree Interface : {name}: alias
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "spanning_tree_interface_global_alias" {
  depends_on = [
    aci_spanning_tree_interface_policy.map,
  ]
  for_each   = { for k, v in local.spanning_tree_interface : k => v if v.global_alias != "" }
  class_name = "tagAliasInst"
  dn         = "uni/infra/ifPol-${each.key}"
  content = {
    name = each.value.global_alias
  }
}
