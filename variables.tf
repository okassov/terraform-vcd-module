terraform {
  experiments = [module_variable_optional_attrs]
}

### Provider variables
variable "vcd_user" {
  type = string
  description = "vCD username for connect"
}

variable "vcd_pass" {
  type = string
  description = "vCD password for connect"
}

variable "vcd_org" {
  type = string
  description = "vCD organization for connect"
}

variable "vcd_vdc" {
  type = string
  description = "vCD VDC for deploy"
}

variable "vcd_url" {
  type = string
  description = "URL address of vCD for connect"
}

variable "vcd_max_retry_timeout" {
  default = 60
  description = "vCD maximum retry timeout for connect"
}

variable "vcd_allow_unverified_ssl" {
  default = false
  description = "Verify SSL certificate or not"
}

variable "vcd_catalog_name" {
  type = string
  description = "Catalog name where template is located"
}

variable "vcd_template_name" {
  type = string
  description = "vApp Template name for deploy"
}

variable "env" {
  type = string
  description = "Environment variable for tagging"

  validation {
    condition = contains(["dev", "stage", "prod", "share"], var.env)
    error_message = "Valid values for env ('dev', 'stage', 'prod', 'share')?"
  }
}

variable "project" {
  type = string
  description = "Project name"
}

variable "role" {
  type = string
  validation {
    condition = contains(["db", "compute", "storage", "infra"], var.role)
    error_message = "Valid values for role ('db', 'compute', 'storage', 'infra')?"
  }
}

variable "virtual_machines" {
  description = "Map of Virtual Machines"
  type = map(object({
    vapp               = string
    memory             = number
    cpu                = number
    network            = string
    network_type       = string
    ip_allocation_mode = string
    ip                 = string
    netmask            = string
    gateway            = string
    dns                = string
    additional_networks = optional(map(object({
      type               = string
      ip_allocation_mode = string
      ip                 = string
    })))
}))
}

variable "data_disk" {
  description = "Additional data disk to VM (Data disk - /dev/sdb)"
  type = map(object({
    size         = number
    unit_number  = number
    bus_number   = number
    profile      = string
    bus_type     = string
    bus_sub_type = string
    })
  )
  default = null
}
