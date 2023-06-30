<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Admin Module

A Terraform module to configure ACI Admin Policies.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/easy-aci-complete

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.8.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.8.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | Model data. | `any` | n/a | yes |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `""` | no |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | The Version of this Script. | `string` | `"orchestrator:terraform:easy-aci-v2.0"` | no |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | The Version of this Script. | <pre>list(object(<br>    {<br>      key   = string<br>      value = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "key": "orchestrator",<br>    "value": "terraform:easy-aci:v2.0"<br>  }<br>]</pre> | no |
| <a name="input_controller_type"></a> [controller\_type](#input\_controller\_type) | The Type of Controller for this Site.<br>- apic<br>- ndo | `string` | `"apic"` | no |
| <a name="input_management_epgs"></a> [management\_epgs](#input\_management\_epgs) | The Management EPG's that will be used by the script.<br>- name: Name of the EPG<br>- type: Type of EPG<br>  * inb<br>  * oob | <pre>list(object(<br>    {<br>      name = string<br>      type = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "name": "default",<br>    "type": "oob"<br>  }<br>]</pre> | no |
| <a name="input_mcp_instance_key"></a> [mcp\_instance\_key](#input\_mcp\_instance\_key) | The key or password to uniquely identify the MCP packets within this fabric. | `string` | n/a | yes |
| <a name="input_vmm_password"></a> [vmm\_password](#input\_vmm\_password) | Password for VMM Credentials Policy. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interface-leaf-leaf_interfaces-policy_groups"></a> [interface-leaf-leaf\_interfaces-policy\_groups](#output\_interface-leaf-leaf\_interfaces-policy\_groups) | * access - Identifiers for Access Policy Groups.  Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Access Port.<br>* breakout - Identifiers for Breakout Policy Groups.  Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Breakout Port Group.<br>* bundle - Identifiers for Bundle Policy Groups.  Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => [ VPC Interface \| VPC Interface ]. |
| <a name="output_interface-interfaces-spine_interface-policy_groups"></a> [interface-interfaces-spine\_interface-policy\_groups](#output\_interface-interfaces-spine\_interface-policy\_groups) | Identifiers for Spine Interface Policy Groups.  Fabric => Access Policies => Interfaces => Spine Interfaces => Policy Groups. |
| <a name="output_physical_and_external_domains"></a> [physical\_and\_external\_domains](#output\_physical\_and\_external\_domains) | * l3\_domains - Identifiers for L3 Domains.  Fabric => Access Policies => Physical and External Domains => L3 Domains.<br>* physical\_domains - Identifiers for Physical Domains.  Fabric => Access Policies => Physical and External Domains => Physical Domains. |
| <a name="output_policies-global-attachable_access_entity_profiles"></a> [policies-global-attachable\_access\_entity\_profiles](#output\_policies-global-attachable\_access\_entity\_profiles) | Identifiers for AAEPs.  Fabric => Access Policies => Policies => Global => Attachable Access Entity Profiles. |
| <a name="output_policies-global-dhcp_relay"></a> [policies-global-dhcp\_relay](#output\_policies-global-dhcp\_relay) | Identifiers for DHCP Relay.  Fabric => Access Policies => Policies => Global => DHCP Relay. |
| <a name="output_policies-global-error_disabled_recovery_policy"></a> [policies-global-error\_disabled\_recovery\_policy](#output\_policies-global-error\_disabled\_recovery\_policy) | Identifiers for Error Disabled Recovery.  Fabric => Access Policies => Policies => Global => Error Disabled Recovery Profiles. |
| <a name="output_policies-global-mcp_instance_policy"></a> [policies-global-mcp\_instance\_policy](#output\_policies-global-mcp\_instance\_policy) | Identifiers for MCP Instance Policy.  Fabric => Access Policies => Policies => Global => MCP Instance Policy - default. |
| <a name="output_policies-global-qos_class"></a> [policies-global-qos\_class](#output\_policies-global-qos\_class) | Identifiers for QoS Class.  Fabric => Access Policies => Policies => Global => QoS Class. |
| <a name="output_policies-interface-cdp_interface"></a> [policies-interface-cdp\_interface](#output\_policies-interface-cdp\_interface) | Identifiers for CDP Interface Policies.  Fabric => Access Policies => Policies => Interfaces => CDP Interface. |
| <a name="output_policies-interface-fibre_channel_interface"></a> [policies-interface-fibre\_channel\_interface](#output\_policies-interface-fibre\_channel\_interface) | Identifiers for Fibre Channel Interface Policies.  Fabric => Access Policies => Policies => Interfaces => Fibre Channel Interface. |
| <a name="output_policies-interface-l2_interface"></a> [policies-interface-l2\_interface](#output\_policies-interface-l2\_interface) | Identifiers for L2 Interface Policies.  Fabric => Access Policies => Policies => Interfaces => L2 Interface. |
| <a name="output_policies-interface-link_level"></a> [policies-interface-link\_level](#output\_policies-interface-link\_level) | Identifiers for Link Level Policies.  Fabric => Access Policies => Policies => Interfaces => Link Level. |
| <a name="output_policies-interface-lldp_interface"></a> [policies-interface-lldp\_interface](#output\_policies-interface-lldp\_interface) | Identifiers for LLDP Interface Policies.  Fabric => Access Policies => Policies => Interfaces => LLDP Interface. |
| <a name="output_policies-interface-mcp_interface"></a> [policies-interface-mcp\_interface](#output\_policies-interface-mcp\_interface) | Identifiers for MCP Interface Policies.  Fabric => Access Policies => Policies => Interfaces => MCP Interface. |
| <a name="output_policies-interface-port_channel"></a> [policies-interface-port\_channel](#output\_policies-interface-port\_channel) | Identifiers for Port Channel Policies.  Fabric => Access Policies => Policies => Interfaces => Port Channel. |
| <a name="output_policies-interface-port_security"></a> [policies-interface-port\_security](#output\_policies-interface-port\_security) | Identifiers for Port Security Policies.  Fabric => Access Policies => Policies => Interfaces => Port Security. |
| <a name="output_policies-interface-spanning_tree_interface"></a> [policies-interface-spanning\_tree\_interface](#output\_policies-interface-spanning\_tree\_interface) | Identifiers for Spanning-Tree Interface Policies.  Fabric => Access Policies => Policies => Interfaces => Spanning-Tree Interface. |
| <a name="output_pools-vlan"></a> [pools-vlan](#output\_pools-vlan) | Identifiers for VLAN Pools.  Fabric => Access Policies => Pools => VLAN. |
| <a name="output_switches-leaf_switches-policy_groups"></a> [switches-leaf\_switches-policy\_groups](#output\_switches-leaf\_switches-policy\_groups) | Identifiers for Leaf Switches Policy Groups.  Fabric => Access Policies => Switches => Leaf Switches => Policy Groups. |
| <a name="output_switches-spine_switches-policy_groups"></a> [switches-spine\_switches-policy\_groups](#output\_switches-spine\_switches-policy\_groups) | Identifiers for Spine Switches Policy Groups.  Fabric => Access Policies => Switches => Spines Switches => Policy Groups. |
| <a name="output_virtual_networking-vmm_domains"></a> [virtual\_networking-vmm\_domains](#output\_virtual\_networking-vmm\_domains) | * vmm\_domain - Identifiers for VMM Domains.  Virtual Networking.<br>* vmm\_domain\_controllers - Identifiers for VMM Controllers.  Virtual Networking => {VMM Doamin} => Controllers: {controller\_name}.<br>* vmm\_domain\_credentials - Identifiers for VMM Domain Credentials.  Virtual Networking => {VMM Doamin}: vCenter Credentials.<br>* vmm\_domain\_vswitch\_policies - Identifiers for VMM Domain Virtual Switch Policies.  Virtual Networking => {VMM Doamin}: vSwitch Policy |
## Resources

| Name | Type |
|------|------|
| [aci_access_generic.access_generic](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_generic) | resource |
| [aci_access_switch_policy_group.switches_leaf_policy_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_switch_policy_group) | resource |
| [aci_attachable_access_entity_profile.attachable_access_entity_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/attachable_access_entity_profile) | resource |
| [aci_cdp_interface_policy.cdp_interface](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/cdp_interface_policy) | resource |
| [aci_error_disable_recovery.error_disabled_recovery](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/error_disable_recovery) | resource |
| [aci_fabric_if_pol.link_level](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/fabric_if_pol) | resource |
| [aci_interface_fc_policy.fibre_channel_interface](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/interface_fc_policy) | resource |
| [aci_l2_interface_policy.l2_interface](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l2_interface_policy) | resource |
| [aci_l3_domain_profile.l3_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l3_domain_profile) | resource |
| [aci_lacp_policy.port_channel](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lacp_policy) | resource |
| [aci_leaf_access_bundle_policy_group.leaf_interfaces_policy_groups_bundle](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_access_bundle_policy_group) | resource |
| [aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_access_port_policy_group) | resource |
| [aci_leaf_breakout_port_group.leaf_interfaces_policy_groups_breakout](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_breakout_port_group) | resource |
| [aci_lldp_interface_policy.lldp_interface](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lldp_interface_policy) | resource |
| [aci_mcp_instance_policy.mcp_instance](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/mcp_instance_policy) | resource |
| [aci_miscabling_protocol_interface_policy.mcp_interface](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/miscabling_protocol_interface_policy) | resource |
| [aci_physical_domain.physical_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/physical_domain) | resource |
| [aci_port_security_policy.port_security](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/port_security_policy) | resource |
| [aci_qos_instance_policy.qos_class](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/qos_instance_policy) | resource |
| [aci_ranges.vlans](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/ranges) | resource |
| [aci_rest_managed.cdp_interface_global_alias](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.dhcp_relay](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.leaf_interfaces_policy_groups_access_global_alias](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.link_level_global_alias](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.lldp_interface_global_alias](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.port_channel_global_alias](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanning_tree_interface_global_alias](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_interface_policy_groups_global_alias](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmm_domain_uplinks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.vmm_uplinks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_spanning_tree_interface_policy.spanning_tree_interface](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spanning_tree_interface_policy) | resource |
| [aci_spine_port_policy_group.spine_interface_policy_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_port_policy_group) | resource |
| [aci_spine_switch_policy_group.switches_spine_policy_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_switch_policy_group) | resource |
| [aci_vlan_pool.vlan_pools](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vlan_pool) | resource |
| [aci_vmm_controller.controllers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_controller) | resource |
| [aci_vmm_credential.credentials](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_credential) | resource |
| [aci_vmm_domain.vmm_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_domain) | resource |
| [aci_vpc_domain_policy.vpc_domain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vpc_domain_policy) | resource |
| [aci_vswitch_policy.vswitch_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vswitch_policy) | resource |
<!-- END_TF_DOCS -->