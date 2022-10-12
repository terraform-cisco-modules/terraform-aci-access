locals {
  #__________________________________________________________
  #
  # Model Inputs
  #__________________________________________________________

  access    = lookup(var.model, "access", {})
  defaults  = lookup(var.model, "defaults", {})
  domains   = lookup(local.access, "physical_and_external_domains", {})
  global    = lookup(lookup(local.access, "policies", {}), "global", {})
  interface = lookup(lookup(local.access, "policies", {}), "interface", {})
  intf_pg_leaf = lookup(lookup(lookup(local.access, "interfaces", {}
  ), "leaf", {}), "policy_groups")
  intf_pg_spine = lookup(lookup(local.access, "interfaces", {}), "spine", {})
  pools         = lookup(local.access, "pools", {})
  sw_pgs_leaf   = lookup(lookup(local.access, "switches", {}), "leaf")
  sw_pgs_spine  = lookup(lookup(local.access, "switches", {}), "spine")

  #  #__________________________________________________________
  #  #
  #  # Domain Variables
  #  #__________________________________________________________
  #
  #  domains_layer3 = {
  #    for k, v in var.domains_layer3 : k => {
  #      annotation = v.annotation != null ? v.annotation : ""
  #      vlan_pool  = v.vlan_pool
  #    }
  #  }
  #
  #  domains_physical = {
  #    for k, v in var.domains_physical : k => {
  #      annotation = v.annotation != null ? v.annotation : ""
  #      vlan_pool  = v.vlan_pool
  #    }
  #  }
  #
  #  #__________________________________________________________
  #  #
  #  # Global Policies Variables
  #  #__________________________________________________________
  #
  #  #===================================
  #  # Attachable Access Entity Profiles
  #  #===================================
  #
  #  attachable_access_entity_profiles_1 = {
  #    for k, v in var.global_attachable_access_entity_profiles : k => {
  #      annotation       = v.annotation != null ? v.annotation : ""
  #      description      = v.description != null ? v.description : ""
  #      l3_domains       = v.l3_domains != null ? v.l3_domains : []
  #      physical_domains = v.physical_domains != null ? v.physical_domains : []
  #      vmm_domains      = v.vmm_domains != null ? v.vmm_domains : []
  #    }
  #  }
  #
  #  attachable_access_entity_profiles_2 = {
  #    for k, v in local.attachable_access_entity_profiles_1 : k => {
  #      annotation  = v.annotation
  #      description = v.description
  #      l3_domains = length(v.l3_domains
  #      ) > 0 ? [for s in v.l3_domains : aci_l3_domain_profile.domains_layer3["${s}"].id] : []
  #      physical_domains = length(v.physical_domains
  #      ) > 0 ? [for s in v.physical_domains : aci_physical_domain.domains_physical["${s}"].id] : []
  #      vmm_domains = length(v.vmm_domains
  #      ) > 0 ? [for s in v.vmm_domains : aci_vmm_domain.domains_vmm["${s}"].id] : []
  #    }
  #  }
  #
  #  global_attachable_access_entity_profiles = {
  #    for k, v in local.attachable_access_entity_profiles_2 : k => {
  #      annotation  = v.annotation
  #      description = v.description
  #      domains     = compact(concat(v.l3_domains, v.physical_domains, v.vmm_domains))
  #    }
  #  }
  #
  #
  #  #===================================
  #  # Global - DHCP Relay 
  #  #===================================
  #
  #  global_dhcp_relay = {
  #    for k, v in var.global_dhcp_relay : k => {
  #      annotation  = v.annotation != null ? v.annotation : ""
  #      description = v.description != null ? v.description : ""
  #      dhcp_relay_providers = v.dhcp_relay_providers != null ? { for key, value in v.dhcp_relay_providers : key =>
  #        {
  #          address             = value.address
  #          application_profile = value.application_profile != null ? value.application_profile : "default"
  #          epg                 = value.epg != null ? value.epg : "default"
  #          epg_type            = value.epg_type != null ? value.epg_type : "application_epg"
  #          l3out               = value.l3out != null ? value.l3out : ""
  #          tenant              = value.tenant != null ? value.tenant : "common"
  #        }
  #      } : {}
  #      mode = v.mode != null ? v.mode : "visible"
  #    }
  #  }
  #
  #
  #  #===================================
  #  # Error Disable Recovery Policy
  #  #===================================
  #
  #  global_error_disabled_recovery_policy = {
  #    for key, value in var.global_error_disabled_recovery_policy : key => {
  #      annotation                      = value.annotation != null ? value.annotation : ""
  #      description                     = value.description != null ? value.description : ""
  #      error_disable_recovery_interval = value.error_disable_recovery_interval != null ? value.error_disable_recovery_interval : 300
  #      events = value.events != null ? [
  #        for v in value.events : {
  #          bpdu_guard             = v.bpdu_guard != null ? v.bpdu_guard : true
  #          frequent_endpoint_move = v.frequent_endpoint_move != null ? v.frequent_endpoint_move : true
  #          loop_indication_by_mcp = v.loop_indication_by_mcp != null ? v.loop_indication_by_mcp : true
  #        }
  #        ] : [
  #        {
  #          bpdu_guard             = true
  #          frequent_endpoint_move = true
  #          loop_indication_by_mcp = true
  #        }
  #      ]
  #    }
  #  }
  #
  #
  #  #===================================
  #  # MCP Instance Policy
  #  #===================================
  #
  #  global_mcp_instance_policy = {
  #    for k, v in var.global_mcp_instance_policy : k => {
  #      admin_state                       = v.admin_state != null ? v.admin_state : "enabled"
  #      annotation                        = v.annotation != null ? v.annotation : ""
  #      description                       = v.description != null ? v.description : ""
  #      annotation                        = v.annotation != null ? v.annotation : ""
  #      enable_mcp_pdu_per_vlan           = v.enable_mcp_pdu_per_vlan != null ? v.enable_mcp_pdu_per_vlan : true
  #      initial_delay                     = v.initial_delay != null ? v.initial_delay : 180
  #      loop_detect_multiplication_factor = v.loop_detect_multiplication_factor != null ? v.loop_detect_multiplication_factor : 3
  #      loop_protection_disable_port      = v.loop_protection_disable_port != null ? v.loop_protection_disable_port : true
  #      transmission_frequency = v.transmission_frequency != null ? [
  #        for s in v.transmission_frequency : {
  #          seconds = s.seconds != null ? s.seconds : 2
  #          msec    = s.msec != null ? s.msec : 0
  #        }
  #        ] : [
  #        {
  #          seconds = 2
  #          msec    = 0
  #        }
  #      ]
  #    }
  #  }
  #
  #
  #  #===================================
  #  # Global QoS Class
  #  #===================================
  #
  #  global_qos_class = {
  #    for k, v in var.global_qos_class : k => {
  #      annotation                        = v.annotation != null ? v.annotation : ""
  #      control                           = v.preserve_cos == false ? ["none"] : ["dot1p-preserve"]
  #      description                       = v.description != null ? v.description : ""
  #      elephant_trap_age_period          = v.elephant_trap_age_period != null ? v.elephant_trap_age_period : 0
  #      elephant_trap_bandwidth_threshold = v.elephant_trap_bandwidth_threshold != null ? v.elephant_trap_bandwidth_threshold : 0
  #      elephant_trap_byte_count          = v.elephant_trap_byte_count != null ? v.elephant_trap_byte_count : 0
  #      elephant_trap_state               = v.elephant_trap_state != null ? v.elephant_trap_state : false
  #      fabric_flush_interval             = v.fabric_flush_interval != null ? v.fabric_flush_interval : 500
  #      fabric_flush_state                = v.fabric_flush_state != null ? v.fabric_flush_state : false
  #      micro_burst_spine_queues          = v.micro_burst_spine_queues != null ? v.micro_burst_spine_queues : 0
  #      micro_burst_leaf_queues           = v.micro_burst_leaf_queues != null ? v.micro_burst_leaf_queues : 0
  #      preserve_cos                      = v.preserve_cos != null ? v.preserve_cos : true
  #    }
  #  }
  #
  #
  #  #__________________________________________________________
  #  #
  #  # Interface Policies Variables
  #  #__________________________________________________________
  #
  #  #=========================
  #  # CDP Interface
  #  #=========================
  #
  #  policies_cdp_interface = {
  #    for k, v in var.policies_cdp_interface : k => {
  #      admin_state  = v.admin_state != null ? v.admin_state : "enabled"
  #      annotation   = v.annotation != null ? v.annotation : ""
  #      description  = v.description != null ? v.description : ""
  #      global_alias = v.global_alias != null ? v.global_alias : ""
  #    }
  #  }
  #
  #  policies_cdp_interface_global_alias = {
  #    for k, v in local.policies_cdp_interface : k => {
  #      global_alias = v.global_alias
  #    } if v.global_alias != ""
  #  }
  #
  #  #=========================
  #  # Fibre-Channel Interface
  #  #=========================
  #
  #  policies_fibre_channel_interface = {
  #    for k, v in var.policies_fibre_channel_interface : k => {
  #      auto_max_speed        = v.auto_max_speed != null ? v.auto_max_speed : "32G"
  #      annotation            = v.annotation != null ? v.annotation : ""
  #      description           = v.description != null ? v.description : ""
  #      fill_pattern          = v.fill_pattern != null ? v.fill_pattern : "ARBFF"
  #      port_mode             = v.port_mode != null ? v.port_mode : "f"
  #      receive_buffer_credit = v.receive_buffer_credit != null ? v.receive_buffer_credit : 64
  #      speed                 = v.speed != null ? v.speed : "auto"
  #      trunk_mode            = v.trunk_mode != null ? v.trunk_mode : "trunk-off"
  #    }
  #  }
  #
  #  #=========================
  #  # L2 Interface
  #  #=========================
  #
  #  policies_l2_interface = {
  #    for k, v in var.policies_l2_interface : k => {
  #      annotation       = v.annotation != null ? v.annotation : ""
  #      description      = v.description != null ? v.description : ""
  #      qinq             = v.qinq != null ? v.qinq : "disabled"
  #      reflective_relay = v.reflective_relay != null ? v.reflective_relay : "disabled"
  #      vlan_scope       = v.vlan_scope != null ? v.vlan_scope : "global"
  #    }
  #  }
  #
  #  #=========================
  #  # Link-Level
  #  #=========================
  #
  #  policies_link_level = {
  #    for k, v in var.policies_link_level : k => {
  #      annotation                  = v.annotation != null ? v.annotation : ""
  #      auto_negotiation            = v.auto_negotiation != null ? v.auto_negotiation : "on"
  #      description                 = v.description != null ? v.description : ""
  #      global_alias                = v.global_alias != null ? v.global_alias : ""
  #      forwarding_error_correction = v.forwarding_error_correction != null ? v.forwarding_error_correction : "inherit"
  #      link_debounce_interval      = v.link_debounce_interval != null ? v.link_debounce_interval : 100
  #      speed                       = v.speed != null ? v.speed : "inherit"
  #    }
  #  }
  #
  #  policies_link_level_global_alias = {
  #    for k, v in local.policies_link_level : k => {
  #      global_alias = v.global_alias
  #    } if v.global_alias != ""
  #  }
  #
  #  #=========================
  #  # LLDP Interface
  #  #=========================
  #
  #  policies_lldp_interface = {
  #    for k, v in var.policies_lldp_interface : k => {
  #      annotation     = v.annotation != null ? v.annotation : ""
  #      description    = v.description != null ? v.description : ""
  #      global_alias   = v.global_alias != null ? v.global_alias : ""
  #      receive_state  = v.receive_state != null ? v.receive_state : "enabled"
  #      transmit_state = v.transmit_state != null ? v.transmit_state : "enabled"
  #    }
  #  }
  #
  #  policies_lldp_interface_global_alias = {
  #    for k, v in local.policies_lldp_interface : k => {
  #      global_alias = v.global_alias
  #    } if v.global_alias != ""
  #  }
  #
  #  #=========================
  #  # MCP Interface
  #  #=========================
  #
  #  policies_mcp_interface = {
  #    for k, v in var.policies_mcp_interface : k => {
  #      admin_state = v.admin_state != null ? v.admin_state : "enabled"
  #      annotation  = v.annotation != null ? v.annotation : ""
  #      description = v.description != null ? v.description : ""
  #    }
  #  }
  #
  #  #=========================
  #  # Port-Channel
  #  #=========================
  #
  #  policies_port_channel = {
  #    for k, v in var.policies_port_channel : k => {
  #      annotation  = v.annotation != null ? v.annotation : ""
  #      description = v.description != null ? v.description : ""
  #      control = v.control != null ? [
  #        for a in v.control : {
  #          fast_select_hot_standby_ports = a.fast_select_hot_standby_ports != null ? a.fast_select_hot_standby_ports : true
  #          graceful_convergence          = a.graceful_convergence != null ? a.graceful_convergence : true
  #          load_defer_member_ports       = a.load_defer_member_ports != null ? a.load_defer_member_ports : false
  #          suspend_individual_port       = a.suspend_individual_port != null ? a.suspend_individual_port : true
  #          symmetric_hashing             = a.symmetric_hashing != null ? a.symmetric_hashing : false
  #        }
  #        ] : [
  #        {
  #          fast_select_hot_standby_ports = true
  #          graceful_convergence          = true
  #          load_defer_member_ports       = false
  #          suspend_individual_port       = true
  #          symmetric_hashing             = false
  #        }
  #      ]
  #      global_alias            = v.global_alias != null ? v.global_alias : ""
  #      maximum_number_of_links = v.maximum_number_of_links != null ? v.maximum_number_of_links : 16
  #      minimum_number_of_links = v.minimum_number_of_links != null ? v.minimum_number_of_links : 1
  #      mode                    = v.mode != null ? v.mode : "off"
  #    }
  #  }
  #
  #  policies_port_channel_global_alias = {
  #    for k, v in local.policies_port_channel : k => {
  #      global_alias = v.global_alias
  #    } if v.global_alias != ""
  #  }
  #
  #  #=========================
  #  # Port Security
  #  #=========================
  #
  #  policies_port_security = {
  #    for k, v in var.policies_port_security : k => {
  #      annotation            = v.annotation != null ? v.annotation : ""
  #      description           = v.description != null ? v.description : ""
  #      maximum_endpoints     = v.maximum_endpoints != null ? v.maximum_endpoints : 0
  #      port_security_timeout = v.port_security_timeout != null ? v.port_security_timeout : 60
  #    }
  #  }
  #
  #
  #  #=========================
  #  # Spanning-Tree Interface
  #  #=========================
  #
  #  policies_spanning_tree_interface = {
  #    for k, v in var.policies_spanning_tree_interface : k => {
  #      annotation   = v.annotation != null ? v.annotation : ""
  #      bpdu_guard   = v.bpdu_guard != null ? v.bpdu_guard : false
  #      bpdu_filter  = v.bpdu_filter != null ? v.bpdu_filter : false
  #      description  = v.description != null ? v.description : ""
  #      global_alias = v.global_alias != null ? v.global_alias : ""
  #    }
  #  }
  #
  #  policies_spanning_tree_interface_global_alias = {
  #    for k, v in local.policies_spanning_tree_interface : k => {
  #      global_alias = v.global_alias
  #    } if v.global_alias != ""
  #  }
  #
  #
  #  #__________________________________________________________
  #  #
  #  # Leaf Interface Policy Group Variables
  #  #__________________________________________________________
  #
  #  leaf_interfaces_policy_groups_access = {
  #    for k, v in var.leaf_interfaces_policy_groups_access : k => {
  #      attachable_entity_profile        = v.attachable_entity_profile != null ? v.attachable_entity_profile : ""
  #      annotation                       = v.annotation != null ? v.annotation : ""
  #      cdp_interface_policy             = v.cdp_interface_policy != null ? v.cdp_interface_policy : ""
  #      copp_interface_policy            = v.copp_interface_policy != null ? v.copp_interface_policy : ""
  #      data_plane_policing_egress       = v.data_plane_policing_egress != null ? v.data_plane_policing_egress : ""
  #      data_plane_policing_ingress      = v.data_plane_policing_ingress != null ? v.data_plane_policing_ingress : ""
  #      description                      = v.description != null ? v.description : ""
  #      dot1x_port_authentication_policy = v.dot1x_port_authentication_policy != null ? v.dot1x_port_authentication_policy : ""
  #      dwdm_policy                      = v.dwdm_policy != null ? v.dwdm_policy : ""
  #      fibre_channel_interface_policy   = v.fibre_channel_interface_policy != null ? v.fibre_channel_interface_policy : ""
  #      global_alias                     = v.global_alias != null ? v.global_alias : ""
  #      l2_interface_policy              = v.l2_interface_policy != null ? v.l2_interface_policy : ""
  #      link_flap_policy                 = v.link_flap_policy != null ? v.link_flap_policy : ""
  #      link_level_flow_control_policy   = v.link_level_flow_control_policy != null ? v.link_level_flow_control_policy : ""
  #      link_level_policy                = v.link_level_policy != null ? v.link_level_policy : ""
  #      lldp_interface_policy            = v.lldp_interface_policy != null ? v.lldp_interface_policy : ""
  #      macsec_policy                    = v.macsec_policy != null ? v.macsec_policy : ""
  #      mcp_interface_policy             = v.mcp_interface_policy != null ? v.mcp_interface_policy : ""
  #      monitoring_policy                = v.monitoring_policy != null ? v.monitoring_policy : ""
  #      netflow_monitor_policies = v.netflow_monitor_policies != null ? [
  #        for s in v.netflow_monitor_policies : {
  #          ip_filter_type         = s.ip_filter_type != null ? s.ip_filter_type : "ipv4"
  #          netflow_monitor_policy = s.netflow_monitor_policy
  #        }
  #      ] : []
  #      poe_interface_policy           = v.poe_interface_policy != null ? v.poe_interface_policy : ""
  #      port_security_policy           = v.port_security_policy != null ? v.port_security_policy : ""
  #      priority_flow_control_policy   = v.priority_flow_control_policy != null ? v.priority_flow_control_policy : ""
  #      slow_drain_policy              = v.slow_drain_policy != null ? v.slow_drain_policy : ""
  #      span_destination_groups        = v.span_destination_groups != null ? v.span_destination_groups : []
  #      span_source_groups             = v.span_source_groups != null ? v.span_source_groups : []
  #      spanning_tree_interface_policy = v.spanning_tree_interface_policy != null ? v.spanning_tree_interface_policy : ""
  #      storm_control_policy           = v.storm_control_policy != null ? v.storm_control_policy : ""
  #      synce_interface_policy         = v.synce_interface_policy != null ? v.synce_interface_policy : ""
  #    }
  #  }
  #
  #  leaf_interfaces_policy_groups_access_global_alias = {
  #    for k, v in local.leaf_interfaces_policy_groups_access : k => {
  #      global_alias = v.global_alias
  #    } if v.global_alias != ""
  #  }
  #
  #  leaf_interfaces_policy_groups_breakout = {
  #    for k, v in var.leaf_interfaces_policy_groups_breakout : k => {
  #      annotation   = v.annotation != null ? v.annotation : ""
  #      breakout_map = v.breakout_map != null ? v.breakout_map : "10g-4x"
  #      description  = v.description != null ? v.description : ""
  #    }
  #  }
  #
  #
  #  leaf_interfaces_policy_groups_bundle = {
  #    for k, v in var.leaf_interfaces_policy_groups_bundle : k => {
  #      attachable_entity_profile      = v.attachable_entity_profile != null ? v.attachable_entity_profile : ""
  #      annotation                     = v.annotation != null ? v.annotation : ""
  #      cdp_interface_policy           = v.cdp_interface_policy != null ? v.cdp_interface_policy : ""
  #      copp_interface_policy          = v.copp_interface_policy != null ? v.copp_interface_policy : ""
  #      data_plane_policing_egress     = v.data_plane_policing_egress != null ? v.data_plane_policing_egress : ""
  #      data_plane_policing_ingress    = v.data_plane_policing_ingress != null ? v.data_plane_policing_ingress : ""
  #      description                    = v.description != null ? v.description : ""
  #      fibre_channel_interface_policy = v.fibre_channel_interface_policy != null ? v.fibre_channel_interface_policy : ""
  #      l2_interface_policy            = v.l2_interface_policy != null ? v.l2_interface_policy : ""
  #      link_aggregation_policy        = v.link_aggregation_policy != null ? v.link_aggregation_policy : ""
  #      link_aggregation_type          = v.link_aggregation_type != null ? v.link_aggregation_type : "vpc"
  #      link_flap_policy               = v.link_flap_policy != null ? v.link_flap_policy : ""
  #      link_level_flow_control_policy = v.link_level_flow_control_policy != null ? v.link_level_flow_control_policy : ""
  #      link_level_policy              = v.link_level_policy != null ? v.link_level_policy : ""
  #      lldp_interface_policy          = v.lldp_interface_policy != null ? v.lldp_interface_policy : ""
  #      macsec_policy                  = v.macsec_policy != null ? v.macsec_policy : ""
  #      mcp_interface_policy           = v.mcp_interface_policy != null ? v.mcp_interface_policy : ""
  #      monitoring_policy              = v.monitoring_policy != null ? v.monitoring_policy : ""
  #      netflow_monitor_policies = v.netflow_monitor_policies != null ? [
  #        for s in v.netflow_monitor_policies : {
  #          ip_filter_type         = s.ip_filter_type != null ? s.ip_filter_type : "ipv4"
  #          netflow_monitor_policy = s.netflow_monitor_policy
  #        }
  #      ] : []
  #      port_security_policy           = v.port_security_policy != null ? v.port_security_policy : ""
  #      priority_flow_control_policy   = v.priority_flow_control_policy != null ? v.priority_flow_control_policy : ""
  #      slow_drain_policy              = v.slow_drain_policy != null ? v.slow_drain_policy : ""
  #      span_destination_groups        = v.span_destination_groups != null ? v.span_destination_groups : ""
  #      span_source_groups             = v.span_source_groups != null ? v.span_source_groups : ""
  #      spanning_tree_interface_policy = v.spanning_tree_interface_policy != null ? v.spanning_tree_interface_policy : ""
  #      storm_control_policy           = v.storm_control_policy != null ? v.storm_control_policy : ""
  #    }
  #  }
  #
  #
  #  #__________________________________________________________
  #  #
  #  # Switches - Leaf Policy Group Variables
  #  #__________________________________________________________
  #
  #  switches_leaf_policy_groups = {
  #    for k, v in var.switches_leaf_policy_groups : k => {
  #      annotation                       = v.annotation != null ? v.annotation : ""
  #      bfd_ipv4_policy                  = v.bfd_ipv4_policy != null ? v.bfd_ipv4_policy : "default"
  #      bfd_ipv6_policy                  = v.bfd_ipv6_policy != null ? v.bfd_ipv6_policy : "default"
  #      bfd_multihop_ipv4_policy         = v.bfd_multihop_ipv4_policy != null ? v.bfd_multihop_ipv4_policy : "default"
  #      bfd_multihop_ipv6_policy         = v.bfd_multihop_ipv6_policy != null ? v.bfd_multihop_ipv6_policy : "default"
  #      cdp_interface_policy             = v.cdp_interface_policy != null ? v.cdp_interface_policy : "default"
  #      copp_leaf_policy                 = v.copp_leaf_policy != null ? v.copp_leaf_policy : "default"
  #      copp_pre_filter                  = v.copp_pre_filter != null ? v.copp_pre_filter : "default"
  #      description                      = v.description != null ? v.description : ""
  #      dot1x_node_authentication_policy = v.dot1x_node_authentication_policy != null ? v.dot1x_node_authentication_policy : "default"
  #      equipment_flash_config           = v.equipment_flash_config != null ? v.equipment_flash_config : "default"
  #      fast_link_failover_policy        = v.fast_link_failover_policy != null ? v.fast_link_failover_policy : "default"
  #      fibre_channel_node_policy        = v.fibre_channel_node_policy != null ? v.fibre_channel_node_policy : "default"
  #      fibre_channel_san_policy         = v.fibre_channel_san_policy != null ? v.fibre_channel_san_policy : "default"
  #      forward_scale_profile_policy     = v.forward_scale_profile_policy != null ? v.forward_scale_profile_policy : "default"
  #      lldp_interface_policy            = v.lldp_interface_policy != null ? v.lldp_interface_policy : "default"
  #      monitoring_policy                = v.monitoring_policy != null ? v.monitoring_policy : "default"
  #      netflow_node_policy              = v.netflow_node_policy != null ? v.netflow_node_policy : "default"
  #      poe_node_policy                  = v.poe_node_policy != null ? v.poe_node_policy : "default"
  #      ptp_node_policy                  = v.ptp_node_policy != null ? v.ptp_node_policy : "default"
  #      spanning_tree_interface_policy   = v.spanning_tree_interface_policy != null ? v.spanning_tree_interface_policy : "default"
  #      synce_node_policy                = v.synce_node_policy != null ? v.synce_node_policy : "default"
  #      usb_configuration_policy         = v.usb_configuration_policy != null ? v.usb_configuration_policy : "default"
  #    }
  #  }
  #
  #
  #  #__________________________________________________________
  #  #
  #  # Spine Interface Policy Group Variables
  #  #__________________________________________________________
  #
  #  spine_interface_policy_groups = {
  #    for k, v in var.spine_interface_policy_groups : k => {
  #      attachable_entity_profile = v.attachable_entity_profile
  #      annotation                = v.annotation != null ? v.annotation : ""
  #      cdp_interface_policy      = v.cdp_interface_policy != null ? v.cdp_interface_policy : "default"
  #      description               = v.description != null ? v.description : ""
  #      global_alias              = v.global_alias != null ? v.global_alias : ""
  #      link_level_policy         = v.link_level_policy != null ? v.link_level_policy : "default"
  #      macsec_policy             = v.macsec_policy != null ? v.macsec_policy : "default"
  #    }
  #  }
  #
  #  spine_interface_policy_groups_global_alias = {
  #    for k, v in local.spine_interface_policy_groups : k => {
  #      global_alias = v.global_alias
  #    } if v.global_alias != ""
  #  }
  #
  #
  #  #__________________________________________________________
  #  #
  #  # Switches - Spine Policy Group Variables
  #  #__________________________________________________________
  #
  #  switches_spine_policy_groups = {
  #    for k, v in var.switches_spine_policy_groups : k => {
  #      annotation               = v.annotation != null ? v.annotation : ""
  #      bfd_ipv4_policy          = v.bfd_ipv4_policy != null ? v.bfd_ipv4_policy : "default"
  #      bfd_ipv6_policy          = v.bfd_ipv6_policy != null ? v.bfd_ipv6_policy : "default"
  #      cdp_interface_policy     = v.cdp_interface_policy != null ? v.cdp_interface_policy : "default"
  #      copp_pre_filter          = v.copp_pre_filter != null ? v.copp_pre_filter : "default"
  #      copp_spine_policy        = v.copp_spine_policy != null ? v.copp_spine_policy : "default"
  #      description              = v.description != null ? v.description : ""
  #      lldp_interface_policy    = v.lldp_interface_policy != null ? v.lldp_interface_policy : "default"
  #      usb_configuration_policy = v.usb_configuration_policy != null ? v.usb_configuration_policy : "default"
  #    }
  #  }
  #
  #
  #  #__________________________________________________________
  #  #
  #  # VLAN Pools Variables
  #  #__________________________________________________________
  #
  #  # This first loop is to handle optional attributes and return 
  #  # default values if the user doesn't enter a value.
  #  pools_vlan = {
  #    for k, v in var.pools_vlan : k => {
  #      allocation_mode = v.allocation_mode != null ? v.allocation_mode : "dynamic"
  #      annotation      = v.annotation != null ? v.annotation : ""
  #      description     = v.description != null ? v.description : ""
  #      encap_blocks    = v.encap_blocks != null ? v.encap_blocks : {}
  #    }
  #  }
  #
  #  /*
  #  Loop 1 is to determine if the vlan_range is:
  #  * A Single number 1
  #  * A Range of numbers 1-5
  #  * A List of numbers 1-5,10-15
  #  And then to return these values as a list
  #  */
  #  vlan_ranges_loop_1 = flatten([
  #    for key, value in local.pools_vlan : [
  #      for k, v in value.encap_blocks : {
  #        allocation_mode = v.allocation_mode != null ? v.allocation_mode : "inherit"
  #        annotation      = value.annotation
  #        description     = v.description != null ? v.description : ""
  #        key1            = key
  #        key2            = k
  #        role            = v.role != null ? v.role : "external"
  #        vlan_split = length(regexall("-", v.vlan_range)) > 0 ? tolist(split(",", v.vlan_range)) : length(
  #          regexall(",", v.vlan_range)) > 0 ? tolist(split(",", v.vlan_range)
  #        ) : [v.vlan_range]
  #        vlan_range = v.vlan_range
  #      }
  #    ]
  #  ])
  #
  #  # Loop 2 takes a list that contains a "-" or a "," and expands those values
  #  # into a full list.  So [1-5] becomes [1, 2, 3, 4, 5]
  #  vlan_ranges_loop_2 = {
  #    for k, v in local.vlan_ranges_loop_1 : "${v.key1}_${v.key2}" => {
  #      allocation_mode = v.allocation_mode
  #      annotation      = v.annotation
  #      description     = v.description
  #      key1            = v.key1
  #      key2            = v.key2
  #      role            = v.role
  #      vlan_list = length(regexall("(,|-)", jsonencode(v.vlan_range))) > 0 ? flatten([
  #        for s in v.vlan_split : length(regexall("-", s)) > 0 ? [for v in range(tonumber(
  #          element(split("-", s), 0)), (tonumber(element(split("-", s), 1)) + 1)
  #        ) : tonumber(v)] : [s]
  #      ]) : v.vlan_split
  #    }
  #  }
  #
  #  # Loop 3 will take the vlan_list created in Loop 2 and expand this
  #  # out to a map of objects per vlan.
  #  vlan_ranges_loop_3 = flatten([
  #    for k, v in local.vlan_ranges_loop_2 : [
  #      for s in v.vlan_list : {
  #        allocation_mode = v.allocation_mode
  #        annotation      = v.annotation
  #        description     = v.description
  #        key1            = v.key1
  #        role            = v.role
  #        vlan            = s
  #      }
  #    ]
  #  ])
  #
  #  # And lastly loop3's list is converted back to a map of objects
  #  vlan_ranges = { for k, v in local.vlan_ranges_loop_3 : "${v.key1}_${v.vlan}" => v }
  #
}
