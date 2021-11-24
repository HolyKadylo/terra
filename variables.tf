# Fish
#variable "aws_region" {
#  description = "AWS region"
#  type        = string
#  default     = ""
#}

variable "keys" {
  description = "SSH keys to connect"
  type        = string
  default     = "THIS_IS_AN_ERROR"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "CIDR_to_allow_inbound_SSH" {
  description = "The range that is allowed to connect to the EC2"
  type        = string
  default     = "127.0.0.1/32"
}

variable "EC2_type" {
  description = "Type of the unit"
  type        = string
  default     = "t2.nano"
}

variable "EC2_AMI" {
  description = "Amazon Linux by default"
  type        = string
  default     = "ami-04902260ca3d33422"
}

variable "author" {
  description = "Author login"
  type        = string
  default     = "I-forgot-to-change-UN"
}

variable "platform" {
  description = "platform tag"
  type        = string
  default     = "platf"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "env"
}

variable "CIDR1" {
  description = "CIDR for private network"
  type        = string
  default     = "10.0.1.0/24"
}

variable "CIDR2" {
  description = "CIDR for private network"
  type        = string
  default     = "10.0.2.0/24"
}

variable "CIDR3" {
  description = "CIDR for public network"
  type        = string
  default     = "10.0.3.0/24"
}

variable "CIDR4" {
  description = "CIDR for public network"
  type        = string
  default     = "10.0.4.0/24"
}
