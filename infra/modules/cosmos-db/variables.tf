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

variable "mongo_server_version" {
  description = "MongoDB server version for Cosmos DB (3.2, 3.6, 4.0, 4.2)"
  type        = string
  default     = "4.2"
}
