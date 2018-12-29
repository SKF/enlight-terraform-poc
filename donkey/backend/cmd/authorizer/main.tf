locals {
  func_name = "authorizer"
}

module "authorizer" {
  source = "../../../common/terraform/modules/lambda/functions/base"

  func_name = "${local.func_name}"
  filename  = "${path.module}/lambda-${local.func_name}.zip"
  bucket    = "${module.lambda_storage.bucket}"

  datadog                    = "true"
  datadog_log_collector_arn  = "${module.log_collector.arn}"
  datadog_log_collector_name = "${module.log_collector.name}"

  env = {
    "DUMMY" = "ENV_CANT_BE_EMPTY_-_SAD_SMILEY"
  }
}

module "api_authorizer_event" {
  source = "../../../common/terraform/modules/lambda/events/api_authorizer"

  authorizer_name = "CUSTOM"
  api_id          = "${module.api_gateway.id}"
  func_arn        = "${module.authorizer.arn}"
  func_invoke_arn = "${module.authorizer.invoke_arn}"
}
