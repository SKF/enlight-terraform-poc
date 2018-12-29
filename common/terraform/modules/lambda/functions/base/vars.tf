variable "func_name" {}
variable "filename" {}
variable "bucket" {}

variable "env" {
  type = "map"
}

variable "handler" {
  default = "main"
}

variable "runtime" {
  default = "go1.x"
}

variable "datadog" {
  default = "false"
}

variable "datadog_log_collector_arn" {
  default = ""
}

variable "datadog_log_collector_name" {
  default = ""
}
