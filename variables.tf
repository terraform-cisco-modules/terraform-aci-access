#__________________________________________________________________
#
# Model Data and policy from domains and pools
#__________________________________________________________________

variable "access" {
  description = "Access Model data."
  type        = any
}


variable "apic_version" {
  default     = ""
  description = "The Version of ACI Running in the Environment."
  type        = string
}


variable "virtual_networking" {
  description = "Viritual Networking Model data."
  type        = any
}


/*_____________________________________________________________________________________________________________________

Global Shared Variables
_______________________________________________________________________________________________________________________
*/


variable "annotations" {
  default = [
    {
      key   = "orchestrator"
      value = "terraform:easy-aci:v2.0"
    }
  ]
  description = "The Version of this Script."
  type = list(object(
    {
      key   = string
      value = string
    }
  ))
}

variable "controller_type" {
  default     = "apic"
  description = <<-EOT
    The Type of Controller for this Site.
    - apic
    - ndo
  EOT
  type        = string
}

variable "management_epgs" {
  default = [
    {
      name = "default"
      type = "oob"
    }
  ]
  description = <<-EOT
    The Management EPG's that will be used by the script.
    - name: Name of the EPG
    - type: Type of EPG
      * inb
      * oob
  EOT
  type = list(object(
    {
      name = string
      type = string
    }
  ))
}


/*_____________________________________________________________________________________________________________________

Access > Policies > Global > MCP Instance Policy — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "mcp_instance_key" {
  description = "The key or password to uniquely identify the MCP packets within this fabric."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Virtual Networking > {switch_provider} > {domain_name} > Credentials — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "vmm_password" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}
