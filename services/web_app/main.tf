provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

data "terraform_remote_state" "common_infra" {
  backend = "local"

  config {
    path = "../common_infra/terraform.tfstate"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${data.terraform_remote_state.common_infra.website_bucket_id}"
  key          = "index.html"
  source       = "./index.html"
  etag         = "${md5(file("./index.html"))}"
  content_type = "text/html"
}