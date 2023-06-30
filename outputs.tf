/*_____________________________________________________________________________________________________________________

Interface Leaf Interface Policy Group — Outputs (Access/Breakout/Bundle)
_______________________________________________________________________________________________________________________
*/
output "interface-leaf-leaf_interfaces-policy_groups" {
  description = <<-EOT
    * access - Identifiers for Access Policy Groups.  Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Access Port.
    * breakout - Identifiers for Breakout Policy Groups.  Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Breakout Port Group.
    * bundle - Identifiers for Bundle Policy Groups.  Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => [ VPC Interface | VPC Interface ].
  EOT
  value = {
    access = { for v in sort(keys(aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access)
    ) : v => aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access[v].id }
    breakout = { for v in sort(keys(aci_leaf_breakout_port_group.leaf_interfaces_policy_groups_breakout)
    ) : v => aci_leaf_breakout_port_group.leaf_interfaces_policy_groups_breakout[v].id }
    bundle = { for v in sort(keys(aci_leaf_access_bundle_policy_group.leaf_interfaces_policy_groups_bundle)
    ) : v => aci_leaf_access_bundle_policy_group.leaf_interfaces_policy_groups_bundle[v].id }
  }
}


/*_____________________________________________________________________________________________________________________

Spine — Interface Policy Groups — Outputs
_______________________________________________________________________________________________________________________
*/
output "interface-interfaces-spine_interface-policy_groups" {
  description = "Identifiers for Spine Interface Policy Groups.  Fabric => Access Policies => Interfaces => Spine Interfaces => Policy Groups."
  value = { for v in sort(keys(aci_spine_port_policy_group.spine_interface_policy_groups)
  ) : v => aci_spine_port_policy_group.spine_interface_policy_groups[v].id }
}


/*_____________________________________________________________________________________________________________________

Physical and External Domains — Outputs
_______________________________________________________________________________________________________________________
*/
output "physical_and_external_domains" {
  description = <<-EOT
    * l3_domains - Identifiers for L3 Domains.  Fabric => Access Policies => Physical and External Domains => L3 Domains.
    * physical_domains - Identifiers for Physical Domains.  Fabric => Access Policies => Physical and External Domains => Physical Domains.
  EOT
  value = {
    l3_domains = { for v in sort(keys(aci_l3_domain_profile.l3_domains)
    ) : v => aci_l3_domain_profile.l3_domains[v].id }
    physical_domains = { for v in sort(keys(aci_physical_domain.physical_domains)
    ) : v => aci_physical_domain.physical_domains[v].id }
  }
}


/*_____________________________________________________________________________________________________________________

Policies -> Global — Outputs
_______________________________________________________________________________________________________________________
*/
output "policies-global-attachable_access_entity_profiles" {
  description = "Identifiers for AAEPs.  Fabric => Access Policies => Policies => Global => Attachable Access Entity Profiles."
  value = { for v in sort(keys(aci_attachable_access_entity_profile.attachable_access_entity_profiles)
  ) : v => aci_attachable_access_entity_profile.attachable_access_entity_profiles[v].id }
}

output "policies-global-dhcp_relay" {
  description = "Identifiers for DHCP Relay.  Fabric => Access Policies => Policies => Global => DHCP Relay."
  value = { for v in sort(keys(aci_rest_managed.dhcp_relay)
  ) : v => aci_rest_managed.dhcp_relay[v].id }
}

output "policies-global-error_disabled_recovery_policy" {
  description = "Identifiers for Error Disabled Recovery.  Fabric => Access Policies => Policies => Global => Error Disabled Recovery Profiles."
  value = { for v in sort(keys(aci_error_disable_recovery.error_disabled_recovery)
  ) : v => aci_error_disable_recovery.error_disabled_recovery[v].id }
}

output "policies-global-mcp_instance_policy" {
  description = "Identifiers for MCP Instance Policy.  Fabric => Access Policies => Policies => Global => MCP Instance Policy - default."
  value = { for v in sort(keys(aci_mcp_instance_policy.mcp_instance)
  ) : v => aci_mcp_instance_policy.mcp_instance[v].id }
}

output "policies-global-qos_class" {
  description = "Identifiers for QoS Class.  Fabric => Access Policies => Policies => Global => QoS Class."
  value = { for v in sort(keys(aci_qos_instance_policy.qos_class)
  ) : v => aci_qos_instance_policy.qos_class[v].id }
}


/*_____________________________________________________________________________________________________________________

Interface Policies — Outputs
_______________________________________________________________________________________________________________________
*/
output "policies-interface-cdp_interface" {
  description = "Identifiers for CDP Interface Policies.  Fabric => Access Policies => Policies => Interfaces => CDP Interface."
  value = { for v in sort(keys(aci_cdp_interface_policy.cdp_interface)
  ) : v => aci_cdp_interface_policy.cdp_interface[v].id }
}

output "policies-interface-fibre_channel_interface" {
  description = "Identifiers for Fibre Channel Interface Policies.  Fabric => Access Policies => Policies => Interfaces => Fibre Channel Interface."
  value = { for v in sort(keys(aci_interface_fc_policy.fibre_channel_interface)
  ) : v => aci_interface_fc_policy.fibre_channel_interface[v].id }
}

