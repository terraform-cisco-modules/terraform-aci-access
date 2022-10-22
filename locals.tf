locals {
  #__________________________________________________________
  #
  # Model Inputs
  #__________________________________________________________

  access        = lookup(var.model, "access", {})
  defaults      = lookup(var.model, "defaults", {})
  domains       = lookup(local.access, "physical_and_external_domains", {})
  global        = lookup(lookup(local.access, "policies", {}), "global", {})
  interface     = lookup(lookup(local.access, "policies", {}), "interface", {})
  intf_pg_leaf  = lookup(lookup(lookup(local.access, "interfaces", {}), "leaf", {}), "policy_groups")
  intf_pg_spine = lookup(lookup(local.access, "interfaces", {}), "spine", {})
  pools         = lookup(local.access, "pools", {})
  pre_built     = local.defaults.access.pre_built_interface_policies
  pre_cfg = lookup(local.interface, "create_pre_built_interface_policies", {
    cdp_interface           = false
    fibre_channel_interface = false
    l2_interface            = false
    link_level              = false
    lldp_interface          = false
    mcp_interface           = false
    port_channel            = false
    port_security           = false
    spanning_tree_interface = false
  })
  recommended_settings = lookup(local.global, "recommended_settings", {
    error_disabled_recovery = false
    mcp_instance            = false
    qos_class               = false
    vpc_domain              = false
  })
  sw_pgs_leaf  = lookup(lookup(local.access, "switches", {}), "leaf")
  sw_pgs_spine = lookup(lookup(local.access, "switches", {}), "spine")
  # Defaults: Domains
  l3   = local.defaults.access.physical_and_external_domains.l3_domains
  phys = local.defaults.access.physical_and_external_domains.physical_domains
  # Defaults: Interfaces
  laccess = local.defaults.access.interfaces.leaf.policy_groups.access
  lbrkout = local.defaults.access.interfaces.leaf.policy_groups.breakout
  lbundle = local.defaults.access.interfaces.leaf.policy_groups.bundle
  saccess = local.defaults.access.interfaces.spine.policy_groups
  # Defaults: Policies -> Global
  aaep     = local.defaults.access.policies.global.attachable_access_entity_profiles
  dhcp     = local.defaults.access.policies.global.dhcp_relay
  mcpi     = local.defaults.access.policies.global.mcp_instance
  recovery = local.defaults.access.policies.global.error_disabled_recovery
  qos      = local.defaults.access.policies.global.qos_class
  # Defaults: Policies -> Interface
  cdp  = local.defaults.access.policies.interface.cdp_interface
  fc   = local.defaults.access.policies.interface.fibre_channel_interface
  l2   = local.defaults.access.policies.interface.l2_interface
  ll   = local.defaults.access.policies.interface.link_level
  lldp = local.defaults.access.policies.interface.lldp_interface
  mcp  = local.defaults.access.policies.interface.mcp_interface
  pc   = local.defaults.access.policies.interface.port_channel
  ps   = local.defaults.access.policies.interface.port_security
  stp  = local.defaults.access.policies.interface.spanning_tree_interface
  # Defaults: Policies -> Switches
  vpc = local.defaults.access.policies.switch.vpc_domain
  # Defaults: Switches -> Policy Groups
  swpgl = local.defaults.access.switches.leaf.policy_groups
  swpgs = local.defaults.access.switches.spine.policy_groups
  # Defaults: Pools -> VLAN
  vlan = local.defaults.access.pools.vlan
  # Defaults: Virtual Networking
  vmm         = local.defaults.virtual_networking
  vmm_netflow = local.vmm.vswitch_policy.vmm_netflow_export_policies

  #__________________________________________________________
  #
  # Domain Variables
  #__________________________________________________________

  l3_domains = {
    for k, v in lookup(local.domains, "l3_domains", {}) : v.name => {
      annotation = coalesce(lookup(v, "annotation", local.l3.annotation
      ), var.annotation)
      vlan_pool = lookup(v, "vlan_pool", local.l3.vlan_pool)
    }
  }

  physical_domains = {
    for k, v in lookup(local.domains, "physical_domains", {}) : v.name => {
      annotation = coalesce(lookup(v, "annotation", local.phys.annotation
      ), var.annotation)
      vlan_pool = lookup(v, "vlan_pool", local.phys.vlan_pool)
    }
  }

  #__________________________________________________________
  #
  # Global Policies Variables
  #__________________________________________________________

  #===================================
  # Attachable Access Entity Profiles
  #===================================

  attachable_access_entity_profiles = {
    for k, v in lookup(local.global, "attachable_access_entity_profiles", {}) : v.name => {
      annotation = coalesce(lookup(v, "annotation", local.aaep.annotation
      ), var.annotation)
      description = lookup(v, "description", local.aaep.description)
      domains = compact(concat(
        [for i in lookup(v, "l3_domains", []) : aci_l3_domain_profile.l3_domains["${i}"].id],
        [for i in lookup(v, "physical_domains", []) : aci_physical_domain.physical_domains["${i}"].id],
        [for i in lookup(v, "vmm_domains", []) : aci_vmm_domain.vmm_domains["${i}"].id]
      ))
    }
  }

  #===================================
  # Global - DHCP Relay 
  #===================================

  dhcp_relay = {
    for i in flatten([
      for k, v in lookup(local.global, "dhcp_relay", []) : [
        for s in range(length([for a in v.name_addr_list : a[0]])) : {
          address = element(element(v.name_addr_list, s), 1)
          annotation = coalesce(lookup(v, "annotation", local.dhcp.annotation
          ), var.annotation)
          application_profile = lookup(v, "application_profile", local.dhcp.application_profile)
          description         = lookup(v, "description", local.dhcp.description)
          epg                 = v.epg
          epg_type            = lookup(v, "epg_type", local.dhcp.epg_type)
          l3out               = lookup(v, "l3out", local.dhcp.l3out)
          mode                = lookup(v, "mode", local.dhcp.mode)
          name                = element(element(v.name_addr_list, s), 0)
          tenant              = lookup(v, "tenant", local.dhcp.tenant)
        }
      ]
    ]) : i.name => i
  }

  cdp_policies = local.pre_cfg.cdp_interface == true ? concat(local.pre_built.cdp_interface, lookup(
    local.interface, "cdp_interface", [])) : lookup(local.interface, "cdp_interface", []
  )
  fc_policies = local.pre_cfg.fibre_channel_interface == true ? concat(
    local.pre_built.fibre_channel_interface, lookup(local.interface, "fibre_channel_interface", [])
    ) : lookup(local.interface, "fibre_channel_interface", []
  )
  l2_policies = local.pre_cfg.l2_interface == true ? concat(local.pre_built.l2_interface, lookup(
    local.interface, "l2_interface", [])) : lookup(local.interface, "l2_interface", []
  )
  ll_policies = local.pre_cfg.link_level == true ? concat(local.pre_built.link_level, lookup(
    local.interface, "link_level", [])) : lookup(local.interface, "link_level", []
  )
  lldp_policies = local.pre_cfg.lldp_interface == true ? concat(local.pre_built.lldp_interface, lookup(
    local.interface, "lldp_interface", [])) : lookup(local.interface, "lldp_interface", []
  )
  mcp_policies = local.pre_cfg.mcp_interface == true ? concat(local.pre_built.mcp_interface, lookup(
    local.interface, "mcp_interface", [])) : lookup(local.interface, "mcp_interface", []
  )
  pc_policies = local.pre_cfg.port_channel == true ? concat(local.pre_built.port_channel, lookup(
    local.interface, "port_channel", [])) : lookup(local.interface, "port_channel", []
  )
  ps_policies = local.pre_cfg.port_security == true ? concat(local.pre_built.port_security, lookup(
    local.interface, "port_security", [])) : lookup(local.interface, "port_security", []
  )
  stp_policies = local.pre_cfg.spanning_tree_interface == true ? concat(
    local.pre_built.spanning_tree_interface, lookup(local.interface, "spanning_tree_interface", [])
    ) : lookup(local.interface, "spanning_tree_interface", []
  )
  #__________________________________________________________
  #
  # Interface Policies Variables
  #__________________________________________________________

  #=========================
  # CDP Interface
  #=========================

  cdp_interface = {
    for k, v in local.cdp_policies : v.name => {
      admin_state  = lookup(v, "admin_state", local.cdp.admin_state)
      annotation   = coalesce(lookup(v, "annotation", local.cdp.annotation), var.annotation)
      description  = lookup(v, "description", local.cdp.description)
      global_alias = lookup(v, "global_alias", local.cdp.global_alias)
    }
  }

  #=========================
  # Fibre-Channel Interface
  #=========================

  fibre_channel_interface = {
    for k, v in local.fc_policies : v.name => {
      auto_max_speed        = lookup(v, "auto_max_speed", local.fc.auto_max_speed)
      annotation            = coalesce(lookup(v, "annotation", local.fc.annotation), var.annotation)
      description           = lookup(v, "description", local.fc.description)
      fill_pattern          = lookup(v, "fill_pattern", local.fc.fill_pattern)
      port_mode             = lookup(v, "port_mode", local.fc.port_mode)
      receive_buffer_credit = lookup(v, "receive_buffer_credit", local.fc.receive_buffer_credit)
      speed                 = lookup(v, "speed", local.fc.speed)
      trunk_mode            = lookup(v, "trunk_mode", local.fc.trunk_mode)
    }
  }

  #=========================
  # L2 Interface
  #=========================

  l2_interface = {
    for k, v in local.l2_policies : v.name => {
      annotation       = coalesce(lookup(v, "annotation", local.l2.annotation), var.annotation)
      description      = lookup(v, "description", local.l2.description)
      qinq             = lookup(v, "qinq", local.l2.qinq)
      reflective_relay = lookup(v, "reflective_relay", local.l2.reflective_relay)
      vlan_scope       = lookup(v, "vlan_scope", local.l2.vlan_scope)
    }
  }

  #=========================
  # Link-Level
  #=========================

  link_level = {
    for k, v in local.ll_policies : v.name => {
      annotation                  = coalesce(lookup(v, "annotation", local.ll.annotation), var.annotation)
      auto_negotiation            = lookup(v, "auto_negotiation", local.ll.auto_negotiation)
      description                 = lookup(v, "description", local.ll.description)
      global_alias                = lookup(v, "global_alias", local.ll.global_alias)
      forwarding_error_correction = lookup(v, "forwarding_error_correction", local.ll.forwarding_error_correction)
      link_debounce_interval      = lookup(v, "link_debounce_interval", local.ll.link_debounce_interval)
      speed                       = lookup(v, "speed", local.ll.speed)
    }
  }

  #=========================
  # LLDP Interface
  #=========================

  lldp_interface = {
    for k, v in local.lldp_policies : v.name => {
      annotation     = coalesce(lookup(v, "annotation", local.lldp.annotation), var.annotation)
      description    = lookup(v, "description", local.lldp.description)
      global_alias   = lookup(v, "global_alias", local.lldp.global_alias)
      receive_state  = lookup(v, "receive_state", local.lldp.receive_state)
      transmit_state = lookup(v, "transmit_state", local.lldp.transmit_state)
    }
  }

  #=========================
  # MCP Interface
  #=========================

  mcp_interface = {
    for k, v in local.mcp_policies : v.name => {
      admin_state = lookup(v, "admin_state", local.mcp.admin_state)
      annotation  = coalesce(lookup(v, "annotation", local.mcp.annotation), var.annotation)
      description = lookup(v, "description", local.mcp.description)
    }
  }

  #=========================
  # Port-Channel
  #=========================

  port_channel = {
    for k, v in local.pc_policies : v.name => {
      annotation  = coalesce(lookup(v, "annotation", local.pc.annotation), var.annotation)
      description = lookup(v, "description", local.pc.description)
      control = {
        fast_select_hot_standby_ports = lookup(lookup(
          v, "control", {}), "fast_select_hot_standby_ports", local.pc.control.fast_select_hot_standby_ports
        )
        graceful_convergence = lookup(lookup(
          v, "control", {}), "graceful_convergence", local.pc.control.graceful_convergence
        )
        load_defer_member_ports = lookup(lookup(
          v, "control", {}), "load_defer_member_ports", local.pc.control.load_defer_member_ports
        )
        suspend_individual_port = lookup(lookup(
          v, "control", {}), "suspend_individual_port", local.pc.control.suspend_individual_port
        )
        symmetric_hashing = lookup(lookup(
          v, "control", {}), "symmetric_hashing", local.pc.control.symmetric_hashing
        )
      }
      global_alias            = lookup(v, "global_alias", local.pc.global_alias)
      maximum_number_of_links = lookup(v, "maximum_number_of_links", local.pc.maximum_number_of_links)
      minimum_number_of_links = lookup(v, "minimum_number_of_links", local.pc.minimum_number_of_links)
      mode                    = lookup(v, "mode", local.pc.mode)
    }
  }

  #=========================
  # Port Security
  #=========================

  port_security = {
    for k, v in local.ps_policies : v.name => {
      annotation            = coalesce(lookup(v, "annotation", local.ps.annotation), var.annotation)
      description           = lookup(v, "description", local.ps.description)
      maximum_endpoints     = lookup(v, "maximum_endpoints", local.ps.maximum_endpoints)
      port_security_timeout = lookup(v, "port_security_timeout", local.ps.port_security_timeout)
    }
  }

  #=========================
  # Spanning-Tree Interface
  #=========================

  spanning_tree_interface = {
    for k, v in local.stp_policies : v.name => {
      annotation   = coalesce(lookup(v, "annotation", local.stp.annotation), var.annotation)
      bpdu_guard   = lookup(v, "bpdu_guard", local.stp.bpdu_guard)
      bpdu_filter  = lookup(v, "bpdu_filter", local.stp.bpdu_filter)
      description  = lookup(v, "description", local.stp.description)
      global_alias = lookup(v, "global_alias", local.stp.global_alias)
    }
  }


  #__________________________________________________________
  #
  # Leaf Interface Policy Group Variables
  #__________________________________________________________

  leaf_interfaces_policy_groups_access = {
    for k, v in lookup(local.intf_pg_leaf, "access", {}) : v.name => {
      attachable_entity_profile = lookup(v, "attachable_entity_profile", local.laccess.attachable_entity_profile)
      annotation = coalesce(lookup(v, "annotation", local.laccess.annotation
      ), var.annotation)
      cdp_interface_policy        = lookup(v, "cdp_interface_policy", local.laccess.cdp_interface_policy)
      copp_interface_policy       = lookup(v, "copp_interface_policy", local.laccess.copp_interface_policy)
      data_plane_policing_egress  = lookup(v, "data_plane_policing_egress", local.laccess.data_plane_policing_egress)
      data_plane_policing_ingress = lookup(v, "data_plane_policing_ingress", local.laccess.data_plane_policing_ingress)
      description                 = lookup(v, "description", local.laccess.description)
      dot1x_port_authentication_policy = lookup(
        v, "dot1x_port_authentication_policy", local.laccess.dot1x_port_authentication_policy
      )
      dwdm_policy = lookup(v, "dwdm_policy", local.laccess.dwdm_policy)
      fibre_channel_interface_policy = lookup(
        v, "fibre_channel_interface_policy", local.laccess.fibre_channel_interface_policy
      )
      global_alias        = lookup(v, "global_alias", local.laccess.global_alias)
      l2_interface_policy = lookup(v, "l2_interface_policy", local.laccess.l2_interface_policy)
      link_flap_policy    = lookup(v, "link_flap_policy", local.laccess.link_flap_policy)
      link_level_flow_control_policy = lookup(
        v, "link_level_flow_control_policy", local.laccess.link_level_flow_control_policy
      )
      link_level_policy     = lookup(v, "link_level_policy", local.laccess.link_level_policy)
      lldp_interface_policy = lookup(v, "lldp_interface_policy", local.laccess.lldp_interface_policy)
      macsec_policy         = lookup(v, "macsec_policy", local.laccess.macsec_policy)
      mcp_interface_policy  = lookup(v, "mcp_interface_policy", local.laccess.mcp_interface_policy)
      monitoring_policy     = lookup(v, "monitoring_policy", local.laccess.monitoring_policy)
      netflow_monitor_policies = [
        for s in lookup(v, "netflow_monitor_policies", []) : {
          ip_filter_type         = lookup(s, "ip_filter_type", local.laccess.ip_filter_type)
          netflow_monitor_policy = s.netflow_monitor_policy
        }
      ]
      poe_interface_policy = lookup(v, "poe_interface_policy", local.laccess.poe_interface_policy)
      port_security_policy = lookup(v, "port_security_policy", local.laccess.port_security_policy)
      priority_flow_control_policy = lookup(
        v, "priority_flow_control_policy", local.laccess.priority_flow_control_policy
      )
      slow_drain_policy       = lookup(v, "slow_drain_policy", local.laccess.slow_drain_policy)
      span_destination_groups = lookup(v, "span_destination_groups       ", [])
      span_source_groups      = lookup(v, "span_source_groups            ", [])
      spanning_tree_interface_policy = lookup(
        v, "spanning_tree_interface_policy", local.laccess.spanning_tree_interface_policy
      )
      storm_control_policy   = lookup(v, "storm_control_policy", local.laccess.storm_control_policy)
      synce_interface_policy = lookup(v, "synce_interface_policy", local.laccess.synce_interface_policy)
    }
  }

  leaf_interfaces_policy_groups_breakout = {
    for k, v in lookup(local.intf_pg_leaf, "breakout", {}) : v.name => {
      annotation = coalesce(lookup(v, "annotation", local.lbrkout.annotation
      ), var.annotation)
      breakout_map = lookup(v, "breakout_map", local.lbrkout.breakout_map)
      description  = lookup(v, "description", local.lbrkout.description)
    }
  }


  leaf_interfaces_policy_groups_bundle = {
    for i in flatten([
      for v in lookup(local.intf_pg_leaf, "bundle", []) : [
        for s in v.names : {
          attachable_entity_profile = lookup(v, "attachable_entity_profile", local.lbundle.attachable_entity_profile)
          annotation = coalesce(lookup(v, "annotation", local.lbundle.annotation
          ), var.annotation)
          cdp_interface_policy  = lookup(v, "cdp_interface_policy", local.lbundle.cdp_interface_policy)
          copp_interface_policy = lookup(v, "copp_interface_policy", local.lbundle.copp_interface_policy)
          data_plane_policing_egress = lookup(
            v, "data_plane_policing_egress", local.lbundle.data_plane_policing_egress
          )
          data_plane_policing_ingress = lookup(
            v, "data_plane_policing_ingress", local.lbundle.data_plane_policing_ingress
          )
          description = lookup(v, "description", local.lbundle.description)
          fibre_channel_interface_policy = lookup(
            v, "fibre_channel_interface_policy", local.lbundle.fibre_channel_interface_policy
          )
          l2_interface_policy     = lookup(v, "l2_interface_policy", local.lbundle.l2_interface_policy)
          link_aggregation_policy = lookup(v, "link_aggregation_policy", local.lbundle.link_aggregation_policy)
          link_aggregation_type   = lookup(v, "link_aggregation_type", local.lbundle.link_aggregation_type)
          link_flap_policy        = lookup(v, "link_flap_policy", local.lbundle.link_flap_policy)
          link_level_flow_control_policy = lookup(
            v, "link_level_flow_control_policy", local.lbundle.link_level_flow_control_policy
          )
          link_level_policy     = lookup(v, "link_level_policy", local.lbundle.link_level_policy)
          lldp_interface_policy = lookup(v, "lldp_interface_policy", local.lbundle.lldp_interface_policy)
          macsec_policy         = lookup(v, "macsec_policy", local.lbundle.macsec_policy)
          mcp_interface_policy  = lookup(v, "mcp_interface_policy", local.lbundle.mcp_interface_policy)
          monitoring_policy     = lookup(v, "monitoring_policy", local.lbundle.monitoring_policy)
          name                  = s
          netflow_monitor_policies = [
            for s in lookup(v, "netflow_monitor_policies", []) : {
              ip_filter_type         = lookup(s, "ip_filter_type", local.laccess.ip_filter_type)
              netflow_monitor_policy = s.netflow_monitor_policy
            }
          ]
          port_security_policy = lookup(v, "port_security_policy", local.lbundle.port_security_policy)
          priority_flow_control_policy = lookup(
            v, "priority_flow_control_policy", local.lbundle.priority_flow_control_policy
          )
          slow_drain_policy       = lookup(v, "slow_drain_policy", local.lbundle.slow_drain_policy)
          span_destination_groups = lookup(v, "span_destination_groups", [])
          span_source_groups      = lookup(v, "span_source_groups", [])
          spanning_tree_interface_policy = lookup(
            v, "spanning_tree_interface_policy", local.lbundle.spanning_tree_interface_policy
          )
          storm_control_policy = lookup(v, "storm_control_policy", local.lbundle.storm_control_policy)
        }
      ]
    ]) : i.name => i
  }


  #__________________________________________________________
  #
  # Switches - Leaf Policy Group Variables
  #__________________________________________________________

  switches_leaf_policy_groups = {
    for k, v in lookup(local.sw_pgs_leaf, "policy_groups", {}) : v.name => {
      annotation = coalesce(lookup(v, "annotation", local.swpgl.annotation
      ), var.annotation)
      bfd_ipv4_policy          = lookup(v, "bfd_ipv4_policy", local.swpgl.bfd_ipv4_policy)
      bfd_ipv6_policy          = lookup(v, "bfd_ipv6_policy", local.swpgl.bfd_ipv6_policy)
      bfd_multihop_ipv4_policy = lookup(v, "bfd_multihop_ipv4_policy", local.swpgl.bfd_multihop_ipv4_policy)
      bfd_multihop_ipv6_policy = lookup(v, "bfd_multihop_ipv6_policy", local.swpgl.bfd_multihop_ipv6_policy)
      cdp_interface_policy     = lookup(v, "cdp_interface_policy", local.swpgl.cdp_interface_policy)
      copp_leaf_policy         = lookup(v, "copp_leaf_policy", local.swpgl.copp_leaf_policy)
      copp_pre_filter          = lookup(v, "copp_pre_filter", local.swpgl.copp_pre_filter)
      description              = lookup(v, "description", local.swpgl.description)
      dot1x_node_authentication_policy = lookup(
        v, "dot1x_node_authentication_policy", local.swpgl.dot1x_node_authentication_policy
      )
      equipment_flash_config       = lookup(v, "equipment_flash_config", local.swpgl.equipment_flash_config)
      fast_link_failover_policy    = lookup(v, "fast_link_failover_policy", local.swpgl.fast_link_failover_policy)
      fibre_channel_node_policy    = lookup(v, "fibre_channel_node_policy", local.swpgl.fibre_channel_node_policy)
      fibre_channel_san_policy     = lookup(v, "fibre_channel_san_policy", local.swpgl.fibre_channel_san_policy)
      forward_scale_profile_policy = lookup(v, "forward_scale_profile_policy", local.swpgl.forward_scale_profile_policy)
      lldp_interface_policy        = lookup(v, "lldp_interface_policy", local.swpgl.lldp_interface_policy)
      monitoring_policy            = lookup(v, "monitoring_policy", local.swpgl.monitoring_policy)
      netflow_node_policy          = lookup(v, "netflow_node_policy", local.swpgl.netflow_node_policy)
      poe_node_policy              = lookup(v, "poe_node_policy", local.swpgl.poe_node_policy)
      ptp_node_policy              = lookup(v, "ptp_node_policy", local.swpgl.ptp_node_policy)
      spanning_tree_interface_policy = lookup(
        v, "spanning_tree_interface_policy", local.swpgl.spanning_tree_interface_policy
      )
      synce_node_policy        = lookup(v, "synce_node_policy", local.swpgl.synce_node_policy)
      usb_configuration_policy = lookup(v, "usb_configuration_policy", local.swpgl.usb_configuration_policy)
    }
  }


  #__________________________________________________________
  #
  # Spine Interface Policy Group Variables
  #__________________________________________________________

  spine_interface_policy_groups = {
    for k, v in lookup(local.intf_pg_spine, "bundle", {}) : v.name => {
      attachable_entity_profile = lookup(v, "attachable_entity_profile", local.saccess.attachable_entity_profile)
      annotation = coalesce(lookup(v, "annotation", local.saccess.annotation
      ), var.annotation)
      cdp_interface_policy = lookup(v, "cdp_interface_policy", local.saccess.cdp_interface_policy)
      description          = lookup(v, "description", local.saccess.description)
      global_alias         = lookup(v, "global_alias", local.saccess.global_alias)
      link_level_policy    = lookup(v, "link_level_policy", local.saccess.link_level_policy)
      macsec_policy        = lookup(v, "macsec_policy", local.saccess.macsec_policy)
    }
  }

  #__________________________________________________________
  #
  # Switches - Spine Policy Group Variables
  #__________________________________________________________

  switches_spine_policy_groups = {
    for k, v in lookup(local.sw_pgs_spine, "policy_groups", {}) : v.name => {
      annotation = coalesce(lookup(v, "annotation", local.swpgs.annotation
      ), var.annotation)
      bfd_ipv4_policy          = lookup(v, "bfd_ipv4_policy", local.swpgs.bfd_ipv4_policy)
      bfd_ipv6_policy          = lookup(v, "bfd_ipv6_policy", local.swpgs.bfd_ipv6_policy)
      cdp_interface_policy     = lookup(v, "cdp_interface_policy", local.swpgs.cdp_interface_policy)
      copp_pre_filter          = lookup(v, "copp_pre_filter", local.swpgs.copp_pre_filter)
      copp_spine_policy        = lookup(v, "copp_spine_policy", local.swpgs.copp_spine_policy)
      description              = lookup(v, "description", local.swpgs.description)
      lldp_interface_policy    = lookup(v, "lldp_interface_policy", local.swpgs.lldp_interface_policy)
      usb_configuration_policy = lookup(v, "usb_configuration_policy", local.swpgs.usb_configuration_policy)
    }
  }


  #__________________________________________________________
  #
  # VLAN Pools Variables
  #__________________________________________________________

  # This first loop is to handle optional attributes and return 
  # default values if the user doesn't enter a value.
  vlan_pools = {
    for k, v in lookup(local.pools, "vlan", {}) : v.name => {
      allocation_mode = lookup(v, "allocation_mode", local.vlan.allocation_mode)
      annotation = coalesce(lookup(v, "annotation", local.vlan.annotation)
      , var.annotation)
      description  = lookup(v, "description", local.vlan.description)
      encap_blocks = lookup(v, "encap_blocks", [])
      name         = v.name
    }
  }

  /*
  Loop 1 is to determine if the vlan_range is:
  * A Single number 1
  * A Range of numbers 1-5
  * A List of numbers 1-5,10-15
  And then to return these values as a list
  */
  vlan_ranges_loop_1 = flatten([
    for key, value in local.vlan_pools : [
      for v in value.encap_blocks : {
        allocation_mode = lookup(v, "allocation_mode", local.vlan.encap_blocks.allocation_mode)
        annotation      = value.annotation
        description     = lookup(v, "description", local.vlan.encap_blocks.description)
        role            = lookup(v, "role", local.vlan.encap_blocks.role)
        vlan_list       = tolist(split(",", v.vlan_range))
        vlan_pool       = key
      }
    ]
  ])

  vlan_ranges = {
    for i in flatten([
      for v in local.vlan_ranges_loop_1 : [
        for s in v.vlan_list : {
          allocation_mode = v.allocation_mode
          annotation      = v.annotation
          description     = v.description
          from            = length(regexall("-", s)) > 0 ? element(split("-", s), 0) : s
          role            = v.role
          to              = length(regexall("-", s)) > 0 ? element(split("-", s), 1) : s
          vlan_pool       = v.vlan_pool
        }
      ]
    ]) : "${i.vlan_pool}:${i.from}-${i.to}" => i
  }


  #__________________________________________________________
  #
  # Virtual Networking Variables
  #__________________________________________________________

  vmm_domains = {
    for i in flatten([
      for value in lookup(var.model, "virtual_networking", []) : [
        for v in value.domain : {
          access_mode = lookup(v, "access_mode", local.vmm.domain.access_mode)
          annotation = coalesce(lookup(v, "annotation", local.vmm.domain.annotation
          ), var.annotation)
          control_knob          = lookup(v, "control_knob", local.vmm.domain.control_knob)
          delimiter             = lookup(v, "delimiter", local.vmm.domain.delimiter)
          dvs                   = value.virtual_switch_name
          enable_tag_collection = lookup(v, "enable_tag_collection", local.vmm.domain.enable_tag_collection)
          enable_vm_folder_data_retrieval = lookup(
            v, "enable_vm_folder_data_retrieval", local.vmm.domain.enable_vm_folder_data_retrieval
          )
          encapsulation           = lookup(v, "encapsulation", local.vmm.domain.encapsulation)
          endpoint_inventory_type = lookup(v, "endpoint_inventory_type", local.vmm.domain.endpoint_inventory_type)
          endpoint_retention_time = lookup(v, "endpoint_retention_time", local.vmm.domain.endpoint_retention_time)
          enforcement             = lookup(v, "enforcement", local.vmm.domain.enforcement)
          numOfUplinks            = length(lookup(v, "uplink_names", ["uplink1", "uplink2"]))
          preferred_encapsulation = lookup(v, "preferred_encapsulation", local.vmm.domain.preferred_encapsulation)
          switch_provider         = lookup(v, "switch_provider", local.vmm.domain.switch_provider)
          switch_mode             = lookup(v, "switch_mode", local.vmm.domain.switch_mode)
          uplink_names            = length(lookup(v, "uplink_names", local.vmm.domain.uplink_names)) > 0 ? v.uplink_names : ["uplink1", "uplink2"]
          vlan_pool               = v.vlan_pool
        }
      ]
    ]) : i.dvs => i
  }
  vmm_credentials = {
    for i in flatten([
      for value in lookup(var.model, "virtual_networking", []) : [
        for k, v in value.credentials : {
          annotation  = local.vmm_domains["${value.virtual_switch_name}"].annotation
          dvs         = value.virtual_switch_name
          description = lookup(v, "description", local.vmm.credentials.description)
          password    = v.password
          username    = v.username
        }
      ]
    ]) : i.dvs => i
  }
  vmm_controllers = {
    for i in flatten([
      for value in lookup(var.model, "virtual_networking", []) : [
        for v in value.controllers : {
          annotation = coalesce(lookup(v, "annotation", local.vmm.controllers.annotation
          ), var.annotation)
          datacenter     = lookup(v, "datacenter", local.vmm.controllers.datacenter)
          dvs            = value.virtual_switch_name
          dvs_version    = lookup(v, "dvs_version", local.vmm.controllers.dvs_version)
          hostname       = lookup(v, "hostname", local.vmm.controllers.hostname)
          management_epg = lookup(v, "management_epg", local.vmm.controllers.management_epg)
          mgmt_epg_type = var.management_epgs[index(var.management_epgs.*.name,
            lookup(v, "management_epg", local.vmm.controllers.management_epg))
          ].type
          monitoring_policy = lookup(v, "monitoring_policy", local.vmm.controllers.monitoring_policy)
          port              = lookup(v, "port", local.vmm.controllers.port)
          sequence_number   = lookup(v, "sequence_number", local.vmm.controllers.sequence_number)
          stats_collection  = lookup(v, "stats_collection", local.vmm.controllers.stats_collection)
          switch_mode       = lookup(value, "switch_mode", local.vmm.domain.switch_mode)
          switch_scope      = lookup(v, "switch_scope", local.vmm.controllers.switch_scope)
          trigger_inventory_sync = lookup(
            v, "trigger_inventory_sync", local.vmm.controllers.trigger_inventory_sync
          )
          vxlan_pool = lookup(v, "vxlan_pool", local.vmm.controllers.vxlan_pool)
        }
      ]
    ]) : "${i.dvs}:${i.hostname}" => i
  }
  vswitch_policies = {
    for i in flatten([
      for key, value in lookup(var.model, "virtual_networking", []) : [
        for k, v in value.vswitch_policy : {
          annotation = coalesce(lookup(v, "annotation", local.vmm.vswitch_policy.annotation
          ), var.annotation)
          cdp_interface_policy = lookup(v, "cdp_interface_policy", "")
          dvs                  = value.virtual_switch_name
          enhanced_lag_policy = length(compact(
            [lookup(lookup(v, "enhanced_lag_policy", {}), "name", "")])
            ) > 0 ? {
            load_balancing_mode = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "load_balancing_mode", local.vmm.vswitch_policy.load_balancing_mode)
            mode = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "mode", local.vmm.vswitch_policy.mode)
            name = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "name", local.vmm.vswitch_policy.name)
            number_of_links = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "number_of_links", local.vmm.vswitch_policy.number_of_links)
          } : {}
          firewall_policy       = lookup(v, "firewall_policy", "default")
          lldp_interface_policy = lookup(v, "lldp_interface_policy", "")
          mtu_policy            = lookup(v, "mtu_policy", "default")
          netflow_export_policy = length(compact([lookup(v, "netflow_export_policy", "")])) > 0 ? [
            for s in v.vmm_netflow_export_policies : {
              active_flow_timeout = lookup(s, "active_flow_timeout", local.vmm_netflow.active_flow_timeout)
              idle_flow_timeout   = lookup(s, "idle_flow_timeout", local.vmm_netflow.idle_flow_timeout)
              netflow_policy      = s.netflow_policy
              sample_rate         = lookup(s, "sample_rate", local.vmm_netflow.sample_rate)
            }
          ] : []
          port_channel_policy = lookup(v, "port_channel_policy", "")
        }
      ]
    ]) : i.dvs => i
  }
  vmm_uplinks = { for i in flatten([
    for k, v in local.vmm_domains : [
      for s in range(length(v.uplink_names)) : {
        access_mode     = v.access_mode
        dvs             = k
        switch_provider = v.switch_provider
        uplinkId        = s
        uplinkName      = element(v.uplink_names, s)
      }
    ]
    ]) : "${i.dvs}:${i.uplinkName}" => i if i.access_mode == "read-write"
  }
}
