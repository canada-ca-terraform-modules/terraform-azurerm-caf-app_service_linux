resource "azurerm_linux_web_app" "webapp" {
  name                = local.asv-name
  location            = var.location
  resource_group_name = local.resource_group_name
  service_plan_id     = local.asp # This is Required for our setup

  app_settings                                   = local.app_settings
  client_affinity_enabled                        = try(var.appServiceLinux.client_affinity_enabled, null)
  client_certificate_enabled                     = try(var.appServiceLinux.client_certificate_enabled, null)
  client_certificate_mode                        = try(var.appServiceLinux.client_certificate_mode, null)
  client_certificate_exclusion_paths             = try(var.appServiceLinux.client_certificate_exclusion_paths, null)
  enabled                                        = try(var.appServiceLinux.enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.appServiceLinux.ftp_publish_basic_authentication_enabled, false)
  https_only                                     = try(var.appServiceLinux.https_only, true)
  public_network_access_enabled                  = try(var.appServiceLinux.public_network_access_enabled, false)
  key_vault_reference_identity_id                = try(var.appServiceLinux.key_vault_reference_identity_id, null)
  virtual_network_subnet_id                      = local.subnet_id
  vnet_image_pull_enabled                        = try(var.appServiceLinux.vnet_image_pull_enabled, false)
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
    health_check_path                             = try(var.appServiceLinux.site_config.health_check_path, null)
    health_check_eviction_time_in_min             = try(var.appServiceLinux.health_check_eviction_time_in_min, null)
    http2_enabled                                 = try(var.appServiceLinux.site_config.http2_enabled, true)
    ip_restriction_default_action                 = try(var.appServiceLinux.site_config.ip_restriction_default_action, "Allow")
    load_balancing_mode                           = try(var.appServiceLinux.site_config.load_balancing_mode, "LeastRequests")
    local_mysql_enabled                           = try(var.appServiceLinux.site_config.local_mysql_enabled, false)
    managed_pipeline_mode                         = try(var.appServiceLinux.site_config.managed_pipeline_mode, "Integrated")
    minimum_tls_version                           = try(var.appServiceLinux.site_config.minimum_tls_version, "1.2")
    remote_debugging_enabled                      = try(var.appServiceLinux.site_config.remote_debugging_enabled, false)
    remote_debugging_version                      = try(var.appServiceLinux.site_config.remote_debugging_version, "VS2022")
    scm_ip_restriction_default_action             = try(var.appServiceLinux.site_config.scm_ip_restriction_default_action, "Allow")
    scm_minimum_tls_version                       = try(var.appServiceLinux.site_config.scm_minimum_tls_version, "1.2")
    use_32_bit_worker                             = try(var.appServiceLinux.site_config.use_32_bit_worker, true)
    vnet_route_all_enabled                        = try(var.appServiceLinux.site_config.vnet_route_all_enabled, true)
    websockets_enabled                            = try(var.appServiceLinux.site_config.websockets_enabled, false)
    worker_count                                  = try(var.appServiceLinux.site_config.worker_count, null)

    dynamic "application_stack" {
      for_each = try(var.appServiceLinux.site_config.application_stack, null) != null ? [1] : []
      content {
        docker_image_name        = try(var.appServiceLinux.site_config.application_stack.docker_image_name, null)
        docker_registry_url      = try(var.appServiceLinux.site_config.application_stack.docker_registry_url, null)
        docker_registry_username = try(var.appServiceLinux.site_config.application_stack.docker_registry_username, null)
        docker_registry_password = try(var.appServiceLinux.site_config.application_stack.docker_registry_password, null)
        dotnet_version           = try(var.appServiceLinux.site_config.application_stack.dotnet_version, null)
        go_version               = try(var.appServiceLinux.site_config.application_stack.go_version, null)
        java_server              = try(var.appServiceLinux.site_config.application_stack.java_server, null)
        java_server_version      = try(var.appServiceLinux.site_config.application_stack.java_server_version, null)
        java_version             = try(var.appServiceLinux.site_config.application_stack.java_version, null)
        node_version             = try(var.appServiceLinux.site_config.application_stack.node_version, null)
        php_version              = try(var.appServiceLinux.site_config.application_stack.php_version, null)
        python_version           = try(var.appServiceLinux.site_config.application_stack.python_version, null)
        ruby_version             = try(var.appServiceLinux.site_config.application_stack.ruby_version, null)
      }
    }

    dynamic "auto_heal_setting" {
      for_each = try(var.appServiceLinux.site_config.auto_heal_setting, {})
      content {
        dynamic "action" {
          for_each = try(auto_heal_setting.value.action, {})
          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = try(action.value.minimum_process_execution_time, null)
          }
        }
        dynamic "trigger" {
          for_each = try(auto_heal_setting.value.trigger, {})
          content {
            dynamic "requests" {
              for_each = try(trigger.value.requests, {})
              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }
            dynamic "slow_request" {
              for_each = try(trigger.value.slow_request, {})
              content {
                count      = slow_request.value.count
                interval   = slow_request.value.interval
                time_taken = slow_request.value.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = try(trigger.value.slow_request_with_path, {})
              content {
                count      = slow_request_with_path.value.count
                interval   = slow_request_with_path.value.interval
                time_taken = slow_request_with_path.value.time_taken
                path       = try(slow_request_with_path.value.path, null)
              }
            }
            dynamic "status_code" {
              for_each = try(trigger.value.status_code, {})
              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = try(status_code.value.path, null)
                sub_status        = try(status_code.value.sub_status, null)
                win32_status_code = try(status_code.value.win32_status_code, null)
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = try(var.appServiceLinux.site_config.cors, {})
      content {
        allowed_origins     = try(cors.value.allowed_origins, null)
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "ip_restriction" {
      for_each = try(var.appServiceLinux.site_config.ip_restriction, {})
      content {
        action                    = try(ip_restriction.value.action, "Deny")
        ip_address                = try(ip_restriction.value.ip_address, null)
        name                      = try(ip_restriction.key, null)
        priority                  = try(ip_restriction.value.priority, null)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = try(ip_restriction.value.headers, {})
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, null)
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, null)
            x_forwarded_host  = try(headers.value.x_forwarded_host, null)
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = try(var.appServiceLinux.site_config.scm_ip_restriction, {})
      content {
        action                    = try(scm_ip_restriction.value.action, "Deny")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.key, null)
        priority                  = try(scm_ip_restriction.value.priority, null)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(scm_ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = try(scm_ip_restriction.value.headers, {})
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, null)
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, null)
            x_forwarded_host  = try(headers.value.x_forwarded_host, null)
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = try(var.appServiceLinux.auth_settings, {})
    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = try(auth_settings.value.additional_login_parameters, null)
      allowed_external_redirect_urls = try(auth_settings.value.allowed_external_redirect_urls, null)
      default_provider               = try(auth_settings.value.default_provider, null)
      issuer                         = try(auth_settings.value.issuer, null)
      runtime_version                = try(auth_settings.value.runtime_version, null)
      token_refresh_extension_hours  = try(auth_settings.value.token_refresh_extension_hours, 72)
      token_store_enabled            = try(auth_settings.value.token_store_enabled, false)
      unauthenticated_client_action  = try(auth_settings.value.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = try(auth_settings.value.active_directory, {})
        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = try(active_directory.value.allowed_audiences, null)
          client_secret              = try(active_directory.value.client_secret, null)
          client_secret_setting_name = try(active_directory.value.client_secret_setting_name, null)
        }
      }
      dynamic "facebook" {
        for_each = try(auth_settings.value.facebook, {})
        content {
          app_id                  = facebook.value.app_id
          app_secret              = try(facebook.value.app_secret, null)
          app_secret_setting_name = try(facebook.value.app_secret_setting_name, null)
          oauth_scopes            = try(facebook.value.oauth_scopes, null)
        }
      }
      dynamic "github" {
        for_each = try(auth_settings.value.github, {})
        content {
          client_id                  = github.value.client_id
          client_secret              = try(github.value.client_secret, null)
          client_secret_setting_name = try(github.value.client_secret_setting_name, null)
          oauth_scopes               = try(github.value.oauth_scopes, null)
        }
      }
      dynamic "google" {
        for_each = try(auth_settings.value.google, {})
        content {
          client_id                  = google.value.client_id
          client_secret              = try(google.value.client_secret, null)
          client_secret_setting_name = try(google.value.client_secret_setting_name, null)
          oauth_scopes               = try(google.value.oauth_scopes, null)
        }
      }
      dynamic "microsoft" {
        for_each = try(auth_settings.value.microsoft, {})
        content {
          client_id                  = microsoft.value.client_id
          client_secret              = try(microsoft.value.client_secret, null)
          client_secret_setting_name = try(microsoft.value.client_secret_setting_name, null)
          oauth_scopes               = try(microsoft.value.oauth_scopes, null)
        }
      }
      dynamic "twitter" {
        for_each = try(auth_settings.value.twitter, {})
        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = try(twitter.value.consumer_secret, null)
          consumer_secret_setting_name = try(twitter.value.consumer_secret_setting_name, null)
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = try(var.appServiceLinux.auth_settings_v2, {})
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, null)
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, null)
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      login {
        logout_endpoint                   = try(auth_settings_v2.value.login.logout_endpoint, null)
        token_store_enabled               = try(auth_settings_v2.value.login.token_store_enabled, false)
        token_refresh_extension_time      = try(auth_settings_v2.value.login.token_refresh_extension_time, 72)
        token_store_path                  = try(auth_settings_v2.value.login.token_store_path, null)
        token_store_sas_setting_name      = try(auth_settings_v2.value.login.token_store_sas_setting_name, null)
        preserve_url_fragments_for_logins = try(auth_settings_v2.value.login.preserve_url_fragments_for_logins, false)
        allowed_external_redirect_urls    = try(auth_settings_v2.value.login.allowed_external_redirect_urls, null)
        cookie_expiration_convention      = try(auth_settings_v2.value.login.cookie_expiration_convention, null)
        cookie_expiration_time            = try(auth_settings_v2.value.login.cookie_expiration_time, "08:00:00")
        validate_nonce                    = try(auth_settings_v2.value.login.validate_nonce, true)
        nonce_expiration_time             = try(auth_settings_v2.value.login.nonce_expiration_time, "00:05:00")
      }

      dynamic "apple_v2" {
        for_each = try(auth_settings_v2.value.apple_v2, {})
        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = try(apple_v2.value.login_scopes, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = try(auth_settings_v2.value.active_directory_v2, {})
        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = try(auth_settings_v2.value.azure_static_web_app_v2, {})
        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(auth_settings_v2.value.custom_oidc_v2, {})
        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = try(auth_settings_v2.value.facebook_v2, {})
        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = try(auth_settings_v2.value.github_v2, {})
        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = try(auth_settings_v2.value.google_v2, {})
        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = try(auth_settings_v2.value.microsoft_v2, {})
        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = try(auth_settings_v2.value.twitter_v2, {})
        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = try(var.appServiceLinux.backup, {})
    content {
      name                = backup.key
      storage_account_url = backup.value.storage_account_url
      enabled             = try(backup.value.enabled, true)

      schedule {
        frequency_interval       = backup.value.schedule.frequency_interval
        frequency_unit           = backup.value.schedule.frequency_unit
        keep_at_least_one_backup = try(backup.value.schedule.keep_at_least_one_backup, false)
        retention_period_days    = try(backup.value.schedule.retention_period_days, 30)
        start_time               = try(backup.value.schedule.start_time, null)
      }
    }
  }

  dynamic "connection_string" {
    for_each = try(var.appServiceLinux.connection_string, {})
    content {
      name  = connection_string.key
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = try(var.appServiceLinux.identity, null) != null ? [1] : []
    content {
      type         = var.appServiceLinux.identity.type
      identity_ids = try(var.appServiceLinux.identity.identity_ids, null)
    }
  }

  dynamic "logs" {
    for_each = try(var.appServiceLinux.logs, {})
    content {
      detailed_error_messages = try(logs.value.detailed_error_messages, true)
      failed_request_tracing  = try(logs.value.failed_request_tracing, true)

      dynamic "application_logs" {
        for_each = try(logs.value.application_logs, {})
        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = try(application_logs.value.azure_blob_storage, {})
            content {
              level             = azure_blob_storage.value.level
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = try(logs.value.http_logs, {})
        content {
          dynamic "azure_blob_storage" {
            for_each = try(http_logs.value.azure_blob_storage, {})
            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }

          dynamic "file_system" {
            for_each = try(http_logs.value.file_system, {})
            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = try(var.appServiceLinux.storage_account, {})
    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

  dynamic "sticky_settings" {
    for_each = try(var.appServiceLinux.sticky_settings, null) != null || try(var.appServiceLinux.inject_root_cert, false) ? [
      {
        app_setting_names = (
          try(var.appServiceLinux.inject_root_cert, false) 
            ? concat(try(var.appServiceLinux.sticky_settings.app_setting_names, []), ["WEBSITE_LOAD_ROOT_CERTIFICATES"]) 
            : try(var.appServiceLinux.sticky_settings.app_setting_names, null)
        )
        connection_string_names = try(var.appServiceLinux.sticky_settings.connection_string_names, null)
      }] : []
    
    content {
      app_setting_names = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }
}

resource "azurerm_app_service_public_certificate" "internal-ca" {
  count                = try(var.appServiceLinux.inject_root_cert, false) ? 1 : 0
  app_service_name     = azurerm_linux_web_app.webapp.name
  resource_group_name  = local.resource_group_name
  certificate_name     = "GOC-GDC-ROOT-A"
  certificate_location = "Unknown"
  blob                 = data.http.cert[0].response_body_base64
}


module "private_endpoint" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint.git?ref=v1.0.2"
  for_each = try(var.appServiceLinux.private_endpoint, {})

  name                           = "${local.asv-name}-${each.key}"
  location                       = var.location
  resource_groups                = var.resource_groups
  subnets                        = var.subnets
  private_connection_resource_id = azurerm_linux_web_app.webapp.id
  private_endpoint               = each.value
  private_dns_zone_ids           = var.private_dns_zone_ids
  tags                           = var.tags
}

