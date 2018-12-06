provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

module iac {
  source = "./iac"
}

module backend {
  source = "./backend/build"

  api_id         = "${module.iac.api_id}"
  monkeys_path   = "${module.iac.monkeys_path_id}"
  monkey_id_path = "${module.iac.monkey_id_path_id}"
  api_deployment = "${md5(file("backend/build/main.tf"))}"
}

module web {
  source = "./web"
}