output "zone_id" {
  value = "${module.public_zone.zone_id}"
}

output "website_buckets" {
  value = "${module.website.buckets}"
}

output "website_cloudfront_id" {
  value = "${module.website.cloudfront_id}"
}
