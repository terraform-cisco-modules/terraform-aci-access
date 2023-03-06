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
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.6.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.6.0 |
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
| <a name="output_l3_domains"></a> [l3\_domains](#output\_l3\_domains) | n/a |
| <a name="output_physical_domains"></a> [physical\_domains](#output\_physical\_domains) | n/a |
| <a name="output_attachable_access_entity_profiles"></a> [attachable\_access\_entity\_profiles](#output\_attachable\_access\_entity\_profiles) | n/a |
| <a name="output_dhcp_relay"></a> [dhcp\_relay](#output\_dhcp\_relay) | n/a |
| <a name="output_error_disabled_recovery_policy"></a> [error\_disabled\_recovery\_policy](#output\_error\_disabled\_recovery\_policy) | n/a |
| <a name="output_mcp_instance_policy"></a> [mcp\_instance\_policy](#output\_mcp\_instance\_policy) | n/a |
| <a name="output_qos_class"></a> [qos\_class](#output\_qos\_class) | n/a |
| <a name="output_leaf_interfaces_policy_groups_access"></a> [leaf\_interfaces\_policy\_groups\_access](#output\_leaf\_interfaces\_policy\_groups\_access) | n/a |
| <a name="output_leaf_interfaces_policy_groups_breakout"></a> [leaf\_interfaces\_policy\_groups\_breakout](#output\_leaf\_interfaces\_policy\_groups\_breakout) | n/a |
| <a name="output_leaf_interfaces_policy_groups_bundle"></a> [leaf\_interfaces\_policy\_groups\_bundle](#output\_leaf\_interfaces\_policy\_groups\_bundle) | n/a |
| <a name="output_cdp_interface"></a> [cdp\_interface](#output\_cdp\_interface) | n/a |
| <a name="output_fibre_channel_interface"></a> [fibre\_channel\_interface](#output\_fibre\_channel\_interface) | n/a |
| <a name="output_l2_interface"></a> [l2\_interface](#output\_l2\_interface) | n/a |
| <a name="output_link_level"></a> [link\_level](#output\_link\_level) | n/a |
| <a name="output_lldp_interface"></a> [lldp\_interface](#output\_lldp\_interface) | n/a |
| <a name="output_mcp_interface"></a> [mcp\_interface](#output\_mcp\_interface) | n/a |
| <a name="output_port_channel"></a> [port\_channel](#output\_port\_channel) | n/a |
| <a name="output_port_security"></a> [port\_security](#output\_port\_security) | n/a |
| <a name="output_spanning_tree_interface"></a> [spanning\_tree\_interface](#output\_spanning\_tree\_interface) | n/a |
| <a name="output_vlan_pools"></a> [vlan\_pools](#output\_vlan\_pools) | n/a |
| <a name="output_spine_interface_policy_groups"></a> [spine\_interface\_policy\_groups](#output\_spine\_interface\_policy\_groups) | n/a |
| <a name="output_switches_leaf_policy_groups"></a> [switches\_leaf\_policy\_groups](#output\_switches\_leaf\_policy\_groups) | n/a |
| <a name="output_switches_spine_policy_groups"></a> [switches\_spine\_policy\_groups](#output\_switches\_spine\_policy\_groups) | n/a |
| <a name="output_vmm_domains"></a> [vmm\_domains](#output\_vmm\_domains) | n/a |
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