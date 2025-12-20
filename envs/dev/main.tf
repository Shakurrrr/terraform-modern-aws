terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Configuration

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project    = var.project
      env        = var.env
      owner      = var.owner
      managed-by = "terraform"
    }
  }
}


# Get AWS Account ID

data "aws_caller_identity" "current" {}


# Cost Control (Budget)

module "budget" {
  source            = "../../modules/budgets"
  monthly_limit_usd = var.monthly_budget_usd
  email             = var.alert_email
}

# Edge Frontend (S3 + CloudFront)

module "edge_frontend" {
  source = "../../modules/edge_frontend"

  # S3 bucket names must be globally unique,
  # so we include the AWS account ID
  name = "${var.project}-${var.env}-frontend-${data.aws_caller_identity.current.account_id}"

  tags = {
    project = var.project
    env     = var.env
    owner   = var.owner
  }
}
