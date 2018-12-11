# enlight-terraform-poc
The purpose with this PoC is to build an example with Terraform which takes into account our current Way of Working with multiple repos which has infrastructure dependencies among themselves and would be deployed in multiple AWS accounts.

## Terraform
https://www.terraform.io/

## Why Terraform
- Build vs. Buy, Terraform will replace Fluffy, a homebuilt solution ontop of AWS Cloudformation.
- Multi cloud, even though we are currently not moving towards multi cloud, Terraform is built for it.
- Provision other things than AWS resources, Terraform wouldn't just support Infrastructure resources in AWS or Azure, it also supports custom resources, like adding a developer to Enlight, AWS and Azure Devops, which would help with onboarding/offboarding.
- Up to date, Fluffy is built ontop of Troposphere which is a community driven tool for writing cloudformation templates in Python, while Terraform has HashiCorp, a larger community and major cloud providers like AWS and Azure as contributers.

## When done, we will be able to
- create a new public hosted zone and add its Name Servers to `sandbox.enlight.skf.com`
- create an SSL certificate for the new subdomain
- create an S3 bucket with a CDN to be used for website hosting similar to the ONE-CDN solution in Enlight
- upload a web app to the S3 bucket from a second terraform state
- create a backend including a new public hosted zone and certificate from a third terraform state
- access a web app on `https://terraform_poc.sandbox.enlight.skf.com/monkey`

## File structure
- modules
  - api_gateway
  - certificate
  - lambda
  - public_zone
  - remote_state
  - website
- services
  - common
    - iac
  - monkey
    - backend
    - iac
    - web

## AWS deployment
- sandbox008
  - NS record (eu-west-1)
  - public zone (eu-west-1)
  - website (eu-west-1)
  - certificate (monkey.*) (us-east-1)
  - backend (monkey.*) (eu-west-1)
  - remote state (eu-west-1)

## AWS deployment (milestone #3)
- sandbox008 (sandbox.enlight.skf.com)
  - NS record (terraform_poc.*) (eu-west-1)
- sandbox010 (terraform_poc.sandbox.enlight.skf.com)
  - public zone (terraform_poc.*) (eu-west-1)
  - NS record (monkey.*) (eu-west-1)
  - certificate (terraform_poc.*) (us-east-1)
  - website (terraform_poc.*) (eu-west-1)
- sandbox*** (monkey.terraform_poc.sandbox.enlight.skf.com)
  - public zone (monkey.*) (eu-west-1)
  - certificate (monkey.*) (us-east-1)
  - backend (monkey.*) (eu-west-1)

## Provision Infrastructure and Application
- Plan and apply the common service
  - services/common
    - terraform init
    - terraform plan
    - terraform apply
- Plan and apply the monkey service
  - services/monkey/backend
    - dep ensure
    - sh build.sh
  - services/monkey/web
    - yarn install
    - yarn build
  - services/monkey
    - terraform init
    - terraform plan
    - terraform apply

## Destroy Infrastructure and Application
- Destroy the monkey service
  - services/monkey
    - terraform destroy
- Destroy the common service
  - services/common
    - terraform destroy
