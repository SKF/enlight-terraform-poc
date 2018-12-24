output "public_zone_id" {
  value = "${module.base.zone_id}"
}

output "website_buckets" {
  value = "${module.base.website_buckets}"
}

output "website_cloudfront_id" {
  value = "${module.base.website_cloudfront_id}"
}
