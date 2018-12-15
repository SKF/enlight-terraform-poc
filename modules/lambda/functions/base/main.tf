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
