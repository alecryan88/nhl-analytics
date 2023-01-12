# NHL-Analytics

## Description
This project is an end-to-end data pipeline that extracts data from the NHL API and loads it into Snowflake for analysis. There are a few simple commands that allow users to get up and running very quickly. This project can be easily extended to add aditional loaders by updating `config.yml`. 

## Motivation
When I first started in analytics engineering, I found myself constatnly running into the problem of wanting to get an ELT pipeline and running for cheap. With the rise of tools like DBT, analytics engineer

## Technologies
- Terraform - Infrastructure
- GitHub Actions - CI/CD
- AWS Lambda - Data Processing
- AWS S3 - Staging
- Snowflake - Warehouse


## Prerequisites
To get up and running with this project:
1. Create an [AWS](https://aws.amazon.com/) account and install the AWS CLI
2. Create a [Snowflake](https://www.snowflake.com/) Account
3. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
4. Install Python 3.7+

## Setup
1. Clone the repo to your local machine and change into the repo directory

2. Initialize terraform: 
```sh
$ make init
```
This make command will execute a handful of shell commands and should only be run once when the project is initialized. These commands will output:
- A virtual environment called `venv` in the project's root directory. This virtual environment will install the `requirements.txt` file in the project's root directory as well as upgrade the pip package manager.
- A file called `terraform/terraform.tfvars`. This file is used for environment variables that will be made available to terraform when creating our resources. You will need to enter the values shown below (with exception of python_version which is automatically detected when `make init` is run):
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


3. Activate the virtual environment created by the `make init` step. This follows the `venv` naming convenvtion:
```sh
$ source venv/bin/activate
```
There are some dependencies for the null_resources using a local-exec provisioner so we need to make sure we're using the `venv` that comes pre-installed with those packages.

4. Run the apply command to spin up the application infrastructure: 
```sh
$ make apply
```
