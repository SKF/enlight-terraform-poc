# enlight-terraform-poc
The purpose with this PoC is to build an example which takes into account our current Way of Working with multiple repos which has infrastructure dependencies among themselves and would be deployed in multiple AWS accounts.

## When done, we will be able to
- create a new public hosted zone and add its Name Servers to `sandbox.enlight.skf.com`
- create an SSL certificate for the new subdomain
- create an S3 bucket with a CDN to be used for website hosting similar to the ONE-CDN solution in Enlight
- upload a web app to the S3 bucket from a second terraform state
- create a backend including a new public hosted zone and certificate from a third terraform state
- access a web app on `https://terraform_poc.sandbox.enlight.skf.com/monkey`

## File structure
- modules
  - public_zone
  - website
  - certificate (milestone #3)
- services
  - common
    - iac
  - service_one
    - web
    - iac (milestone #3)
    - backend (milestone #3)

## AWS deployment
- sandbox008
  - NS record (eu-west-1)
  - public zone (eu-west-1)
  - website (eu-west-1)

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
  - services/common/iac
    - terraform init
    - terraform plan
    - terraform apply
- Plan and apply the monkey service
  - services/monkey/iac (milestone #3)
    - terraform init
    - terraform plan
    - terraform apply
  - services/monkey/backend (milestone #3)
    - terraform init
    - terraform plan
    - terraform apply
  - services/monkey/web
    - terraform init
    - terraform plan
    - terraform apply

## Destroy Infrastructure and Application
- Destroy the monkey service
  - services/monkey/web
    - terraform destroy
  - services/monkey/backend (milestone #3)
    - terraform destroy
  - services/monkey/iac (milestone #3)
    - terraform destroy
- Destroy the common service
  - services/common/iac
    - terraform destroy
