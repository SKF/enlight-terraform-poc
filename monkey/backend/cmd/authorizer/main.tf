module "authorizer" {
  source = "../../../common/terraform/modules/lambda/functions/base"

  func_name = "authorizer"
  filename  = "${path.module}/lambda-authorizer.zip"
  bucket    = "${module.lambda_storage.bucket}"

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
