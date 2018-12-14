module "func" {
  source = "../base"

  func_name = "${var.func_name}"
  filename  = "${var.filename}"
  env       = "${var.env}"
}

module "api_event" {
  source = "../../events/api_method"

  api_id            = "${var.api_id}"
  api_resource_id   = "${var.api_resource_id}"
  api_execution_arn = "${var.api_execution_arn}"
  api_stage         = "${var.api_stage}"
  http_method       = "${var.http_method}"
  func_arn          = "${module.func.arn}"
  func_invoke_arn   = "${module.func.invoke_arn}"
  authorization     = "${var.authorization}"
  authorizer_id     = "${var.authorizer_id}"
}
