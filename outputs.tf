/*_____________________________________________________________________________________________________________________

Domain Policies — Outputs
_______________________________________________________________________________________________________________________
*/
output "l3_domains" {
  value = local.l3_domains != {} ? { for v in sort(
    keys(aci_l3_domain_profile.l3_domains)
  ) : v => aci_l3_domain_profile.l3_domains[v].id } : {}
}

output "physical_domains" {
  value = local.physical_domains != {} ? { for v in sort(
    keys(aci_physical_domain.physical_domains)
  ) : v => aci_physical_domain.physical_domains[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Global Policies/Profiles — Outputs
_______________________________________________________________________________________________________________________
*/
output "attachable_access_entity_profiles" {
  value = local.attachable_access_entity_profiles != {} ? { for v in sort(
    keys(aci_attachable_access_entity_profile.attachable_access_entity_profiles)
  ) : v => aci_attachable_access_entity_profile.attachable_access_entity_profiles[v].id } : {}
}

output "dhcp_relay" {
  value = local.dhcp_relay != {} ? { for v in sort(
    keys(aci_rest_managed.dhcp_relay)
  ) : v => aci_rest_managed.dhcp_relay[v].id } : {}
}

output "error_disabled_recovery_policy" {
  value = local.recommended_settings.error_disabled_recovery == true ? { for v in sort(
    keys(aci_error_disable_recovery.error_disabled_recovery)
  ) : v => aci_error_disable_recovery.error_disabled_recovery[v].id } : {}
}

output "mcp_instance_policy" {
  value = local.recommended_settings.mcp_instance == true ? { for v in sort(
    keys(aci_mcp_instance_policy.mcp_instance)
  ) : v => aci_mcp_instance_policy.mcp_instance[v].id } : {}
}

output "qos_class" {
  value = local.recommended_settings.qos_class == true ? { for v in sort(
    keys(aci_qos_instance_policy.qos_class)
  ) : v => aci_qos_instance_policy.qos_class[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Leaf Interface Policy Group — Outputs (Access/Breakout/Bundle)
_______________________________________________________________________________________________________________________
*/
output "leaf_interfaces_policy_groups_access" {
  value = local.leaf_interfaces_policy_groups_access != {} ? { for v in sort(
    keys(aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access)
  ) : v => aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access[v].id } : {}
}

output "leaf_interfaces_policy_groups_breakout" {
  value = local.leaf_interfaces_policy_groups_breakout != {} ? { for v in sort(
    keys(aci_leaf_breakout_port_group.leaf_interfaces_policy_groups_breakout)
  ) : v => aci_leaf_breakout_port_group.leaf_interfaces_policy_groups_breakout[v].id } : {}
}

output "leaf_interfaces_policy_groups_bundle" {
  value = local.leaf_interfaces_policy_groups_bundle != {} ? { for v in sort(
    keys(aci_leaf_access_bundle_policy_group.leaf_interfaces_policy_groups_bundle)
  ) : v => aci_leaf_access_bundle_policy_group.leaf_interfaces_policy_groups_bundle[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Interface Policies — Outputs
_______________________________________________________________________________________________________________________
*/
output "cdp_interface" {
  value = local.cdp_interface != {} ? { for v in sort(
    keys(aci_cdp_interface_policy.cdp_interface)
  ) : v => aci_cdp_interface_policy.cdp_interface[v].id } : {}
}

output "fibre_channel_interface" {
  value = local.fibre_channel_interface != {} ? { for v in sort(
    keys(aci_interface_fc_policy.fibre_channel_interface)
  ) : v => aci_interface_fc_policy.fibre_channel_interface[v].id } : {}
}

output "l2_interface" {
  value = local.l2_interface != {} ? { for v in sort(
    keys(aci_l2_interface_policy.l2_interface)
  ) : v => aci_l2_interface_policy.l2_interface[v].id } : {}
}

output "link_level" {
  value = local.link_level != {} ? { for v in sort(
    keys(aci_fabric_if_pol.link_level)
  ) : v => aci_fabric_if_pol.link_level[v].id } : {}
}

output "lldp_interface" {
  value = local.lldp_interface != {} ? { for v in sort(
    keys(aci_lldp_interface_policy.lldp_interface)
  ) : v => aci_lldp_interface_policy.lldp_interface[v].id } : {}
}

output "mcp_interface" {
  value = local.mcp_interface != {} ? { for v in sort(
    keys(aci_miscabling_protocol_interface_policy.mcp_interface)
  ) : v => aci_miscabling_protocol_interface_policy.mcp_interface[v].id } : {}
}

output "port_channel" {
  value = local.port_channel != {} ? { for v in sort(
    keys(aci_lacp_policy.port_channel)
  ) : v => aci_lacp_policy.port_channel[v].id } : {}
}

output "port_security" {
  value = local.port_security != {} ? { for v in sort(
    keys(aci_port_security_policy.port_security)
  ) : v => aci_port_security_policy.port_security[v].id } : {}
}

output "spanning_tree_interface" {
  value = local.spanning_tree_interface != {} ? { for v in sort(
    keys(aci_spanning_tree_interface_policy.spanning_tree_interface)
  ) : v => aci_spanning_tree_interface_policy.spanning_tree_interface[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Pools — VLAN Outputs
_______________________________________________________________________________________________________________________
*/
output "vlan_pools" {
  value = local.vlan_pools != {} ? { for v in sort(
    keys(aci_vlan_pool.vlan_pools)
  ) : v => aci_vlan_pool.vlan_pools[v].id } : {}
}

/*_____________________________________________________________________________________________________________________

Spine — Interface Policy Groups — Outputs
_______________________________________________________________________________________________________________________
*/
output "spine_interface_policy_groups" {
  value = local.spine_interface_policy_groups != {} ? { for v in sort(
    keys(aci_spine_port_policy_group.spine_interface_policy_groups)
  ) : v => aci_spine_port_policy_group.spine_interface_policy_groups[v].id } : {}
}

/*_____________________________________________________________________________________________________________________

Switches — Policy Groups — Outputs
_______________________________________________________________________________________________________________________
*/
output "switches_leaf_policy_groups" {
  value = local.switches_leaf_policy_groups != {} ? { for v in sort(
    keys(aci_access_switch_policy_group.switches_leaf_policy_groups)
  ) : v => aci_access_switch_policy_group.switches_leaf_policy_groups[v].id } : {}
}

output "switches_spine_policy_groups" {
  value = local.switches_spine_policy_groups != {} ? { for v in sort(
    keys(aci_spine_switch_policy_group.switches_spine_policy_groups)
  ) : v => aci_spine_switch_policy_group.switches_spine_policy_groups[v].id } : {}
}

/*_____________________________________________________________________________________________________________________

Virtual Networking — VMM Domain — Outputs
_______________________________________________________________________________________________________________________
*/
output "vmm_domains" {
  value = local.vmm_domains != {} ? { for v in sort(
    keys(aci_vmm_domain.vmm_domains)
  ) : v => aci_vmm_domain.vmm_domains[v].id } : {}
}