output "policies-interface-l2_interface" {
  description = "Identifiers for L2 Interface Policies.  Fabric => Access Policies => Policies => Interfaces => L2 Interface."
  value = { for v in sort(keys(aci_l2_interface_policy.l2_interface)
  ) : v => aci_l2_interface_policy.l2_interface[v].id }
}

output "policies-interface-link_level" {
  description = "Identifiers for Link Level Policies.  Fabric => Access Policies => Policies => Interfaces => Link Level."
  value = { for v in sort(keys(aci_fabric_if_pol.link_level)
  ) : v => aci_fabric_if_pol.link_level[v].id }
}

output "policies-interface-lldp_interface" {
  description = "Identifiers for LLDP Interface Policies.  Fabric => Access Policies => Policies => Interfaces => LLDP Interface."
  value = local.lldp_interface != {} ? { for v in sort(
    keys(aci_lldp_interface_policy.lldp_interface)
  ) : v => aci_lldp_interface_policy.lldp_interface[v].id } : {}
}

output "policies-interface-mcp_interface" {
  description = "Identifiers for MCP Interface Policies.  Fabric => Access Policies => Policies => Interfaces => MCP Interface."
  value = { for v in sort(keys(aci_miscabling_protocol_interface_policy.mcp_interface)
  ) : v => aci_miscabling_protocol_interface_policy.mcp_interface[v].id }
}

output "policies-interface-port_channel" {
  description = "Identifiers for Port Channel Policies.  Fabric => Access Policies => Policies => Interfaces => Port Channel."
  value = { for v in sort(keys(aci_lacp_policy.port_channel)
  ) : v => aci_lacp_policy.port_channel[v].id }
}

output "policies-interface-port_security" {
  description = "Identifiers for Port Security Policies.  Fabric => Access Policies => Policies => Interfaces => Port Security."
  value = { for v in sort(keys(aci_port_security_policy.port_security)
  ) : v => aci_port_security_policy.port_security[v].id }
}

output "policies-interface-spanning_tree_interface" {
  description = "Identifiers for Spanning-Tree Interface Policies.  Fabric => Access Policies => Policies => Interfaces => Spanning-Tree Interface."
  value = { for v in sort(keys(aci_spanning_tree_interface_policy.spanning_tree_interface)
  ) : v => aci_spanning_tree_interface_policy.spanning_tree_interface[v].id }
}


/*_____________________________________________________________________________________________________________________

Pools — VLAN Outputs
_______________________________________________________________________________________________________________________
*/
output "pools-vlan" {
  description = "Identifiers for VLAN Pools.  Fabric => Access Policies => Pools => VLAN."
  value = { for v in sort(keys(aci_vlan_pool.vlan_pools)
  ) : v => aci_vlan_pool.vlan_pools[v].id }
}


/*_____________________________________________________________________________________________________________________

Switches — Policy Groups — Outputs
_______________________________________________________________________________________________________________________
*/
output "switches-leaf_switches-policy_groups" {
  description = "Identifiers for Leaf Switches Policy Groups.  Fabric => Access Policies => Switches => Leaf Switches => Policy Groups."
  value = { for v in sort(keys(aci_access_switch_policy_group.switches_leaf_policy_groups)
  ) : v => aci_access_switch_policy_group.switches_leaf_policy_groups[v].id }
}

output "switches-spine_switches-policy_groups" {
  description = "Identifiers for Spine Switches Policy Groups.  Fabric => Access Policies => Switches => Spines Switches => Policy Groups."
  value = { for v in sort(keys(aci_spine_switch_policy_group.switches_spine_policy_groups)
  ) : v => aci_spine_switch_policy_group.switches_spine_policy_groups[v].id }
}


/*_____________________________________________________________________________________________________________________

Virtual Networking — VMM Domain — Outputs
_______________________________________________________________________________________________________________________
*/
output "virtual_networking-vmm_domains" {
  description = <<-EOT
    * controllers - Identifiers for VMM Controllers.  Virtual Networking => {VMM Doamin} => Controllers: {controller_name}.
    * credentials - Identifiers for VMM Domain Credentials.  Virtual Networking => {VMM Doamin}: vCenter Credentials.
    * vmm_domains - Identifiers for VMM Domains.  Virtual Networking.
    * vswitch_policies - Identifiers for VMM Domain Virtual Switch Policies.  Virtual Networking => {VMM Doamin}: vSwitch Policy
  EOT
  value = {
    controllers = { for v in sort(keys(aci_vmm_controller.controllers)
    ) : v => aci_vmm_controller.controllers[v].id }
    credentials = { for v in sort(keys(aci_vmm_credential.credentials)
    ) : v => aci_vmm_credential.credentials[v].id }
    vmm_domains = { for v in sort(keys(aci_vmm_domain.vmm_domains)
    ) : v => aci_vmm_domain.vmm_domains[v].id }
    vswitch_policies = { for v in sort(keys(aci_vswitch_policy.vswitch_policies)
    ) : v => aci_vswitch_policy.vswitch_policies[v].id }
  }
}
