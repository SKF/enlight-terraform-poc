output "arn" {
  value = "${aws_lambda_function.func.arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.func.invoke_arn}"
}
