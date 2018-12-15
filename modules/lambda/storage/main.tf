resource "aws_s3_bucket" "bucket" {
  bucket        = "09fc75743aa65275042a3364b99816dc-lambda-storage"
  acl           = "private"
  force_destroy = "true"

  versioning {
    enabled = true
  }
}
