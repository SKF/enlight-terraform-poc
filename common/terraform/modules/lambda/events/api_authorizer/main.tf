resource "aws_api_gateway_authorizer" "authorizer" {
  name                   = "${var.authorizer_name}"
  rest_api_id            = "${var.api_id}"
  authorizer_uri         = "${var.func_invoke_arn}"
  authorizer_credentials = "${aws_iam_role.invocation_role.arn}"
}

data "aws_iam_policy_document" "invocation_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.invocation_role.json}"
}

data "aws_iam_policy_document" "invocation_policy" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["${var.func_arn}"]
  }
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = "${aws_iam_role.invocation_role.id}"

  policy = "${data.aws_iam_policy_document.invocation_policy.json}"
}
