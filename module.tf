resource "azurerm_linux_web_app" "webapp" {
  name                = local.asv-name
  location            = var.location
  resource_group_name = local.resource_group_name
  service_plan_id     = local.asp == null ? data.azurerm_app_service_environment_v3.ase[0].id : local.asp # This is Required for our setup

  site_config {
    always_on                                     = try(var.appServiceLinux.site_config.always_on, true)
    api_definition_url                            = try(var.appServiceLinux.site_config.api_definition_url, null)
    api_management_api_id                         = try(var.appServiceLinux.site_config.api_management_api_id, null)
    app_command_line                              = try(var.appServiceLinux.site_config.app_command_line, null)
    container_registry_managed_identity_client_id = try(var.appServiceLinux.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.appServiceLinux.site_config.container_registry_use_managed_identity, null)
    default_documents                             = try(var.appServiceLinux.site_config.default_documents, ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php"])
    ftps_state                                    = try(var.appServiceLinux.site_config.ftps_state, "Disabled")
    health_check_path                             = try(var.appServiceLinux.site_config.health_check_path, null)
    health_check_eviction_time_in_min             = try(var.appServiceLinux.health_check_eviction_time_in_min, null)
    http2_enabled                                 = try(var.appServiceLinux.site_config.http2_enabled, true)
    ip_restriction_default_action                 = try(var.appServiceLinux.site_config.ip_restriction_default_action, "Deny")
    load_balancing_mode                           = try(var.appServiceLinux.site_config.load_balancing_mode, "LeastRequests")
    local_mysql_enabled                           = try(var.appServiceLinux.site_config.local_mysql_enabled, false)
    managed_pipeline_mode                         = try(var.appServiceLinux.site_config.managed_pipeline_mode, "Integrated")
    minimum_tls_version                           = try(var.appServiceLinux.site_config.minimum_tls_version, "1.2")
    remote_debugging_enabled                      = try(var.appServiceLinux.site_config.remote_debugging_enabled, false)
    remote_debugging_version                      = try(var.appServiceLinux.site_config.remote_debugging_version, "VS2022")
    scm_ip_restriction_default_action             = try(var.appServiceLinux.site_config.scm_ip_restriction_default_action, "Deny")
    scm_minimum_tls_version                       = try(var.appServiceLinux.site_config.scm_minimum_tls_version, "1.2")
    use_32_bit_worker                             = try(var.appServiceLinux.site_config.use_32_bit_worker, true)
    vnet_route_all_enabled                        = try(var.appServiceLinux.site_config.vnet_route_all_enabled, false)
    websockets_enabled                            = try(var.appServiceLinux.site_config.websockets_enabled, false)
    worker_count                                  = try(var.appServiceLinux.site_config.worker_count, null)

    dynamic "application_stack" {
      for_each = try(var.appServiceLinux.site_config.application_stack, null) != null ? [1] : []
      content {
        docker_image_name = try(var.appServiceLinux.site_config.application_stack.docker_image_name, null)
        docker_registry_url = try(var.appServiceLinux.site_config.application_stack.docker_registry_url, null)
        docker_registry_username = try(var.appServiceLinux.site_config.application_stack.docker_registry_username, null)
        docker_registry_password = try(var.appServiceLinux.site_config.application_stack.docker_registry_password, null)
        dotnet_version = try(var.appServiceLinux.site_config.application_stack.dotnet_version, null)
        go_version = try(var.appServiceLinux.site_config.application_stack.go_version, null)
        java_server = try(var.appServiceLinux.site_config.application_stack.java_server, null)
        java_server_version = try(var.appServiceLinux.site_config.application_stack.java_server_version, null)
        java_version = try(var.appServiceLinux.site_config.application_stack.java_version, null)
        node_version = try(var.appServiceLinux.site_config.application_stack.node_version, null)
        php_version = try(var.appServiceLinux.site_config.application_stack.php_version, null)
        python_version = try(var.appServiceLinux.site_config.application_stack.python_version, null)
        ruby_version = try(var.appServiceLinux.site_config.application_stack.ruby_version, null)
      }
    }

    dynamic "auto_heal_setting" {
      for_each = try(var.appServiceLinux.site_config.auto_heal_setting, null) != null ? [1] : []
      content {
        dynamic "action" {
          for_each = try(var.appServiceLinux.site_config.auto_heal_setting.action, null) != null ? [1] : []
          content {
            action_type = var.appServiceLinux.site_config.auto_heal_setting.action.action_type
            minimum_process_execution_time = try(var.appServiceLinux.site_config.action.minimum_process_execution_time, null)
          }
        }
        dynamic "trigger" {
          for_each = try(var.appServiceLinux.site_config.auto_heal_setting.trigger, null) != null ? [1] : []
          content {
            dynamic "requests" {
              for_each = try(var.appServiceLinux.site_config.auto_heal_setting.trigger.requests, null) != null ? [1] : []
              content {
                count = var.appServiceLinux.site_config.auto_heal_setting.trigger.requests.worker_count
                interval = trigger.requests.interval
              }
            }
            dynamic "slow_request" {
              
            }
          }
        }
      }
    }
  }
}

data "azurerm_service_plan" "asp" {
  count               = local.asp == null ? 1 : 0
  name                = replace("${var.env}-${var.group}-${var.project}-${var.appServiceLinux.asp.name}-asp", "/[//\"'\\[\\]:|<>+=;,?*@&]/", "")
  resource_group_name = local.asp_rg
}
