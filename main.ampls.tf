resource "azurerm_monitor_private_link_scope" "this" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  ingestion_access_mode = var.ingestion_access_mode
  query_access_mode     = var.query_access_mode
  tags                  = var.tags
}

resource "time_sleep" "private_endpoint_setup" {
  create_duration = "5s"

  depends_on = [azurerm_monitor_private_link_scope.this]
}
