variable "appServiceLinux" {
  default = {}
}

module "appServiceLinux" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_linux.git?ref=v1.0.4"
  for_each = var.appServiceLinux

  userDefinedString = each.key
  env = var.env
  group = var.group
  project = var.project
  resource_groups = local.resource_groups_all
  subnets = local.subnets
  appServiceLinux = each.value
  asp = local.asp_id
  private_dns_zone_ids = local.Project-dns-zone
  keyvault = local.Project-kv
  zones = local.zones
  tags = var.tags
}
