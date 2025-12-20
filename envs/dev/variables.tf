variable "region" {
  type        = string
  description = "AWS region for this environment"
}

variable "project" {
  type        = string
  description = "Project name used for tagging and naming"
}

variable "env" {
  type        = string
  description = "Environment name (dev or prod)"
}

variable "owner" {
  type        = string
  description = "Owner or team name"
}

variable "alert_email" {
  type        = string
  description = "Email address for cost and budget alerts"
}

variable "monthly_budget_usd" {
  type        = number
  description = "Monthly AWS budget limit for this environment"
}
