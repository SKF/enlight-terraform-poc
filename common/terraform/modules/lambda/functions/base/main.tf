resource "aws_s3_bucket_object" "lambda" {
  bucket = "${var.bucket}"
  key    = "${basename(var.filename)}"
  source = "${var.filename}"
  etag   = "${md5(file(var.filename))}"
}

resource "aws_lambda_function" "func" {
  function_name = "${var.func_name}"

  s3_bucket         = "${aws_s3_bucket_object.lambda.bucket}"
  s3_key            = "${aws_s3_bucket_object.lambda.key}"
  s3_object_version = "${aws_s3_bucket_object.lambda.version_id}"

  handler = "${var.handler}"
  runtime = "${var.runtime}"

  tracing_config = {
    mode = "Active"
  }

  role = "${aws_iam_role.lambda_exec.arn}"

  environment {
    variables = "${var.env}"
  }
}

data "aws_iam_policy_document" "lambda_exec" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.func_name}_lambda_role"

  assume_role_policy = "${data.aws_iam_policy_document.lambda_exec.json}"
}

resource "aws_cloudwatch_log_group" "logging" {
  name              = "/aws/lambda/${aws_lambda_function.func.function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "logging" {
  role       = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "xray" {
  role       = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

module "datadog" {
  source  = "../../events/cloudwatch_logs"
  enabled = "${var.datadog == "true"}"

  origin         = "${var.func_name}_lambda"
  log_group_name = "/aws/lambda/${var.func_name}"
  lambda_arn     = "${var.datadog_log_collector_arn}"
  lambda_name    = "${var.datadog_log_collector_name}"
}
