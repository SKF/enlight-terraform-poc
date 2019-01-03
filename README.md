# enlight-terraform-poc
The purpose with this PoC is to build an example with Terraform which takes into account our current Way of Working with multiple repos which has infrastructure dependencies among themselves and would be deployed in multiple AWS accounts.

## Deployed
### Terraform Zoo
- https://terraform-zoo.sandbox.enlight.skf.com
### Monkey
- https://terraform-zoo.sandbox.enlight.skf.com/monkey
- https://api.monkey.terraform-zoo.sandbox.enlight.skf.com
### Donkey
- https://terraform-zoo.sandbox.enlight.skf.com/donkey
- https://api.donkey.terraform-zoo.sandbox.enlight.skf.com

## Terraform
https://www.terraform.io/

## Why Terraform
- Build vs. Buy, Terraform would replace Fluffy, a homebuilt solution ontop of Troposphere and AWS Cloudformation.
- Multi cloud, even though we are currently not moving towards multi cloud, Terraform is built for it.
- Provision more than Cloud resources, Terraform wouldn't just support Infrastructure resources in AWS or Azure, it also supports custom resources, like Datadog integrations or adding a developer to Enlight, AWS and Azure Devops, which would help with onboarding/offboarding.
- Up to date, Fluffy is built ontop of Troposphere which is a community driven tool for writing cloudformation templates in Python, we have had issues in the past were both Troposphere and Cloudformation itself have not been updated when new features in AWS are released. Terraform on the other hand is instead built ontop of the AWS API and in contrast to Troposphere and Fluffy, Terraform has HashiCorp, the major cloud providers like AWS and Azure, companies like Datadog and a community as contributers.

## When done, we will be able to
### Common
- create storage for remote Terraform state in S3
- create a new public hosted zone `terraform-zoo.sandbox.enlight.skf.com` and add its Name Servers to `sandbox.enlight.skf.com`
- create an S3 bucket with a CDN to be used for website hosting similar to the ONE-CDN solution in Enlight with an SSL certificate
### For the Donkey and Monkey service
- upload web app to the S3 bucket
- create a new public hosted zone `service.terraform-zoo.sandbox.enlight.skf.com` and add its Name Servers to `terraform-zoo.sandbox.enlight.skf.com`
- create api including certificate

## File structure
The root directories would be divided into multiple repo's in a real application.
- terraform-modules
  - api_gateway
    - options_method
    - rest_api
  - certificate
  - lambda
    - events
      - api_authorizer
      - api_method
    - functions
      - api_method
      - base
    - storage
  - public_zone
  - remote_state
  - website
- common
    - base
    - dev
- donkey
  - backend
    - terraform
  - terraform
    - base
    - dev
  - web
    - terraform
- monkey
  - backend
    - terraform
  - terraform
    - base
    - dev
  - web
    - terraform


## AWS deployment
- terraform_poc.sandbox.enlight.skf.com
  - public zone
  - website (terraform-zoo.sandbox.enlight.skf.com)
    - certificate
  - Remote state storage
- donkey.terraform_poc.sandbox.enlight.skf.com
  - public zone
  - api
    - certificate
  - lambda bucket
- monkey.terraform-zoo.sandbox.enlight.skf.com
  - public zone
  - api
    - certificate
  - lambda bucket

## Provision Infrastructure and Application
- Plan and apply the common service
  - common/terraform/dev
    - terraform init
    - terraform plan
    - terraform apply
- Plan and apply the donkey and monkey service
  - \<service\>/backend
    - dep ensure
    - sh build.sh
  - \<service\>/web
    - yarn install
    - yarn build
  - \<service\>/terraform/dev
    - terraform init
    - terraform plan -var 'datadog_api_key=<api_key>' -var 'datadog_app_key=<app_key>'
    - terraform apply -var 'datadog_api_key=<api_key>' -var 'datadog_app_key=<app_key>'

## Destroy Infrastructure and Application
- Destroy the donkey and monkey service
  - \<service\>/terraform/dev
    - terraform destroy
- Destroy the common service
  - common/terraform/dev
    - terraform destroy
