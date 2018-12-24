resource "aws_api_gateway_authorizer" "authorizer" {
  name                   = "${var.authorizer_name}"
  rest_api_id            = "${var.api_id}"
  authorizer_uri         = "${var.func_invoke_arn}"
  authorizer_credentials = "${aws_iam_role.invocation_role.arn}"
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = "${aws_iam_role.invocation_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${var.func_arn}"
    }
  ]
}
EOF
}
