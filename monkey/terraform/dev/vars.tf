variable "root_domain_name" {
  default = "monkey.terraform-zoo.sandbox.enlight.skf.com"
}

variable "api_domain_name" {
  default = "api.monkey.terraform-zoo.sandbox.enlight.skf.com"
}

variable "aws_service_profile" {
  default = "monkey_dev"
}

variable "aws_root_profile" {
  default = "sandbox"
}

variable "aws_common_profile" {
  default = "sandbox"
}

variable "datadog_api_key" {}

variable "datadog_app_key" {}
