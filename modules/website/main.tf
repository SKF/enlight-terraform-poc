resource "aws_s3_bucket" "website" {
  bucket        = "${var.root_domain_name}"
  acl           = "public-read"
  force_destroy = "true"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":[
        "arn:aws:s3:::${var.root_domain_name}",
        "arn:aws:s3:::${var.root_domain_name}/*"
        ]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

module "cert" {
  source = "../certificate"

  domain_name = "${var.root_domain_name}"
  zone_id     = "${var.aws_route53_zone_id}"
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "${aws_s3_bucket.website.website_endpoint}"
    origin_id   = "${var.root_domain_name}"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.root_domain_name}"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  aliases = ["${var.root_domain_name}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${module.cert.arn}"
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "website" {
  zone_id = "${var.aws_route53_zone_id}"

  name = ""
  type = "A"

  alias = {
    name                   = "${aws_cloudfront_distribution.website_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website_distribution.hosted_zone_id}"
    evaluate_target_health = true
  }
}
