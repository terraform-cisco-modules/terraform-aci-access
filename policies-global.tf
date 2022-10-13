/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_attachable_access_entity_profile" "attachable_access_entity_profiles" {
  depends_on = [
    aci_l3_domain_profile.l3_domains,
    aci_physical_domain.physical_domains,
    aci_vmm_domain.vmm_domains
  ]
  for_each                = local.attachable_access_entity_profiles
  annotation              = each.value.annotation
  description             = each.value.description
  name                    = each.key
  relation_infra_rs_dom_p = each.value.domains
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraGeneric"
 - Distinguished Name: "uni/infra/attentp-{name}/gen-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {name}: Application EPGs
_______________________________________________________________________________________________________________________
*/
resource "aci_access_generic" "access_generic" {
  depends_on = [
    aci_attachable_access_entity_profile.attachable_access_entity_profiles
  ]
  for_each                            = local.attachable_access_entity_profiles
  annotation                          = each.value.annotation
  attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.attachable_access_entity_profiles[each.key].id
  name                                = "default"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dhcpRelayPol"
 - Distinguised Name: "uni/infra-{name}/relayp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > DHCP Relay > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "dhcp_relay" {
  for_each   = local.dhcp_relay
  class_name = "dhcpRelayP"
  dn         = "uni/infra/relayp-${each.key}"
  content = {
    # annotation = each.value.annotation
    descr = each.value.description
    mode  = each.value.mode
    name  = each.key
    owner = "infra"
  }
  child {
    rn = length(
      regexall("external_epg", each.value.epg_type)
      ) > 0 ? "rsprov-[uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}]" : length(
      regexall("application_epg", each.value.epg_type)
    ) > 0 ? "rsprov-[uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.epg}]" : ""
    class_name = "dhcpRsProv"
    content = {
      addr = each.value.address
      tDn = length(
        regexall("external_epg", each.value.epg_type)
        ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}" : length(
        regexall("application_epg", each.value.epg_type)
      ) > 0 ? "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.epg}" : ""
    }
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "edrErrDisRecoverPol"
 - Distinguished Named "uni/infra/edrErrDisRecoverPol-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Error Disabled Recovery Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_error_disable_recovery" "error_disabled_recovery" {
  for_each = {
    for v in toset(["default"]) : "default" => v if local.recommended_settings.error_disabled_recovery == true
  }
  annotation = length(compact([local.recovery.annotation])
  ) > 0 ? local.recovery.annotation : local.defaults.annotation
  err_dis_recov_intvl = local.recovery.error_disable_recovery_interval
  edr_event {
    event   = "event-bpduguard"
    recover = local.recovery.events.bpdu_guard == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ep-move"
    recover = local.recovery.events.frequent_endpoint_move == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-mcp-loop"
    recover = local.recovery.events.loop_indication_by_mcp == true ? "yes" : "no"
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mcpInstPol"
 - Distinguished Named "uni/infra/mcpInstP-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > MCP Instance Policy default
_______________________________________________________________________________________________________________________
*/
resource "aci_mcp_instance_policy" "mcp_instance" {
  for_each = {
    for v in toset(["default"]) : "default" => v if local.recommended_settings.mcp_instance == true
  }
  admin_st   = local.mcpi.admin_state
  annotation = coalesce(local.mcpi.annotation, local.defaults.annotation)
  ctrl = length(regexall(true, local.mcpi.enable_mcp_pdu_per_vlan)
  ) > 0 ? ["pdu-per-vlan", "stateful-ha"] : ["stateful-ha"]
  description      = local.mcpi.description
  init_delay_time  = local.mcpi.initial_delay
  key              = var.mcp_instance_key
  loop_detect_mult = local.mcpi.loop_detect_multiplication_factor
  loop_protect_act = local.mcpi.loop_protection_disable_port == true ? "port-disable" : "none"
  tx_freq          = local.mcpi.transmission_frequency.seconds
  tx_freq_msec     = local.mcpi.transmission_frequency.msec
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "qosInstPol"
 - Distinguished Name: "uni/infra/qosinst-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > QOS Class

_______________________________________________________________________________________________________________________
*/
resource "aci_qos_instance_policy" "qos_class" {
  for_each = {
    for v in toset(["default"]) : "default" => v if local.recommended_settings.qos_class == true
  }
  annotation            = coalesce(local.qos.annotation, local.defaults.annotation)
  ctrl                  = local.qos.preserve_cos == true ? "dot1p-preserve" : "none"
  description           = local.qos.description
  etrap_age_timer       = local.qos.elephant_trap_age_period
  etrap_bw_thresh       = local.qos.elephant_trap_bandwidth_threshold
  etrap_byte_ct         = local.qos.elephant_trap_byte_count
  etrap_st              = local.qos.elephant_trap_state == true ? "yes" : "no"
  fabric_flush_interval = local.qos.fabric_flush_interval
  fabric_flush_st       = local.qos.fabric_flush_state == true ? "yes" : "no"
  uburst_spine_queues   = local.qos.micro_burst_spine_queues
  uburst_tor_queues     = local.qos.micro_burst_leaf_queues
}
