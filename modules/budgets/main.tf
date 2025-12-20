variable "monthly_limit_usd" {
  type        = number
  description = "Monthly AWS budget limit in USD"
}

variable "email" {
  type        = string
  description = "Email address to receive budget alerts"
}

resource "aws_budgets_budget" "monthly" {
  name         = "terraform-monthly-budget"
  budget_type  = "COST"
  limit_amount = tostring(var.monthly_limit_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    notification_type           = "ACTUAL"
    comparison_operator         = "GREATER_THAN"
    threshold                   = 80
    threshold_type              = "PERCENTAGE"
    subscriber_email_addresses  = [var.email]
  }
}
