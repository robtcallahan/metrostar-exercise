variable "aws_region" {
  default = "us-east-1"
}

variable key_name {
  default = "robs-mbp"
}

variable "public_key_path" {
  description = "Path to ssh key"
  default = "~/.ssh/id_rsa.pub"
}

variable vpc_id {
  default = "vpc-c0ca75bb"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable ami {
  default = "ami-97785bed" 
}

variable instance_type { 
  default = "t2.micro" 
}

variable root_passwd {
  default = "dinx9one"
}

variable db_user { 
  default = "rob" 
}

variable db_pwd { 
  default = "dinx9one" 
}

variable "subnet_1_cidr" {
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr" {
  default     = "10.0.2.0/24"
}

variable "az_1" {
  default     = "us-east-1a"
  description = "Your Az1, use AWS CLI to find your account specific"
}

variable "az_2" {
  default     = "us-east-1b"
  description = "Your Az2, use AWS CLI to find your account specific"
}
