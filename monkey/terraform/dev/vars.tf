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

variable "datadog_api_key" {
  default = "dd03f233a7f9cfef3f58fb3de6b2475e"
}

variable "datadog_app_key" {
  default = "bdd6576a6da1062bddc4d174d45fed779bd528ba"
}
