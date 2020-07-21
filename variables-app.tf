variable "app_name" {
  type = string
  description = "Application name"
}
variable "app_environment" {
  type = string
  description = "Application environment"
}
variable "admin_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow admin access"
}
variable "app_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow application access"
}
variable "cluster_runner_type" {
  type = string
  description = "EC2 instance type of ECS Cluster Runner"
  default = "t3.medium"
}
variable "cluster_runner_count" {
  type = string
  description = "Number of EC2 instances for ECS Cluster Runner"
  default = "1"
}
variable "aws_region" {
  type = string
  description = "AWS region"
}

variable "aws_profile" {
  type = string
  description = "AWS profile"
}