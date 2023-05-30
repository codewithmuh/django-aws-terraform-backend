variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-2"
}

variable "project_name" {
  description = "Project name to use in resource names"
  default     = "django-aws"
}

variable "availability_zones" {
  description = "Availability zones"
  default = ["us-east-2a", "us-east-2c"]
}

variable "ecs_prod_backend_retention_days" {
  description = "Retention period for backend logs"
  default     = 30
}
