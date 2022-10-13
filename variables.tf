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
