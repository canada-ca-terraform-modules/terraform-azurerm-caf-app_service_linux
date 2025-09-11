resource "azurerm_dns_txt_record" "validation" {
  for_each = try(var.appServiceLinux.custom_domains, {})

  name = "asuid.${each.key}"
  zone_name = each.value.zone
  resource_group_name =  local.zones[each.value.zone].resource_group_name

  ttl = 60
  record {
    value = azurerm_linux_web_app.webapp.custom_domain_verification_id 
  }
}

locals {
  distinct-cert-names = toset([for name, value in try(var.appServiceLinux.custom_domains, {}): value.certificate_name if try(value.certificate_name, null) != null ])
}

data "azurerm_key_vault_certificate" "custom_cert" {
  for_each = local.distinct-cert-names

  name = each.value
  key_vault_id = var.keyvault.id
}

resource "azurerm_app_service_certificate" "custom_cert" {
  for_each = local.distinct-cert-names

  name = each.value
  resource_group_name = azurerm_linux_web_app.webapp.resource_group_name
  location = var.location

  key_vault_secret_id = data.azurerm_key_vault_certificate.custom_cert[each.key].secret_id
}

resource "azurerm_app_service_custom_hostname_binding" "custom" {
  for_each = try(var.appServiceLinux.custom_domains, {})

  hostname = "${each.key}.${each.value.zone}"

  app_service_name = azurerm_linux_web_app.webapp.name
  resource_group_name =  azurerm_linux_web_app.webapp.resource_group_name

  # certificate_name is optional
  ssl_state = try(each.value.certificate_name, null) != null ? "SniEnabled" : null
  thumbprint = try(data.azurerm_key_vault_certificate.custom_cert[each.value.certificate_name].thumbprint, null)
  
  depends_on = [ azurerm_dns_txt_record.validation ]
}