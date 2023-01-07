# nhl-analytics



## Architecture



## Prerequisites
To get up and running with this project:
1. Create an AWS profile and grant necessary permissions to a user
2. Create a Snowflake Account and Resources
3. Install Terraform

## Setup
1. Clone the repo to your local machine:
``` sh
$ git clone {name}
```
2. In the working directory run: 
```sh 
$ touch terraform/terraform.tfvars
```
This will create a file for necessary environment variables that will be passed to terraform. In the file the variables below:
```sh
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
3. Define a loader in config.yml. Details on how to do this can be found [here](loaders/README.md)

4. Run terraform: 
```sh
$ terraform apply -auto-approve
```
Thi will spin up all of the necessary resources for the project. Included in ths is a directory for each loader defined in config.yml located at loaders/{loader.name}. In this directory is 