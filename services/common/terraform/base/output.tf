output "zone_id" {
  value = "${module.public_zone.zone_id}"
}

output "website_bucket_id" {
  value = "${module.website.bucket_id}"
}

output "website_cloudfront_id" {
  value = "${module.website.cloudfront_id}"
}
