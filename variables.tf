variable "instance_count" {
  description = "Number of compute instances to deploy in region."
  type        = string
  default     = "3"
}

variable "consul_image" {
  description = "Default operating system image for compute instance."
  type        = string
  default     = "ibm-ubuntu-18-04-1-minimal-amd64-2"
}

variable "windows_image" {
  description = "Default system image for Windows instance."
  type        = string
  default     = "ibm-windows-server-2016-full-standard-amd64-3"
}

variable "default_instance_profile" {
  description = "Default instance size."
  type        = string
  default     = "bx2-8x32"
}

variable "linux_ssh_key" {
  description = "VPC ssh key to add to linux compute instances."
  type        = string
  default     = ""
}

variable "windows_ssh_key" {
  description = "VPC ssh key to add to windows compute instance."
  type        = string
  default     = ""
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