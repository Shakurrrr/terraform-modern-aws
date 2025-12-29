module "lambda" {
  source        = "../../modules/lambda"
  function_name = "modern-api-dev"
}

module "api_gateway" {
  source              = "../../modules/api_gateway"
  lambda_invoke_arn   = module.lambda.invoke_arn
  lambda_function_arn = module.lambda.function_arn
}
