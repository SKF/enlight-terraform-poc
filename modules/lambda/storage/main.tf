resource "aws_s3_bucket" "bucket" {
  bucket        = "${md5(uuid())}-lambda-storage"
  acl           = "private"
  force_destroy = "true"

  versioning {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      "bucket",
    ]
  }
}
