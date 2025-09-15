<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint.git | v1.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_custom_hostname_binding.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.hostname](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_public_certificate.internal-ca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_public_certificate) | resource |
| [azurerm_dns_txt_record.validation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |
| [azurerm_linux_web_app.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_app_service_certificate.custom_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/app_service_certificate) | data source |
| [http_http.cert](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appServiceLinux"></a> [appServiceLinux](#input\_appServiceLinux) | Object containing all parameters for the Linux App Service | `any` | `{}` | no |
| <a name="input_asp"></a> [asp](#input\_asp) | Object containing a map of name and ID for the App Service Plan in the target subscription | `any` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) Env value for the name of the resource | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | (Required) Group value for the name of the resource | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the resource | `string` | `"canadacentral"` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | Object containing the private DNS zone IDs of the subscription. Used to configure private endpoints | `any` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Project value for the name of the resource | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Resouce group object containing a list of resource group in the target project | `any` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet object containing a list of subnets in the target project | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Maps of tags that will be applied to the resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) UserDefinedString value for the name of the resource | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) The project DNS zones, used to create and validate custom domain entries | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appServiceLinux-object"></a> [appServiceLinux-object](#output\_appServiceLinux-object) | Outputs the entire App Service object |
| <a name="output_id"></a> [id](#output\_id) | Outputs the ID of the App Service |
| <a name="output_name"></a> [name](#output\_name) | Outputs the name of the App Service |
<!-- END_TF_DOCS -->