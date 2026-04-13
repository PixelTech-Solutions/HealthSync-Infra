variable "name" {
  description = "Cosmos DB account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "databases" {
  description = "List of MongoDB database names to create"
  type        = list(string)
  default     = []
}

variable "consistency_level" {
  description = "Cosmos DB consistency level"
  type        = string
  default     = "Session"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
