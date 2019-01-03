data "aws_region" "current" {}

resource "aws_cloudwatch_log_subscription_filter" "lambda_ingestion_logfilter" {
  count = "${var.enabled ? 1 : 0}"

  depends_on      = ["aws_lambda_permission.lambda_ingestion_logfilter"]
  name            = "lambda_ingestion_logfilter"
  log_group_name  = "${var.log_group_name}"
  filter_pattern  = ""
  destination_arn = "${var.lambda_arn}"
}

resource "aws_lambda_permission" "lambda_ingestion_logfilter" {
  count = "${var.enabled ? 1 : 0}"

  statement_id  = "${var.origin}_logs"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_name}"
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
}
