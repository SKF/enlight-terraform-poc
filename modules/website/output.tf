output "buckets" {
  value = {
    "${local.monkey}" = "${module.monkey_bucket.bucket}"
    "${local.donkey}" = "${module.donkey_bucket.bucket}"
  }
}

output "cloudfront_id" {
  value = "${aws_cloudfront_distribution.website_distribution.id}"
}
