# enlight-terraform-poc
The purpose with this PoC is to build an example which takes into account our current Way of Working with multiple repos which has infrastructure dependencies among themselves and would be deployed in multiple AWS accounts.

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
- sandbox008
  - NS record (eu-west-1)
- sandbox010 
  - public zone (eu-west-1)
  - certificate (us-east-1)
  - website (eu-west-1)
- sandbox***
  - certificate (us-east-1)
  - backend (eu-west-1)

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
