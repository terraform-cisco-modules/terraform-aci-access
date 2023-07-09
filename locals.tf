locals {
  #__________________________________________________________
  #
  # Model Inputs
  #__________________________________________________________

  defaults           = yamldecode(file("${path.module}/defaults.yaml")).defaults
  domains            = lookup(var.access, "physical_and_external_domains", {})
  global             = lookup(lookup(var.access, "policies", {}), "global", {})
  interface          = lookup(lookup(var.access, "policies", {}), "interface", {})
  intf_pg_leaf       = lookup(lookup(var.access, "interfaces", {}), "leaf", {})
  intf_pg_spine      = lookup(lookup(var.access, "interfaces", {}), "spine", {})
  pools              = lookup(var.access, "pools", {})
  virtual_networking = lookup(var.virtual_networking, "virtual_networking", {})
  pre_built          = local.defaults.access.pre_built_interface_policies
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
  rsp          = local.defaults.access.policies.global.recommended_policies
  rss          = merge(local.rsp, lookup(local.global, "recommended_policies", {}))
  sw_pgs_leaf  = lookup(lookup(var.access, "switches", {}), "leaf", {})
  sw_pgs_spine = lookup(lookup(var.access, "switches", {}), "spine", {})
  # Defaults: Domains
  l3   = local.defaults.access.physical_and_external_domains.l3_domains
  phys = local.defaults.access.physical_and_external_domains.physical_domains
  # Defaults: Interfaces
  laccess = local.defaults.access.interfaces.leaf.policy_groups.access
  lbrkout = local.defaults.access.interfaces.leaf.policy_groups.breakout
  lbundle = local.defaults.access.interfaces.leaf.policy_groups.bundle
  netflow = local.defaults.access.interfaces.leaf.policy_groups.netflow_monitor_policies
  saccess = local.defaults.access.interfaces.spine.policy_groups
  # Defaults: Policies -> Global
  aaep     = local.defaults.access.policies.global.attachable_access_entity_profiles
  dhcp     = local.defaults.access.policies.global.dhcp_relay
  mcpi     = local.defaults.access.policies.global.mcp_instance_policy
  recovery = local.defaults.access.policies.global.error_disabled_recovery_policy
  qos      = local.defaults.access.policies.global.qos_class
  vpcp     = local.defaults.access.policies.global.vpc_domain
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
      vlan_pool = lookup(v, "vlan_pool", local.l3.vlan_pool)
    }
  }

  physical_domains = {
    for k, v in lookup(local.domains, "physical_domains", {}) : v.name => {
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
      description = lookup(v, "description", local.aaep.description)
      domains = compact(concat(
        [for i in lookup(v, "l3_domains", []) : aci_l3_domain_profile.map["${i}"].id],
        [for i in lookup(v, "physical_domains", []) : aci_physical_domain.map["${i}"].id],
        [for i in lookup(v, "vmm_domains", []) : aci_vmm_domain.map["${i}"].id]
      ))
    }
  }

  #===================================
  # Global - DHCP Relay
  #===================================
  dhcp_relay = { for i in flatten([
    for k, v in lookup(local.global, "dhcp_relay", []) : [
      for s in v.dhcp_servers : {
        address             = s
        application_profile = lookup(v, "application_profile", local.dhcp.application_profile)
        description         = lookup(v, "description", local.dhcp.description)
        epg                 = v.epg
        epg_type            = lookup(v, "epg_type", local.dhcp.epg_type)
        l3out               = lookup(v, "l3out", local.dhcp.l3out)
        mode                = lookup(v, "mode", local.dhcp.mode)
        name                = s
        tenant              = lookup(v, "tenant", local.dhcp.tenant)
        new_key             = "${v.epg_type}:${v.epg}:${s}"
      }
    ]
  ]) : "${i.new_key}" => i }

  error_disabled_recovery = local.rss.error_disabled_recovery_policy == false && length(lookup(
    local.global, "error_disabled_recovery_policy", {})) > 0 ? merge(
    { create = true }, local.recovery, lookup(local.global, "error_disabled_recovery_policy", {},
    { events = merge(local.recovery.events, lookup(lookup(local.global, "error_disabled_recovery_policy", {}), "events", {})) })
    ) : length(regexall(true, local.rss.error_disabled_recovery_policy)
  ) > 0 ? merge({ create = true }, local.recovery) : merge({ create = false }, local.recovery)

  mcp_instance = local.rss.mcp_instance_policy == false && length(lookup(local.global, "mcp_instance_policy", {})
    ) > 0 ? merge({ create = true }, local.mcpi, lookup(local.global, "mcp_instance_policy", {}),
    { transmission_frequency = merge(local.mcpi.transmission_frequency, lookup(lookup(
      local.global, "mcp_instance_policy", {}), "transmission_frequency", {}))
    }) : length(regexall(true, local.rss.mcp_instance_policy)
  ) > 0 ? merge({ create = true }, local.mcpi) : merge({ create = false }, local.mcpi)

  qos_class = local.rss.qos_class == false && length(lookup(local.global, "qos_class", {})
    ) > 0 ? merge({ create = true }, local.qos, lookup(local.global, "qos_class", {})
    ) : length(regexall(true, local.rss.qos_class)
  ) > 0 ? merge({ create = true }, local.qos) : merge({ create = false }, local.qos)

  vpc_domain = local.rss.vpc_domain == false && length(lookup(local.global, "vpc_domain", {})
    ) > 0 ? merge({ create = true }, local.vpcp, lookup(local.global, "vpc_domain", {})
    ) : length(regexall(true, local.rss.vpc_domain)
  ) > 0 ? merge({ create = true }, local.vpcp) : merge({ create = false }, local.vpcp)


  #__________________________________________________________
  #
  # Interface Policies Variables
  #__________________________________________________________

  #===================================
  # Merge - CDP
  #===================================
  cdp_pre_built = local.pre_cfg.cdp_interface == true ? local.pre_built.cdp_interface : []
  cdp_user      = lookup(local.interface, "cdp_interface", [])
  cdp_policies  = concat(local.cdp_pre_built, local.cdp_user)
  cdp_interface = { for v in local.cdp_policies : v.name => merge(local.cdp, v) }
  #===================================
  # Merge - Fibre-Channel Interface
  #===================================
  fc_pre_built = local.pre_cfg.fibre_channel_interface == true ? local.pre_built.fibre_channel_interface : []
  fc_user      = lookup(local.interface, "fibre_channel_interface", [])
  fc_policies  = concat(local.fc_pre_built, local.fc_user)
  fibre_channel_interface = {
    for v in local.fc_policies : v.name => merge(local.fc, v)
  }
  #===================================
  # Merge - L2 Interface 
  #===================================
  l2_pre_built = local.pre_cfg.l2_interface == true ? local.pre_built.l2_interface : []
  l2_user      = lookup(local.interface, "l2_interface", [])
  l2_policies  = concat(local.l2_pre_built, local.l2_user)
  l2_interface = { for v in local.l2_policies : v.name => merge(local.l2, v) }
  #===================================
  # Merge - Link Level
  #===================================
  ll_pre_built = local.pre_cfg.link_level == true ? local.pre_built.link_level : []
  ll_user      = lookup(local.interface, "link_level", [])
  ll_policies  = concat(local.ll_pre_built, local.ll_user)
  link_level   = { for v in local.ll_policies : v.name => merge(local.ll, v) }
  #===================================
  # Merge - LLDP
  #===================================
  lldp_pre_built = local.pre_cfg.lldp_interface == true ? local.pre_built.lldp_interface : []
  lldp_user      = lookup(local.interface, "lldp_interface", [])
  lldp_policies  = concat(local.lldp_pre_built, local.lldp_user)
  lldp_interface = { for v in local.lldp_policies : v.name => merge(local.lldp, v) }
  #===================================
  # Merge - Mis-Cabling Protocol
  #===================================
  mcp_pre_built = local.pre_cfg.mcp_interface == true ? local.pre_built.mcp_interface : []
  mcp_user      = lookup(local.interface, "mcp_interface", [])
  mcp_policies  = concat(local.mcp_pre_built, local.mcp_user)
  mcp_interface = { for v in local.mcp_policies : v.name => merge(local.mcp, v) }
  #===================================
  # Merge - Port-Channel
  #===================================
  pc_pre_built = local.pre_cfg.port_channel == true ? local.pre_built.port_channel : []
  pc_user      = lookup(local.interface, "port_channel", [])
  pc_policies  = concat(local.pc_pre_built, local.pc_user)
  port_channel = { for v in local.pc_policies : v.name => merge(local.pc, v, merge(local.pc.control, lookup(v, "control", {}))) }
  #===================================
  # Merge - Port Security
  #===================================
  ps_pre_built  = local.pre_cfg.port_security == true ? local.pre_built.port_security : []
  ps_user       = lookup(local.interface, "port_security", [])
  ps_policies   = concat(local.ps_pre_built, local.ps_user)
  port_security = { for v in local.ps_policies : v.name => merge(local.ps, v) }
  #===================================
  # Merge - Spanning-tree Protocol
  #===================================
  stp_pre_built = local.pre_cfg.spanning_tree_interface == true ? local.pre_built.spanning_tree_interface : []
  stp_user      = lookup(local.interface, "spanning_tree_interface", [])
  stp_policies  = concat(local.stp_pre_built, local.stp_user)
  spanning_tree_interface = {
    for v in local.stp_policies : v.name => merge(local.stp, v)
  }

  #__________________________________________________________
  #
  # Leaf Interface Policy Group Variables
  #__________________________________________________________
  access_list = lookup(lookup(local.intf_pg_leaf, "policy_groups", {}), "access", [])
  leaf_interfaces_policy_groups_access = {
    for v in local.access_list : v.name => merge(
      local.laccess, v, { netflow_monitor_policies = [
        for e in lookup(v, "netflow_monitor_policies", []) : {
          ip_filter_type         = lookup(e, "ip_filter_type", local.netflow.ip_filter_type)
          netflow_monitor_policy = e.netflow_monitor_policy
        }
      ] }
    )
  }

  leaf_interfaces_policy_groups_breakout = {
    for k, v in lookup(lookup(local.intf_pg_leaf, "policy_groups", {}), "breakout", {}) : v.name => {
      breakout_map = lookup(v, "breakout_map", local.lbrkout.breakout_map)
      description  = lookup(v, "description", local.lbrkout.description)
    }
  }


  bundle_list = lookup(lookup(local.intf_pg_leaf, "policy_groups", {}), "bundle", [])
  leaf_interfaces_policy_groups_bundle = { for i in flatten([
    for v in local.bundle_list : [
      for s in v.names : merge(
        local.lbundle, v, { netflow_monitor_policies = [
          for e in lookup(v, "netflow_monitor_policies", []) : {
            ip_filter_type         = lookup(e, "ip_filter_type", local.netflow.ip_filter_type)
            netflow_monitor_policy = e.netflow_monitor_policy
          }
      ] }, { name = s })
    ]
  ]) : i.name => i }

  #__________________________________________________________
  #
  # Switches - Leaf Policy Group Variables
  #__________________________________________________________
  switches_leaf_policy_groups = {
    for v in lookup(local.sw_pgs_leaf, "policy_groups", {}) : v.name => merge(local.swpgl, v)
  }


  #__________________________________________________________
  #
  # Spine Interface Policy Group Variables
  #__________________________________________________________

  spine_interface_policy_groups = {
    for v in lookup(local.intf_pg_spine, "policy_groups", {}) : v.name => merge(local.saccess, v)
  }

  #__________________________________________________________
  #
  # Switches - Spine Policy Group Variables
  #__________________________________________________________

  switches_spine_policy_groups = {
    for v in lookup(local.sw_pgs_spine, "policy_groups", {}) : v.name => merge(local.swpgs, v)
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
      description     = lookup(v, "description", local.vlan.description)
      encap_blocks    = lookup(v, "encap_blocks", [])
      name            = v.name
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

  vmm_domains = { for i in flatten([
    for value in lookup(var.virtual_networking, "vmm", []) : [
      for v in value.domain : {
        access_mode           = lookup(v, "access_mode", local.vmm.domain.access_mode)
        control_knob          = lookup(v, "control_knob", local.vmm.domain.control_knob)
        delimiter             = lookup(v, "delimiter", local.vmm.domain.delimiter)
        dvs                   = value.name
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
        uplink_names            = lookup(v, "uplink_names", local.vmm.domain.uplink_names)
        vlan_pool               = v.vlan_pool
      }
    ]
  ]) : i.dvs => i }
  vmm_credentials = { for i in flatten([
    for value in lookup(var.virtual_networking, "vmm", []) : [
      for k, v in value.credentials : {
        dvs         = value.name
        description = lookup(v, "description", local.vmm.credentials.description)
        username    = v.username
      }
    ]
  ]) : i.dvs => i }
  vmm_controllers = {
    for i in flatten([
      for value in lookup(var.virtual_networking, "vmm", []) : [
        for v in value.controllers : {
          datacenter     = lookup(v, "datacenter", local.vmm.controllers.datacenter)
          dvs            = value.name
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
  vswitch_policies = { for i in flatten([
    for value in lookup(var.virtual_networking, "vmm", []) : [
      for k, v in value.vswitch_policy : {
        cdp_interface_policy = lookup(v, "cdp_interface_policy", "")
        dvs                  = value.name
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
  ]) : i.dvs => i }
  vmm_uplinks = { for i in flatten([
    for k, v in local.vmm_domains : [
      for s in range(length(v.uplink_names)) : {
        access_mode     = v.access_mode
        dvs             = k
        switch_provider = v.switch_provider
        uplinkId        = s + 1
        uplinkName      = element(v.uplink_names, s)
      }
    ]
    ]) : "${i.dvs}:${i.uplinkName}" => i if i.access_mode == "read-write"
  }
}
