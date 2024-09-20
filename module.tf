resource "azurerm_linux_web_app" "webapp" {
  name                = local.asv-name
  location            = var.location
  resource_group_name = local.resource_group_name
  service_plan_id     = local.asp == null ? data.azurerm_service_plan.asp[0].id : local.asp # This is Required for our setup

  app_settings                                   = try(var.appServiceLinux.app_settings, {})
  client_affinity_enabled                        = try(var.appServiceLinux.client_affinity_enabled, null)
  client_certificate_enabled                     = try(var.appServiceLinux.client_certificate_enabled, null)
  client_certificate_mode                        = try(var.appServiceLinux.client_certificate_mode, null)
  client_certificate_exclusion_paths             = try(var.appServiceLinux.client_certificate_exclusion_paths, null)
  enabled                                        = try(var.appServiceLinux.enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.appServiceLinux.ftp_publish_basic_authentication_enabled, true)
  https_only                                     = try(var.appServiceLinux.https_only, false)
  public_network_access_enabled                  = try(var.appServiceLinux.public_network_access_enabled, false)
  key_vault_reference_identity_id                = try(var.appServiceLinux.key_vault_reference_identity_id, null)
  virtual_network_subnet_id                      = try(var.appServiceLinux.virtual_network_subnet_id, null)
  webdeploy_publish_basic_authentication_enabled = try(var.appServiceLinux.webdeploy_publish_basic_authentication_enabled, null)
  zip_deploy_file                                = try(var.appServiceLinux.zip_deploy_file, null)

  tags = merge(var.tags, try(var.appServiceLinux.tags, {}))


  site_config {
    always_on                                     = try(var.appServiceLinux.site_config.always_on, true)
    api_definition_url                            = try(var.appServiceLinux.site_config.api_definition_url, null)
    api_management_api_id                         = try(var.appServiceLinux.site_config.api_management_api_id, null)
    app_command_line                              = try(var.appServiceLinux.site_config.app_command_line, null)
    container_registry_managed_identity_client_id = try(var.appServiceLinux.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.appServiceLinux.site_config.container_registry_use_managed_identity, null)
    default_documents                             = try(var.appServiceLinux.site_config.default_documents, null)
    ftps_state                                    = try(var.appServiceLinux.site_config.ftps_state, "Disabled")
    health_check_path                             = try(var.appServiceLinux.site_config.health_check_path,  null)
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
        docker_image_name        = try(application_stack.docker_image_name, null)
        docker_registry_url      = try(application_stack.docker_registry_url, null)
        docker_registry_username = try(application_stack.docker_registry_username, null)
        docker_registry_password = try(application_stack.docker_registry_password, null)
        dotnet_version           = try(application_stack.dotnet_version, null)
        go_version               = try(application_stack.go_version, null)
        java_server              = try(application_stack.java_server, null)
        java_server_version      = try(application_stack.java_server_version, null)
        java_version             = try(application_stack.java_version, null)
        node_version             = try(application_stack.node_version, null)
        php_version              = try(application_stack.php_version, null)
        python_version           = try(application_stack.python_version, null)
        ruby_version             = try(application_stack.ruby_version, null)
      }
    }

    dynamic "auto_heal_setting" {
      for_each = try(var.appServiceLinux.site_config.auto_heal_setting, null) != null ? [1] : []
      content {
        dynamic "action" {
          for_each = try(auto_heal_setting.action, null) != null ? [1] : []
          content {
            action_type                    = auto_heal_setting.action.action_type
            minimum_process_execution_time = try(auto_heal_setting.action.minimum_process_execution_time, null)
          }
        }
        dynamic "trigger" {
          for_each = try(var.appServiceLinux.site_config.auto_heal_setting.trigger, null) != null ? [1] : []
          content {
            dynamic "requests" {
              for_each = try(var.appServiceLinux.site_config.auto_heal_setting.trigger.requests, null) != null ? [1] : []
              content {
                count    = trigger.requests.worker_count
                interval = trigger.requests.interval
              }
            }
            dynamic "slow_request" {
              for_each = try(var.appServiceLinux.site_config.auto_heal_setting.trigger.slow_request, null) != null ? [1] : []
              content {
                count      = trigger.slow_request.count
                interval   = trigger.slow_request.interval
                time_taken = trigger.slow_request.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = try(var.appServiceLinux.site_config.auto_heal_setting.trigger.slow_request_with_path, null) != null ? [1] : []
              content {
                count      = trigger.slow_request_with_path.count
                interval   = trigger.slow_request_with_path.interval
                time_taken = trigger.slow_request_with_path.time_taken
                path       = try(trigger.slow_request_with_path.path, null)
              }
            }
            dynamic "status_code" {
              for_each = try(var.appServiceLinux.site_config.auto_heal_setting.trigger.status_code, null) != null ? [1] : []
              content {
                count             = trigger.status_code.count
                interval          = trigger.status_code.interval
                status_code_range = trigger.status_code.status_code_range
                path              = try(trigger.status_code.path, null)
                sub_status        = try(trigger.status_code.sub_status, null)
                win32_status_code = try(trigger.status_code.win32_status_code, null)
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = try(var.appServiceLinux.site_config.cors, null) != null ? [1] : []
      content {
        allowed_origins     = try(cors.allowed_origins, null)
        support_credentials = try(cors.support_credentials, false)
      }
    }

    dynamic "ip_restriction" {
      for_each = try(var.appServiceLinux.site_config.ip_restriction, null) != null ? [1] : []
      content {
        action                    = try(ip_restriction.action, "Deny")
        ip_address                = try(ip_restriction.ip_address, null)
        name                      = try(ip_restriction.name, null)
        priority                  = try(ip_restriction.priority, null)
        service_tag               = try(ip_restriction.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.virtual_network_subnet_id, null)
        description               = try(ip_restriction.description, null)

        dynamic "headers" {
          for_each = try(ip_restriction.headers, null) != null ? [1] : []
          content {
            x_azure_fdid      = try(headers.x_azure_fdid, null)
            x_fd_health_probe = try(headers.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.x_forwarded_for, null)
            x_forwarded_host  = try(headers.x_forwarded_host, null)
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = try(var.appServiceLinux.site_config.scm_ip_restriction, null) != null ? [1] : []
      content {
        action                    = try(ip_restriction.action, "Deny")
        ip_address                = try(ip_restriction.ip_address, null)
        name                      = try(ip_restriction.name, null)
        priority                  = try(ip_restriction.priority, null)
        service_tag               = try(ip_restriction.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.virtual_network_subnet_id, null)
        description               = try(ip_restriction.description, null)

        dynamic "headers" {
          for_each = try(ip_restriction.headers, null) != null ? [1] : []
          content {
            x_azure_fdid      = try(headers.x_azure_fdid, null)
            x_fd_health_probe = try(headers.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.x_forwarded_for, null)
            x_forwarded_host  = try(headers.x_forwarded_host, null)
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = try(var.appServiceLinux.auth_settings, null) != null ? [1] : []
    content {
      enabled = auth_settings.enabled
      additional_login_parameters = try(auth_settings.additional_login_parameters, null)
      allowed_external_redirect_urls = try(auth_settings.allowed_external_redirect_urls,null)
      default_provider = try(auth_settings.default_provider, null)
      issuer = try(auth_settings.issuer, null)
      runtime_version = try(auth_settings.runtime_version, null)
      token_refresh_extension_hours = try(auth_settings.token_refresh_extension_hours, 72)
      token_store_enabled = try(auth_settings.token_store_enabled, false)
      unauthenticated_client_action = try(auth_settings.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = try(auth_settings.active_directory, null) != null ? [1] : []
        content {
          client_id = active_directory.client_id
          allowed_audiences = try(active_directory.allowed_audiences, null)
          client_secret = try(active_directory.client_secret, null)
          client_secret_setting_name = try(active_directory.client_secret_setting_name, null)
        }
      }
      dynamic "facebook" {
        for_each = try(auth_settings.facebook, null) != null ? [1] : []
        content {
          app_id = facebook.app_id
          app_secret = try(facebook.app_secret, null)
          app_secret_setting_name = try(facebook.app_secret_setting_name, null)
          oauth_scopes = try(facebook.oauth_scopes, null)
        }
      }
      dynamic "github" {
        for_each = try(auth_settings.github, null)
        content {
          client_id = github.client_id
          client_secret = try(github.client_secret, null)
          client_secret_setting_name = try(github.client_secret_setting_name, null)
          oauth_scopes = try(github.oauth_scopes, null)
        }  
      }
      dynamic "google" {
        for_each = try(auth_settings.google, null)
        content {
          client_id = google.client_id
          client_secret = try(google.client_secret, null)
          client_secret_setting_name = try(google.client_secret_setting_name, null)
          oauth_scopes = try(google.oauth_scopes, null)
        }
      }
      dynamic "microsoft" {
        for_each = try(auth_settings.microsoft, null)
        content {
          client_id = microsoft.client_id
          client_secret = try(microsoft.client_secret, null)
          client_secret_setting_name = try(microsoft.client_secret_setting_name, null)
          oauth_scopes = try(microsoft.oauth_scopes, null)
        }
      }
      dynamic "twitter" {
        for_each = try(auth_settings.twitter, null)
        content {
          consumer_key = twitter.consumer_key
          consumer_secret = try(twitter.consumer_secret, null)
          consumer_secret_setting_name = try(twitter.consumer_secret_setting_name, null)
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
