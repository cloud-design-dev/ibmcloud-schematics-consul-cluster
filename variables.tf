variable "instance_count" {
  description = "Number of compute instances to deploy in region."
  type        = string
  default     = "3"
}

variable "default_image" {
  description = "Default operating system image for compute instance."
  type        = string
  default     = "r014-ed3f775f-ad7e-4e37-ae62-7199b4988b00"
}

variable "default_instance_profile" {
  description = "Default instance size."
  type        = string
  default     = "bx2-8x32"
}

variable "ssh_key" {
  description = "VPC ssh key to add to compute instance."
  type        = string
  default     = "hyperion-us-east"
}

variable "resource_group_name" {
  description = "Resource group where resources will be deployed."
  type        = string
  default     = "CDE"
}

variable "dns_instance_id" {
  description = "Private DNS Instance ID."
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "Private DNS zone ID."
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Name of VPC where resources will be deployed."
  type        = string
  default     = ""
}

variable "consul_version" {
  description = "Version of consul to install on compute instances."
  type        = string
  default     = ""
}

variable "zone" {
  description = "VPC zone where resources will be deployed."
  type        = string
  default     = ""
}

variable "acl_token" {
  description = "Token to use for cluster ACL."
  type        = string
  default     = ""
}

variable "encrypt_key" {
  description = "Encryption key used for consul gossip."
  type        = string
  default     = ""
}
