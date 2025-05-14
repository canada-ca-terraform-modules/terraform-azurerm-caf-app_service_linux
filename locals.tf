locals {
  resource_group_name = strcontains(var.appServiceLinux.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.appServiceLinux.resource_group) : var.resource_groups[var.appServiceLinux.resource_group].name

  subnet_id = try(var.appServiceLinux.virtual_network_subnet_id, null) != null ?  strcontains(var.appServiceLinux.virtual_network_subnet_id, "/resourceGroups/") ? var.appServiceLinux.virtual_network_subnet_id : var.subnets[var.appServiceLinux.virtual_network_subnet_id].id : null

  asp = strcontains(var.appServiceLinux.asp, "/resourceGroups/") ? var.appServiceLinux.asp : var.asp[var.appServiceLinux.asp]
  # asp_rg = strcontains(var.appServiceLinux.asp.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.appServiceLinux.asp.resource_group) : var.resource_groups[var.appServiceLinux.asp.resource_group].name
}