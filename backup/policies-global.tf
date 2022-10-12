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
    aci_l3_domain_profile.domains_layer3,
    aci_physical_domain.domains_physical,
    aci_vmm_domain.domains_vmm
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
      regexall("external_epg", each.value.dhcp_relay_providers[0]["epg_type"])
      ) > 0 ? "rsprov-[uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/out-${each.value.dhcp_relay_providers[0]["l3out"]}/instP-${each.value.dhcp_relay_providers[0]["epg"]}]" : length(
      regexall("application_epg", each.value.dhcp_relay_providers[0]["epg_type"])
    ) > 0 ? "rsprov-[uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/ap-${each.value.dhcp_relay_providers[0]["application_profile"]}/epg-${each.value.dhcp_relay_providers[0]["epg"]}]" : ""
    class_name = "dhcpRsProv"
    content = {
      addr = each.value.dhcp_relay_providers[0]["address"]
      tDn = length(
        regexall("external_epg", each.value.dhcp_relay_providers[0]["epg_type"])
        ) > 0 ? "uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/out-${each.value.dhcp_relay_providers[0]["l3out"]}/instP-${each.value.dhcp_relay_providers[0]["epg"]}" : length(
        regexall("application_epg", each.value.dhcp_relay_providers[0]["epg_type"])
      ) > 0 ? "uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/ap-${each.value.dhcp_relay_providers[0]["application_profile"]}/epg-${each.value.dhcp_relay_providers[0]["epg"]}" : ""
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
resource "aci_error_disable_recovery" "error_disabled_recovery_policy" {
  for_each            = local.error_disabled_recovery_policy
  annotation          = each.value.annotation
  err_dis_recov_intvl = each.value.error_disable_recovery_interval
  edr_event {
    event   = "event-bpduguard"
    recover = each.value.events[0].bpdu_guard == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ep-move"
    recover = each.value.events[0].frequent_endpoint_move == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-mcp-loop"
    recover = each.value.events[0].loop_indication_by_mcp == true ? "yes" : "no"
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
resource "aci_mcp_instance_policy" "mcp_instance_policy" {
  for_each         = local.mcp_instance_policy
  admin_st         = each.value.admin_state
  annotation       = each.value.annotation
  ctrl             = each.value.enable_mcp_pdu_per_vlan == true ? ["pdu-per-vlan", "stateful-ha"] : ["stateful-ha"]
  description      = each.value.description
  init_delay_time  = each.value.initial_delay
  key              = var.mcp_instance_key
  loop_detect_mult = each.value.loop_detect_multiplication_factor
  loop_protect_act = each.value.loop_protection_disable_port == true ? "port-disable" : "none"
  tx_freq          = each.value.transmission_frequency[0].seconds
  tx_freq_msec     = each.value.transmission_frequency[0].msec
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
  for_each              = local.qos_class
  annotation            = each.value.annotation
  ctrl                  = each.value.preserve_cos == true ? "dot1p-preserve" : "none"
  description           = each.value.description
  etrap_age_timer       = each.value.elephant_trap_age_period
  etrap_bw_thresh       = each.value.elephant_trap_bandwidth_threshold
  etrap_byte_ct         = each.value.elephant_trap_byte_count
  etrap_st              = each.value.elephant_trap_state == true ? "yes" : "no"
  fabric_flush_interval = each.value.fabric_flush_interval
  fabric_flush_st       = each.value.fabric_flush_state == true ? "yes" : "no"
  uburst_spine_queues   = each.value.micro_burst_spine_queues
  uburst_tor_queues     = each.value.micro_burst_leaf_queues
}
