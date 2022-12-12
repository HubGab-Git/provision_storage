variable "email" {
  type = string
  description = "Email where notifications should be sent"
}
variable "instance_name" {
  type = string
  description = "Name of EC2 Instance"
  default = "NeboInstance"
}
variable "instance_type" {
  type = string
  description = "Type of EC2 Instance"
  default = "t3.nano"
}

variable "ami" {
  type = string
  description = "Default Amazon Linux 2 AMI"
  default = "ami-01cae1550c0adea9c" 
}