variable "api_id" {}
variable "api_resource_id" {}
variable "api_execution_arn" {}
variable "api_stage" {}
variable "http_method" {}
variable "func_arn" {}
variable "func_invoke_arn" {}

variable "authorization" {
	default = "NONE"
}

variable "authorizer_id" {
	default = ""
}