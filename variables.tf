/*_____________________________________________________________________________________________________________________

Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "access" {
  description = "Access Model data."
  type        = any
}


/*_____________________________________________________________________________________________________________________

Access Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "access_sensitive" {
  default = {
    mcp_instance_policy_default = {
      key = {}
    }
    virtual_networking = {
      password = {}
    }
  }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    * mcp_instance_policy_default: MisCabling Protocol Instance Settings.
      - key: The key or password used to uniquely identify this configuration object.
    * virtual_networking: ACI to Virtual Infrastructure Integration.
      - password: Username/Password combination to Authenticate to the Virtual Infrastructure.
  EOT
  sensitive   = true
  type = object({
    mcp_instance_policy_default = object({
      key = map(string)
    })
    virtual_networking = object({
      password = map(string)
    })
  })
}
