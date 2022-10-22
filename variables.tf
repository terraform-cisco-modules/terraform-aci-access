#__________________________________________________________________
#
# Model Data and policy from domains and pools
#__________________________________________________________________

variable "model" {
  description = "Model data."
  type        = any
}


variable "apic_version" {
  default     = ""
  description = "The Version of ACI Running in the Environment."
  type        = string
}


/*_____________________________________________________________________________________________________________________

Global Shared Variables
_______________________________________________________________________________________________________________________
*/


variable "annotation" {
  default     = "orchestrator:terraform:easy-aci-v2.0"
  description = "The Version of this Script."
  type        = string
}

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
variable "vmm_password_1" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_2" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_3" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_4" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_5" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}
