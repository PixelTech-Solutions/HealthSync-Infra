variable "name" {
  description = "Communication Services name"
  type        = string
}

variable "email_service_name" {
  description = "Email Communication Services name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "data_location" {
  description = "Data location for the communication service"
  type        = string
  default     = "United States"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
