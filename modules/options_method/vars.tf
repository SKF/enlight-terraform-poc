variable "api_id" {}
variable "resource_id" {}

variable "headers" {
  default = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
}

variable "methods" {
  default = "'GET,OPTIONS,POST,PUT'"
}

variable "origin" {
  default = "'*'"
}
