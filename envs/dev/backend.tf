terraform {
  backend "s3" {
    bucket         = "tf-state-559938827680-devops"
    key            = "modern/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
