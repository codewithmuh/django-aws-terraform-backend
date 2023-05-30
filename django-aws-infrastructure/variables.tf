variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-2"
}

variable "project_name" {
  description = "Project name to use in resource names"
  default     = "django-aws"
}