/*_____________________________________________________________________________________________________________________

Interface — Outputs
_______________________________________________________________________________________________________________________
*/
output "interface" {
  description = <<-EOT
    Interface Identifiers
      leaf_interfaces:
        policy_groups
          access:   Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Access Port.
          breakout: Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Breakout Port Group.
          bundle:   Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => [ VPC Interface | VPC Interface ].
      spine_interfaces:
        policy_groups: Fabric => Access Policies => Interfaces => Spine Interfaces => Policy Groups
  EOT
  value = {
    leaf_interfaces = {
      policy_groups = {
        access = {
          for v in sort(keys(aci_leaf_access_port_policy_group.map)) : v => aci_leaf_access_port_policy_group.map[v].id
        }
        breakout = {
          for v in sort(keys(aci_leaf_breakout_port_group.map)) : v => aci_leaf_breakout_port_group.map[v].id
        }
        bundle = {
          for v in sort(keys(aci_leaf_access_bundle_policy_group.map)) : v => aci_leaf_access_bundle_policy_group.map[v].id
        }
      }
    }
    spine_interfaces = {
      policy_groups = {
        for v in sort(keys(aci_spine_port_policy_group.map)) : v => aci_spine_port_policy_group.map[v].id
      }
    }
  }
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
    l3_domains       = { for v in sort(keys(aci_l3_domain_profile.map)) : v => aci_l3_domain_profile.map[v].id }
    physical_domains = { for v in sort(keys(aci_physical_domain.map)) : v => aci_physical_domain.map[v].id }
  }
}


/*_____________________________________________________________________________________________________________________

Policies -> Global — Outputs
_______________________________________________________________________________________________________________________
*/
output "global" {
  description = <<-EOT
    Global Identifiers
      attachable_access_entity_profiles: Fabric => Access Policies => Policies => Global => Attachable Access Entity Profiles
      dhcp_relay:                        Fabric => Access Policies => Policies => Global => DHCP Relay
      error_disabled_recovery_policy:    Fabric => Access Policies => Policies => Global => Error Disabled Recovery Profiles
      mcp_instance_policy:               Fabric => Access Policies => Policies => Global => MCP Instance Policy - default
      qos_class:                         Fabric => Access Policies => Policies => Global => QoS Class
  EOT
  value = {
    attachable_access_entity_profiles = {
      for v in sort(keys(aci_attachable_access_entity_profile.map)) : v => aci_attachable_access_entity_profile.map[v].id
    }
    dhcp_relay = { for v in sort(keys(aci_rest_managed.dhcp_relay)) : v => aci_rest_managed.dhcp_relay[v].id }
    error_disabled_recovery_policy = {
      for v in sort(keys(aci_error_disable_recovery.map)) : v => aci_error_disable_recovery.map[v].id
    }
    mcp_instance_policy = { for v in sort(keys(aci_mcp_instance_policy.map)) : v => aci_mcp_instance_policy.map[v].id }
    qos_class           = { for v in sort(keys(aci_qos_instance_policy.map)) : v => aci_qos_instance_policy.map[v].id }
  }
}

output "aaep_to_epgs" {
  value = { for k, v in local.attachable_access_entity_profiles : k => {
    access_or_native_vlan = v.access_or_native_vlan
    allowed_vlans = v.allowed_vlans
    name = k
  }}
}

/*_____________________________________________________________________________________________________________________

Interface Policies — Outputs
_______________________________________________________________________________________________________________________
*/
output "policies" {
  description = <<EOF
   Policies Identifiers
    interface:
      cdp_interface: Fabric => Access Policies => Policies => Interfaces => CDP Interface
      fibre_channel_interface: Fabric => Access Policies => Policies => Interfaces => Fibre Channel Interface
      l2_interface: Fabric => Access Policies => Policies => Interfaces => L2 Interface
      link_level: Fabric => Access Policies => Policies => Interfaces => Link Level.
      cdp_interface: Fabric => Access Policies => Policies => Interfaces => LLDP Interface.
      cdp_interface: Fabric => Access Policies => Policies => Interfaces => Port Channel.
      cdp_interface: Fabric => Access Policies => Policies => Interfaces => Port Security.
      cdp_interface: Fabric => Access Policies => Policies => Interfaces => Spanning-Tree Interface.
  EOF
  value = {
    interface = {
      cdp_interface = { for v in sort(keys(aci_cdp_interface_policy.map)) : v => aci_cdp_interface_policy.map[v].id }
      fibre_channel_interface = {
        for v in sort(keys(aci_interface_fc_policy.map)) : v => aci_interface_fc_policy.map[v].id
      }
      l2_interface   = { for v in sort(keys(aci_l2_interface_policy.map)) : v => aci_l2_interface_policy.map[v].id }
      link_level     = { for v in sort(keys(aci_fabric_if_pol.map)) : v => aci_fabric_if_pol.map[v].id }
      lldp_interface = { for v in sort(keys(aci_lldp_interface_policy.map)) : v => aci_lldp_interface_policy.map[v].id }
      mcp_interface = {
        for v in sort(keys(aci_miscabling_protocol_interface_policy.map)) : v => aci_miscabling_protocol_interface_policy.map[v].id
      }
      port_channel  = { for v in sort(keys(aci_lacp_policy.map)) : v => aci_lacp_policy.map[v].id }
      port_security = { for v in sort(keys(aci_port_security_policy.map)) : v => aci_port_security_policy.map[v].id }
      spanning_tree_interface = {
        for v in sort(keys(aci_spanning_tree_interface_policy.map)) : v => aci_spanning_tree_interface_policy.map[v].id
      }
    }
  }
}


/*_____________________________________________________________________________________________________________________

Pools — VLAN Outputs
_______________________________________________________________________________________________________________________
*/
output "pools" {
  description = "Identifiers for VLAN Pools.  Fabric => Access Policies => Pools => VLAN."
  value = {
    vlan = { for v in sort(keys(aci_vlan_pool.vlan_pools)) : v => aci_vlan_pool.vlan_pools[v].id }
  }
}


/*_____________________________________________________________________________________________________________________

Switches — Policy Groups — Outputs
_______________________________________________________________________________________________________________________
*/
output "switches" {
  description = <<EOF
   Switches Identifiers
    leaf_switches:
      policy_groups: Fabric => Access Policies => Switches => Leaf Switches => Policy Groups
    spine_switches:
      policy_groups: Fabric => Access Policies => Switches => Spine Switches => Policy Groups
  EOF
  value = {
    leaf_switches = {
      policy_groups = { for v in sort(keys(aci_access_switch_policy_group.map)) : v => aci_access_switch_policy_group.map[v].id
      }
    }
    spine_switches = {
      policy_groups = { for v in sort(keys(aci_spine_switch_policy_group.map)) : v => aci_spine_switch_policy_group.map[v].id
      }
    }
  }
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
    controllers      = { for v in sort(keys(aci_vmm_controller.map)) : v => aci_vmm_controller.map[v].id }
    credentials      = { for v in sort(keys(aci_vmm_credential.map)) : v => aci_vmm_credential.map[v].id }
    vmm_domains      = { for v in sort(keys(aci_vmm_domain.map)) : v => aci_vmm_domain.map[v].id }
    vswitch_policies = { for v in sort(keys(aci_vswitch_policy.map)) : v => aci_vswitch_policy.map[v].id }
  }
}
