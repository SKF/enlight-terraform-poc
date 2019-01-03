output "name" {
  value = "${local.func_name}"
}

output "arn" {
  value = "${module.func.arn}"
}
