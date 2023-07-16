<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Access Module

A Terraform module to configure ACI Access Policies.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY ACI"

### A comprehensive example using this module is available below:

## [Easy ACI](https://github.com/terraform-cisco-modules/easy-aci-complete)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.9.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | 2.9.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | Access Model data. | `any` | n/a | yes |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `""` | no |
| <a name="input_virtual_networking"></a> [virtual\_networking](#input\_virtual\_networking) | Viritual Networking Model data. | `any` | n/a | yes |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | The Version of this Script. | <pre>list(object(<br>    {<br>      key   = string<br>      value = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "key": "orchestrator",<br>    "value": "terraform:easy-aci:v2.0"<br>  }<br>]</pre> | no |
| <a name="input_controller_type"></a> [controller\_type](#input\_controller\_type) | The Type of Controller for this Site.<br>- apic<br>- ndo | `string` | `"apic"` | no |
| <a name="input_management_epgs"></a> [management\_epgs](#input\_management\_epgs) | The Management EPG's that will be used by the script.<br>- name: Name of the EPG<br>- type: Type of EPG<br>  * inb<br>  * oob | <pre>list(object(<br>    {<br>      name = string<br>      type = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "name": "default",<br>    "type": "oob"<br>  }<br>]</pre> | no |
| <a name="input_mcp_instance_key"></a> [mcp\_instance\_key](#input\_mcp\_instance\_key) | The key or password to uniquely identify the MCP packets within this fabric. | `string` | n/a | yes |
| <a name="input_vmm_password"></a> [vmm\_password](#input\_vmm\_password) | Password for VMM Credentials Policy. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interface"></a> [interface](#output\_interface) | Interface Identifiers<br>  leaf\_interfaces:<br>    policy\_groups<br>      access:   Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Access Port.<br>      breakout: Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => Leaf Breakout Port Group.<br>      bundle:   Fabric => Access Policies => Interfaces => Leaf Interfaces => Policy Groups => [ VPC Interface \| VPC Interface ].<br>  spine\_interfaces:<br>    policy\_groups: Fabric => Access Policies => Interfaces => Spine Interfaces => Policy Groups |
| <a name="output_physical_and_external_domains"></a> [physical\_and\_external\_domains](#output\_physical\_and\_external\_domains) | * l3\_domains - Identifiers for L3 Domains.  Fabric => Access Policies => Physical and External Domains => L3 Domains.<br>* physical\_domains - Identifiers for Physical Domains.  Fabric => Access Policies => Physical and External Domains => Physical Domains. |
| <a name="output_global"></a> [global](#output\_global) | Global Identifiers<br>  attachable\_access\_entity\_profiles: Fabric => Access Policies => Policies => Global => Attachable Access Entity Profiles<br>  dhcp\_relay:                        Fabric => Access Policies => Policies => Global => DHCP Relay<br>  error\_disabled\_recovery\_policy:    Fabric => Access Policies => Policies => Global => Error Disabled Recovery Profiles<br>  mcp\_instance\_policy:               Fabric => Access Policies => Policies => Global => MCP Instance Policy - default<br>  qos\_class:                         Fabric => Access Policies => Policies => Global => QoS Class |
| <a name="output_aaep_to_epgs"></a> [aaep\_to\_epgs](#output\_aaep\_to\_epgs) | n/a |
| <a name="output_policies"></a> [policies](#output\_policies) | Policies Identifiers<br>    interface:<br>      cdp\_interface: Fabric => Access Policies => Policies => Interfaces => CDP Interface<br>      fibre\_channel\_interface: Fabric => Access Policies => Policies => Interfaces => Fibre Channel Interface<br>      l2\_interface: Fabric => Access Policies => Policies => Interfaces => L2 Interface<br>      link\_level: Fabric => Access Policies => Policies => Interfaces => Link Level.<br>      cdp\_interface: Fabric => Access Policies => Policies => Interfaces => LLDP Interface.<br>      cdp\_interface: Fabric => Access Policies => Policies => Interfaces => Port Channel.<br>      cdp\_interface: Fabric => Access Policies => Policies => Interfaces => Port Security.<br>      cdp\_interface: Fabric => Access Policies => Policies => Interfaces => Spanning-Tree Interface. |
| <a name="output_pools"></a> [pools](#output\_pools) | Identifiers for VLAN Pools.  Fabric => Access Policies => Pools => VLAN. |
| <a name="output_switches"></a> [switches](#output\_switches) | Switches Identifiers<br>    leaf\_switches:<br>      policy\_groups: Fabric => Access Policies => Switches => Leaf Switches => Policy Groups<br>    spine\_switches:<br>      policy\_groups: Fabric => Access Policies => Switches => Spine Switches => Policy Groups |
| <a name="output_virtual_networking-vmm_domains"></a> [virtual\_networking-vmm\_domains](#output\_virtual\_networking-vmm\_domains) | * controllers - Identifiers for VMM Controllers.  Virtual Networking => {VMM Doamin} => Controllers: {controller\_name}.<br>* credentials - Identifiers for VMM Domain Credentials.  Virtual Networking => {VMM Doamin}: vCenter Credentials.<br>* vmm\_domains - Identifiers for VMM Domains.  Virtual Networking.<br>* vswitch\_policies - Identifiers for VMM Domain Virtual Switch Policies.  Virtual Networking => {VMM Doamin}: vSwitch Policy |
## Resources

| Name | Type |
|------|------|
| [aci_access_generic.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_generic) | resource |
| [aci_access_switch_policy_group.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_switch_policy_group) | resource |
| [aci_attachable_access_entity_profile.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/attachable_access_entity_profile) | resource |
| [aci_cdp_interface_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/cdp_interface_policy) | resource |
| [aci_error_disable_recovery.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/error_disable_recovery) | resource |
| [aci_fabric_if_pol.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/fabric_if_pol) | resource |
| [aci_interface_fc_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/interface_fc_policy) | resource |
| [aci_l2_interface_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l2_interface_policy) | resource |
| [aci_l3_domain_profile.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l3_domain_profile) | resource |
| [aci_lacp_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lacp_policy) | resource |
| [aci_leaf_access_bundle_policy_group.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_access_bundle_policy_group) | resource |
| [aci_leaf_access_port_policy_group.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_access_port_policy_group) | resource |
| [aci_leaf_breakout_port_group.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_breakout_port_group) | resource |
| [aci_lldp_interface_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lldp_interface_policy) | resource |
| [aci_mcp_instance_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/mcp_instance_policy) | resource |
| [aci_miscabling_protocol_interface_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/miscabling_protocol_interface_policy) | resource |
| [aci_physical_domain.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/physical_domain) | resource |
| [aci_port_security_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/port_security_policy) | resource |
| [aci_qos_instance_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/qos_instance_policy) | resource |
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
| [aci_rest_managed.vpc_domain_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_spanning_tree_interface_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spanning_tree_interface_policy) | resource |
| [aci_spine_port_policy_group.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_port_policy_group) | resource |
| [aci_spine_switch_policy_group.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_switch_policy_group) | resource |
| [aci_vlan_pool.vlan_pools](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vlan_pool) | resource |
| [aci_vmm_controller.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_controller) | resource |
| [aci_vmm_credential.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_credential) | resource |
| [aci_vmm_domain.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vmm_domain) | resource |
| [aci_vswitch_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vswitch_policy) | resource |
<!-- END_TF_DOCS -->