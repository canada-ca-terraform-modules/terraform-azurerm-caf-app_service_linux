resource "azurerm_dns_txt_record" "validation" {
  for_each = try(var.appServiceLinux.custom_domains, {})

  name = "asuid.${each.key}"
  zone_name = each.value.zone
  resource_group_name =  local.zones[each.value.zone].resource_group_name

  ttl = 60
  record {
    value = azurerm_linux_web_app.webapp.custom_domain_verification_id 
  }

  tags = var.tags
}

locals {
  distinct-cert-names = toset([for name, value in try(var.appServiceLinux.custom_domains, {}): value.certificate_name if try(value.certificate_name, null) != null ])
}

data "azurerm_app_service_certificate" "custom_cert" {
  for_each = local.distinct-cert-names

  name = each.value
  resource_group_name = local.resource_group_name
}

resource "azurerm_app_service_custom_hostname_binding" "custom" {
  for_each = try(var.appServiceLinux.custom_domains, {})

  hostname = "${each.key}.${try(each.value.domain_name, each.value.zone)}"

  app_service_name = azurerm_linux_web_app.webapp.name
  resource_group_name =  azurerm_linux_web_app.webapp.resource_group_name

  # certificate_name is optional
  ssl_state = try(each.value.certificate_name, null) != null ? "SniEnabled" : null
  thumbprint = try(data.azurerm_app_service_certificate.custom_cert[each.value.certificate_name].thumbprint, null)
  
  depends_on = [ azurerm_dns_txt_record.validation ]
}