variable "aws_access_key_id" {
  description = "AWS acces key id"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "aws_region" {
  description = "AWS region"
}

variable "snowflake_user" {
  description = "Snowflake username"
  type        = string
}

variable "snowflake_password" {
  description = "Snowflake password"
  type        = string
}
variable "snowflake_region" {
  description = "Snowflake account region"
  type        = string
}

variable "snowflake_account" {
  description = "Snowflake accoiunt ID."
  type        = string
}

variable "environment" {
  default     = "dev"
  description = "The environment in which the project is running."
  type        = string
}

variable "python_version" {
  description = "The python version used to create the virtual enviroment."
  type        = string
}