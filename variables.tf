variable "tags" {
  description = "Maps of tags that will be applied to the resource"
  type = map(string)
  default = {}
}

variable "env" {
  description = "(Required) Env value for the name of the resource"
  type = string
}

variable "group" {
  description = "(Required) Group value for the name of the resource"
  type = string
}

variable "project" {
  description = "(Required) Project value for the name of the resource"
  type = string
}

variable "userDefinedString" {
  description = "(Required) UserDefinedString value for the name of the resource"
  type = string
}

variable "location" {
  description = "Azure location for the resource"
  type = string
  default = "canadacentral"
}

variable "resource_groups" {
  description = "Resouce group object containing a list of resource group in the target project"
  type = any
  default = null
}

variable "subnets" {
  description = "Subnet object containing a list of subnets in the target project"
  type = any
  default = null
}

variable "asp" {
  description = "Object containing a map of name and ID for the App Service Plan in the target subscription"
  type = any
  default = null
}

variable "appServiceLinux" {
  description = "Object containing all parameters for the Linux App Service"
  type = any
  default = {}
}

variable "private_dns_zone_ids" {
  description = "Object containing the private DNS zone IDs of the subscription. Used to configure private endpoints"
  type = any
  default = {}
}

variable "zones" {
  description = "(Optional) The project DNS zones, used to create and validate custom domain entries"
  type = any
  default = {}
}