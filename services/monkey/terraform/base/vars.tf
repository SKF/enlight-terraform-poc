variable "root_domain_name" {}

variable "api_domain_name" {}

variable "api_stage" {
  default = "default"
}

variable "public_zone_id" {}
variable "website_bucket_id" {}
variable "website_cloudfront_id" {}

variable "aws_service_profile" {}

variable "aws_root_profile" {}

variable "aws_common_profile" {}
