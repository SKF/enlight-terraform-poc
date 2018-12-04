output "bucket_id" {
  value = "${aws_s3_bucket.website.id}"
}

output "cloudfront_id" {
  value = "${aws_cloudfront_distribution.website_distribution.id}"
}
