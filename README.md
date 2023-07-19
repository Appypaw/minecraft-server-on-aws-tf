# Minecraft Service on AWS [Terraform]

Public Cloud인 AWS와 IaC툴인 Terraform을 이용하여 간단한 Minecraft 서버를 서비스합니다.
실습 및 구현에 초점을 두어서 작성하였습니다. Spigot이나 PaperMC와 같은 서드파티 API는 Docker를 이용하는것이 좋습니다.

## Resources
- Provider - AWS
- IaC - Terraform
- SSH - PuTTY

## Installation

Terraform을 필요로 합니다. Terraform은 [여기](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)를 눌러서 각 OS에 맞게 설치하여 줍니다.

Terraform 설치가 끝난 이후에는 CMD 또는 Powershell에 접속하여 
```
terraform version
```
타이핑해 제대로 설치가 끝난지 확인하도록 합니다. 설치가 제대로 되지 않았다면 환경변수에 Terraform.exe를 추가해주도록 합니다.

설치받은 .tf 파일들속에서 terraform.tfvars 에 들어가 해당 변수들을 본인에게 맞게 설정해주도록 합니다.
| Plugin | README |
| ------ | ------ |
| server_region | AWS EC2가 서비스하는 지역. (예 : "ap-northeast-2")|
| server_port | 서버 포트 (예 : "25565")|
| server_availability_zones | AWS EC2에서 가용영역. (예 : "") |
| instance_type | AWS EC2의 인스턴스 타입. (예 : "t2.micro") |
| server_name | 서버 이름. (예 : "APPYserver") |
| admin_ip | 관리자 아이피. (예 : "255.255.255.255") |

```sh
cd 디렉터리
terraform init

set AWS_ACCESS_KEY_ID=엑세스 키 ID
set AWS_SECRET_ACCESS_KEY=시크릿키 ID

terraform plan

terraform fmt

terraform validate

terraform apply
```

를 차례대로 타이핑하여 서버 구동,.

```
terraform destroy
```
리소스 파괴.

## Reference

https://registry.terraform.io/providers/hashicorp/aws/latest/docs