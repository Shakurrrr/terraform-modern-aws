variable "name" {
  type        = string
  description = "Name prefix for frontend resources"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags to apply to resources"
}
