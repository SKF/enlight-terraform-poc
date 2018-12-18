variable "root_domain_name" {
  default = "monkeys.terraform-poc.sandbox.enlight.skf.com"
}

variable "api_domain_name" {
  default = "api.monkeys.terraform-poc.sandbox.enlight.skf.com"
}

variable "api_stage" {
  default = "default"
}

variable "aws_service_profile" {
  default = "sandbox"
}

variable "aws_prod_profile" {
  default = "sandbox"
}

variable "aws_common_profile" {
  default = "sandbox"
}
