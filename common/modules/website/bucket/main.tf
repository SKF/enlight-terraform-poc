variable "service" {}

output "bucket" {
  value = "${aws_s3_bucket.website.id}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.website.website_endpoint}"
}

resource "aws_s3_bucket" "website" {
  bucket_prefix = "${var.service}-website-"
  acl           = "public-read"
  force_destroy = "true"

  website {
    index_document = "index.html"
    error_document = "${var.service}/404.html"
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.website.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":"${aws_s3_bucket.website.arn}/${var.service}/*"
    }
  ]
}
POLICY
}
