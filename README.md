# NHL-Analytics

## Description
This project is an end-to-end data pipeline that extracts data from the NHL API and loads it into Snowflake for analysis. There are a few simple commands that abstract a lot of the complexity underneath. 

## Motivation
When I first started in analytics engineering, I found myself constatnly running into the problem of wanting to get an ELT pipeline and running for cheap. With the rise of tools like DBT, analytics engineer

## Technologies
- Terraform - Infrastructure
- GitHub Actions - CI/CD
- AWS Lambda - Data Processing
- AWS S3 - Staging
- Snowflake - Warehouse

## Architecture



## Prerequisites
To get up and running with this project:
1. Create an [AWS](https://aws.amazon.com/) account and install the AWS CLI
2. Create a [Snowflake](https://www.snowflake.com/) Account
3. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
4. Python 3.7+

## Setup
1. Clone the repo to your local machine.

2. Edit the config.yml project name

3. Initialize terraform: 
```sh
$ make init
```
This will create a file `terraform/terraform.tfvars` with environment variables that will be used by terraform to create the resources:
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


4. Activate the virtual environment created by the `make init` step. This follows the `venv` naming convenvtion:
```sh
$ source venv/bin/activate
```
During the `make init` step, all of the requirements for running the terraform Python helper scripts are installed. 

5. Run the apply command to spin up the application infrastructure: 
```sh
$ make apply
```
