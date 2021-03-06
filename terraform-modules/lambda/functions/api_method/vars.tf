variable "func_name" {}
variable "filename" {}
variable "bucket" {}

variable "env" {
  type = "map"
}

variable "api_id" {}
variable "api_resource_id" {}
variable "api_execution_arn" {}
variable "api_stage" {}
variable "http_method" {}
variable "authorization" {}
variable "authorizer_id" {}

variable "datadog" {
  default = "false"
}

variable "datadog_log_collector_arn" {
  default = ""
}

variable "datadog_log_collector_name" {
  default = ""
}
