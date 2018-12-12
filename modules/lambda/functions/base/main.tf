resource "aws_lambda_function" "func" {
  function_name = "${var.func_name}"

  filename         = "${var.filename}"
  source_code_hash = "${base64sha256(file(var.filename))}"

  handler = "main"
  runtime = "go1.x"

  role = "${aws_iam_role.lambda_exec.arn}"

  environment {
    variables = "${var.env}"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.func_name}_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}