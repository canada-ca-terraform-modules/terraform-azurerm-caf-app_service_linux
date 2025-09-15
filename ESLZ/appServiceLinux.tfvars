appServiceLinux = {
  test = {
    resource_group                = "Project"
    asp                           = "name"
    enabled                       = true
    https_only                    = true
    public_network_access_enabled = false
    inject_root_cert = false

    # Custom domain names for the app service
    # key is the name of the dns record (without the domain name)
    custom_domains = {
      test = {
        # This example would be for FQDN test.project.c.ent.cloud-nuage.canada.ca
        zone = "project.c.ent.cloud-nuage.canada.ca"

        # no certificate will be bound to the name, so the default certificate (*.azurewebsites.net) will be used
      }
      test1 = {
        # the name of the zone in the project-managed dns zones, for the creation of txt validation records
        zone = "project.c.ent.cloud-nuage.canada.ca"

        # name of the certificate in the project Key Vault that is valid for the custom FQDN
        certificate_name = "project-c-ent-cloud-nuage-canada-ca-pfx"
      }
      external-dns = {
        # this example would be for FQDN external-dns.some-department.gc.ca

        # the name of the zone in the project-managed dns zones, for the creation of txt validation records
        zone = "project.c.ent.cloud-nuage.canada.ca"

        # optional, the domain name, in the case the custom domain is not project-managed
        # The CNAME record in the other zone must already be created and pointing to our managed zone
        # like asuid.external-dns CNAME asuid.external-dns.project.c.ent.cloud-nuage.canada.ca
        domain_name = "some-department.gc.ca"

        # name of the certificate that is valid for the custom FQDN
        certificate_name = "external-some-department-gc-ca-pfx"
      }
    }

    # client_affinity_enabled                        = true
    # client_certificated_enabled                    = false
    # client_certificate_mode                        = "Required"
    # client_certificate_exclusion_paths             = ["/path1", "/path2"]
    # ftp_publish_basic_authentication_enabled       = true
    # key_vault_reference_identity_id                = "Your Key Vault Identity ID"
    # virtual_network_subnet_id                      = "Your VNet Subnet ID"
    # webdeploy_publish_basic_authentication_enabled = true 
    # zip_deploy_file                                = "path/to/your/deployment.zip"

    # Optional: Uncomment to set Custom domain names for the app service
    # custom_hostname_binding = ["example.com"]

    # Optional: Uncomment and set any key value pairs
    # app_settings = {}

    # Required: The block can be empty but must be present
    site_config = {
      always_on           = true
      # default_documents   = ["index.html", "index.php"]
      http2_enabled       = true
      minimum_tls_version = "1.2"
      # ftps_state          = "Disabled"
      # api_definition_url                            = "URL to your API definition"
      # api_management_api_id                         = "Your API Management API ID"
      # app_command_line                              = "Your command line to start the app"
      # container_registry_managed_identity_client_id = "Your Container Registry Managed Identity Client ID"
      # container_registry_use_managed_identity       = true
      # health_check_path                             = "/health"
      # health_check_eviction_time_in_min             = 5
      # ip_restriction_default_action                 = "Allow"
      # load_balancing_mode                           = "LeastRequests"
      # local_mysql_enabled                           = true
      # managed_pipeline_mode                         = "Integrated"
      # remote_debugging_enabled                      = true
      # remote_debugging_version                      = "VS2019"
      # scm_ip_restriction_default_action             = "Allow"
      # scm_minimum_tls_version                       = "1.2"
      # use_32_bit_worker                             = true
      # vnet_route_all_enabled                        = true
      # websockets_enabled                            = fals
      # worker_count                                  = 1

      private_endpoint = {
        asv = {                                                          # Key defines the userDefinedstring
          resource_group       = "Project"                                # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
          subnet               = "OZ"                                     # Required: Subnet name, i.e OZ,MAZ, etc, or the subnet ID
          subresource_names    = ["sites"]                                 # Required: Even if it's a list, only one resource is allowed for most first party Azure resource. It's a terraform requirement. See: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource for list of subresrouce
          is_manual_connection = false                                    # Optional: Possible values: true, false. Default: true
          # local_dns_zone       = "privatelink.blob.core.windows.net"    # Optional: Name of the local DNS zone for the private endpoint. To change this value, you must taint the associated resource
        }
      }

      # Optional: Uncomment to set any of these settings
      # application_stack = {
      #   docker_image_name        = "Your Docker Image Name"
      #   docker_registry_url      = "Your Docker Registry URL"
      #   docker_registry_username = "Your Docker Registry Username"
      #   docker_registry_password = "Your Docker Registry Password"
      #   dotnet_version           = "v8.0"
      #   go_version               = "1.19"
      #   java_server              = "Your Java Server Type"
      #   java_server_version      = "Your Java Server Version"
      #   java_version             = "Your Java Version"
      #   node_version             = "20-lts"
      #   php_version              = "8.3"
      #   python_version           = "3.9"
      #   ruby_version             = "2.7"
      # }

      # Optional: Uncomment block to set auto heal settings
      # auto_heal_setting = [{
      #   action = [{
      #     action_type                    = "Recycle"
      #     minimum_process_execution_time = "01:00:00"
      #   }]

      #   trigger = [{
      #     requests = [{
      #       count    = 2
      #       interval = "00:13:00"
      #     }]

      #     slow_request = [{
      #       count      = 3
      #       interval   = "00:30:00"
      #       time_taken = "00:05:00"
      #     }]

      #     slow_request_with_path = [{
      #       count = 3
      #       interval   = "00:30:00"
      #       time_taken = "00:05:00"
      #       path = ""
      #     }]

      #     status_code = [{
      #       count             = 5
      #       interval          = "00:05:00"
      #       status_code_range = "400-499"
      #     }]
      #   }]
      # }]

      # Optional: Uncomment to set CORS block
      # cors = [{
      #   allowed_origins     = ""
      #   support_credentials = false
      # }]

      # Optional: Uncomment to set one or multiple ip rules
      # ip_restriction = {
      #   "Name" = {
      #     action                    = "Deny"
      #     ip_address                = ""
      #     priority                  = 200
      #     service_tag               = ""
      #     virtual_network_subnet_id = ""
      #     description               = ""
      #     headers = [{
      #       x_azure_fdid      = "Your Azure Front Door ID"
      #       x_fd_health_probe = "Your Front Door Health Probe Value"
      #       x_forwarded_for   = "Your Forwarded For Value"
      #       x_forwarded_host  = "Your Forwarded Host Value"
      #     }]
      #   }
      # }

      # Optional: Uncomment to set one or multiple scm ip rules
      # scm_ip_restriction = {
      #   "Name" = {
      #     action                    = "Deny"
      #     ip_address                = ""
      #     priority                  = 200
      #     service_tag               = ""
      #     virtual_network_subnet_id = ""
      #     description               = ""
      #     headers = [{
      #       x_azure_fdid      = "Your Azure Front Door ID"
      #       x_fd_health_probe = "Your Front Door Health Probe Value"
      #       x_forwarded_for   = "Your Forwarded For Value"
      #       x_forwarded_host  = "Your Forwarded Host Value"
      #     }]
      #   }
      # }
    }



    # Optional: Uncomment to set auth settings. All sub blocks are also optional and may be ommitted
    # auth_settings = [{
    #   enabled                        = true
    #   additional_login_parameters    = ["key1=value1"]
    #   allowed_external_redirect_urls = ["https://redirect1.example.com", "https://redirect2.example.com"]
    #   default_provider               = ""
    #   issuer                         = "https://issuer.example.com"
    #   runtime_version                = "1.0.0"
    #   token_refresh_extension_hours  = 72
    #   token_store_enabled            = false
    #   unauthenticated_client_action  = "RedirectToLoginPage"

    #   active_directory = [{
    #     client_id                  = "Your Active Directory Client ID"
    #     allowed_audiences          = ["https://audience1.example.com", "https://audience2.example.com"]
    #     client_secret              = "Your Active Directory Client Secret"
    #     client_secret_setting_name = "Your Active Directory Client Secret Setting Name"
    #   }]

    #   facebook = [{
    #     app_id                  = "Your Facebook App ID"
    #     app_secret              = "Your Facebook App Secret"
    #     app_secret_setting_name = "Your Facebook App Secret Setting Name"
    #     oauth_scopes            = ["email", "public_profile"]
    #   }]

    #   github = [{
    #     client_id                  = "Your GitHub Client ID"
    #     client_secret              = "Your GitHub Client Secret"
    #     client_secret_setting_name = "Your GitHub Client Secret Setting Name"
    #     oauth_scopes               = ["user:email"]
    #   }]

    #   google = [{
    #     client_id                  = "Your Google Client ID"
    #     client_secret              = "Your Google Client Secret"
    #     client_secret_setting_name = "Your Google Client Secret Setting Name"
    #     oauth_scopes               = ["openid", "profile", "email"]
    #   }]

    #   microsoft = [{
    #     client_id                  = "Your Microsoft Client ID"
    #     client_secret              = "Your Microsoft Client Secret"
    #     client_secret_setting_name = "Your Microsoft Client Secret Setting Name"
    #     oauth_scopes               = ["user.read"]
    #   }]

    #   twitter = [{
    #     consumer_key                 = "Your Twitter Consumer Key"
    #     consumer_secret              = "Your Twitter Consumer Secret"
    #     consumer_secret_setting_name = "Your Twitter Consumer Secret Setting Name"
    #   }]
    # }]

    # Optional: Uncomment to set auth settings V2. All sub blocks are also optional and may be ommitted
    # auth_settings_v2 = [{
    #   auth_enabled                            = true 
    #   runtime_version                         = "~1"
    #   config_file_path                        = "path/to/your/config.json"
    #   require_authentication                  = true                   
    #   unauthenticated_action                  = "RedirectToLoginPage" 
    #   default_provider                        = "AzureActiveDirectory"
    #   excluded_paths                          = ["/.auth/login/aad/callback", "/.auth/logout"]
    #   require_https                           = true 
    #   http_route_api_prefix                   = "api"
    #   forward_proxy_convention                = "NoProxy"
    #   forward_proxy_custom_host_header_name   = "Custom-Host-Header-Name"
    #   forward_proxy_custom_scheme_header_name = "Custom-Scheme-Header-Name"

    #   login = {
    #     logout_endpoint                   = "https://example.com/logout"
    #     token_store_enabled               = true 
    #     token_refresh_extension_time      = 72
    #     token_store_path                  = "path/to/token/store"
    #     token_store_sas_setting_name      = "TokenStoreSasSettingName"
    #     preserve_url_fragments_for_logins = true 
    #     allowed_external_redirect_urls    = ["https://redirect1.example.com", "https://redirect2.example.com"]
    #     cookie_expiration_convention      = "FixedTime"
    #     cookie_expiration_time            = "08:00:00"
    #     validate_nonce                    = true 
    #     nonce_expiration_time             = "00:05:00"
    #   }

    #   apple_v2 = [{
    #     client_id                  = "Your Apple Client ID"
    #     client_secret_setting_name = "Your Apple Client Secret Setting Name"
    #     login_scopes               = ["email", "name"]
    #   }]

    #   active_directory_v2 = [{
    #     client_id                            = "Your Active Directory Client ID"
    #     tenant_auth_endpoint                 = "https://login.microsoftonline.com/tenant-id/oauth2/v2.0/authorize"
    #     client_secret_setting_name           = "Your Active Directory Client Secret Setting Name"
    #     client_secret_certificate_thumbprint = "Your Certificate Thumbprint"
    #     jwt_allowed_groups                   = ["group1", "group2"]
    #     jwt_allowed_client_applications      = ["app1", "app2"]
    #     www_authentication_disabled          = true 
    #     allowed_groups                       = ["group1", "group2"]
    #     allowed_identities                   = ["identity1", "identity2"]
    #     allowed_applications                 = ["app1", "app2"]
    #     allowed_audiences                    = ["audience1", "audience2"]
    #     login_parameters                     = ["param1=value1", "param2=value2"]
    #   }]

    #   azure_static_web_app_v2 = [{
    #     client_id = "Your Azure Static Web App Client ID"
    #   }]

    #   custom_oidc_v2 = [{
    #     name                          = "Your Custom OIDC Provider Name"
    #     client_id                     = "Your Custom OIDC Client ID"
    #     openid_configuration_endpoint = "https://example.com/.well-known/openid-configuration"
    #     name_claim_type               = "name"
    #     scopes                        = ["openid", "profile"]
    #     client_credential_method      = "client_secret_post"
    #     client_secret_setting_name    = "Your Custom OIDC Client Secret Setting Name"
    #     authorisation_endpoint        = "https://example.com/authorize"
    #     token_endpoint                = "https://example.com/token"
    #     issuer_endpoint               = "https://example.com"
    #     certification_uri             = "https://example.com/cert"
    #   }]

    #   facebook_v2 = [{
    #     app_id                  = "Your Facebook App ID"
    #     app_secret_setting_name = "Your Facebook App Secret Setting Name"
    #     graph_api_version       = "v8.0"
    #     login_scopes            = ["email", "public_profile"]
    #   }]

    #   github_v2 = [{
    #     client_id                  = "Your GitHub Client ID"
    #     client_secret_setting_name = "Your GitHub Client Secret Setting Name"
    #     login_scopes               = ["read:user"]
    #   }]

    #   google_v2 = [{
    #     client_id                  = "Your Google Client ID"
    #     client_secret_setting_name = "Your Google Client Secret Setting Name"
    #     allowed_audiences          = ["https://audience1.example.com", "https://audience2.example.com"]
    #     login_scopes               = ["openid", "profile", "email"]
    #   }]

    #   microsoft_v2 = [{
    #     client_id                  = "Your Microsoft Client ID"
    #     client_secret_setting_name = "Your Microsoft Client Secret Setting Name"
    #     allowed_audiences          = ["https://audience1.example.com", "https://audience2.example.com"]
    #     login_scopes               = ["user.read"]
    #   }]

    #   twitter_v2 = [{
    #     consumer_key                 = "Your Twitter Consumer Key"
    #     consumer_secret_setting_name = "Your Twitter Consumer Secret Setting Name"
    #   }]
    # }]

    # Optional: Uncomment to configure back for the app service
    # backup = {
    #   "backup-test" = {
    #     storage_account_url = ""
    #     enabled             = true

    #     schedule = {
    #       frequency_interval       = 7
    #       frequency_unit           = "Day"
    #       keep_at_least_one_backup = true
    #       retention_period_days    = 30 
    #     }
    #   }
    # }

    # Optional: Uncomment to set one or more connection string
    # connection_string = {
    #   "exampleString" = {
    #     type = "Custom"
    #     value = "thisisacustomstring"
    #   }
    # }

    # Optional: Uncomment to set identity for the app service
    # identity = {
    #   type = "SystemAssigned"
    #   identity_ids = [""]
    # }

    # Optional: Uncomment to set logging for the app service
    # logs = [{
    #   detailed_error_messages = true
    #   failed_request_tracing  = true

    #   application_logs = [{
    #     file_system_level = "Error"

    #     azure_blob_storage = [{
    #       level             = "Information"
    #       retention_in_days = 30
    #       sas_url           = "Your SAS URL"
    #     }]
    #   }]

    #   http_logs = [{
    #     azure_blob_storage = [{
    #       retention_in_days = 30
    #       sas_url           = "Your SAS URL"
    #     }]

    #     file_system = [{
    #       retention_in_days = 30
    #       retention_in_mb   = 35
    #     }]
    #   }]
    # }]

    # Optional: Uncomment to set a storage account for access to the app service
    # storage_account = [{
    #   access_key   = "Your Storage Account Access Key"
    #   account_name = "Your Storage Account Name"
    #   name         = "Your Storage Account Share Name"
    #   share_name   = "Your File Share Name"
    #   type         = "AzureFiles" # or "AzureBlob"
    #   mount_path   = "/path/to/mount"
    # }]

    # Optional: Uncomment to set sticky settings
    # sticky_settings = {
    #   app_setting_names       = ["AppSetting1", "AppSetting2"]
    #   connection_string_names = ["ConnectionString1", "ConnectionString2"]
    # }
  }
}
