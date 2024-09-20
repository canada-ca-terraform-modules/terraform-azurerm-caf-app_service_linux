locals {
  resource_group_name = strcontains(var.appServiceLinux.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.appServiceLinux.resource_group) : var.resource_groups[var.appServiceLinux.resource_group].name

  asp = strcontains(var.appServiceLinux.asp.name, "/resourceGroups/") ? var.appServiceLinux.asp.name : null
  asp_rg = strcontains(var.appServiceLinux.asp.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.appServiceLinux.asp.resource_group) : var.resource_groups[var.appServiceLinux.asp.resource_group].name
}