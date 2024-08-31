output "private_endpoints" {
  description = <<DESCRIPTION

  A map of the private endpoints created.
DESCRIPTION
  value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
}

output "resource" {
  description = <<DESCRIPTION

  This is the full output for the Monitor Private Link Scope resource.
DESCRIPTION
  sensitive   = true
  value       = azurerm_monitor_private_link_scope.this
}

output "resource_id" {
  description = <<DESCRIPTION

  This is the full output for the Monitor Private Link Scope resource ID.
DESCRIPTION
  value       = azurerm_monitor_private_link_scope.this.id
}
