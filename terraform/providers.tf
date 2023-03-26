provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key

}

provider "snowflake" {
  // required
  account  = var.snowflake_account
  username = var.snowflake_user
  password = var.snowflake_password
  region   = var.snowflake_region
  role     = "ACCOUNTADMIN"

}


provider "docker" {
  registry_auth {
    address  = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.ecr_token.user_name
    password = data.aws_ecr_authorization_token.ecr_token.password
  }
}