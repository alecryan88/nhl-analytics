# nhl-analytics



## Architecture



## Prerequisites
To get up and running with this project:
1. Create an [AWS](https://aws.amazon.com/) account and install the AWS CLI
2. Create a [Snowflake](https://www.snowflake.com/) Account
3. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)

## Setup
1. Clone the repo to your local machine.

3. Define a loader in config.yml. Details on how to do this can be found [here](loaders/README.md)

4. Initialize terraform: 
```sh
$ make init
```
This will create a file `terraform/terraform.tfvars` with environment variables that will be used by terraform to create your resources:
```sh
#Python
python_version = <Automatically detected>

#AWS
aws_access_key = 
aws_secret_key = 
aws_region     = 

#Snowflake
snowflake_user     = 
snowflake_password = 
snowflake_region   = 
snowflake_account  = 
```


5. Run the apply command to spin up the application infrastructure: 
```sh
$ make apply
```
