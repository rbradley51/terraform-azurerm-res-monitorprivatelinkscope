
variable "ingestion_access_mode" {
  type        = string
  default     = "PrivateOnly"
  description = <<DESCRIPTION

(Optional) The default ingestion access mode for the associated private endpoints in scope. Possible values are 'Open' and 'PrivateOnly'.
DESCRIPTION
}

variable "query_access_mode" {
  type        = string
  default     = "PrivateOnly"
  description = <<DESCRIPTION

  (Optional) The default query access mode for the associated private endpoints in scope. Possible values are 'Open' and 'PrivateOnly'.
  DESCRIPTION
}

variable "monitor_private_link_scoped_service" {
  type = map(object({
    name                = string
    linked_resource_id  = string
    resource_group_name = optional(string, null)
    scope_name          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION

  A map describing monitor private link scoped service to associate with the resource. This includes the following properties:
- `name` - (Required) The name of the Azure Monitor Private Link Scoped Service. Changing this forces a new resource to be created.
- `resource_group_name` - (Required) The name of the Resource Group where the Azure Monitor Private Link Scoped Service should exist. Changing this forces a new resource to be created.
- `scope_name` - (Required) The name of the Azure Monitor Private Link Scope. Changing this forces a new resource to be created.
- `linked_resource_id` - (Required) The ID of the linked resource. It must be the Log Analytics workspace or the Application Insights component or the Data Collection endpoint. Changing this forces a new resource to be created.
  DESCRIPTION
}
