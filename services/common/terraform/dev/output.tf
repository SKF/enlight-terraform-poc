output "public_zone_id" {
  value = "${module.base.zone_id}"
}

output "website_bucket_id" {
  value = "${module.base.website_bucket_id}"
}

output "website_cloudfront_id" {
  value = "${module.base.website_cloudfront_id}"
}

output "lambda_storage_bucket" {
  value = "${module.base.lambda_storage_bucket}"
}
