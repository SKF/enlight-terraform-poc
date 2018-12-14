resource "aws_s3_bucket" "remote-state" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  versioning {
    enabled = "true"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "remote-state-lock" {
  name         = "${var.table_name}"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
