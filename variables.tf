variable "server_region" {
  type        = string
  description = "서버 리전. https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html. 참조"
}

variable "server_port" {
  description = "마인크래프트 서버 포트"
  default     = 25565 # 마인크래프트 서버 기본 포트
}

variable "admin_ip" {
  type        = string
  description = "서버 SSH 접속 가능 ID"
}

variable "server_name" {
  type        = string
  description = "서버 이름"
}

variable "instance_type" {
  type        = string
  description = "인스턴스 타입"
  default     = "t2.micro"
}

variable "server_availability_zones" {
  type        = string
  description = "서버 가용영역"
  default     = "ap-northeast-2a"
}