PYTHON_VERSION= $(shell python3 -c 'import sys; print(str(sys.version_info[0])+"."+str(sys.version_info[1]))')
define VARS
#Python 
python_version=$(PYTHON_VERSION)

#AWS
aws_access_key_id = 
aws_secret_access_key = 
aws_region     = 

#Snowflake
snowflake_user     = 
snowflake_password = 
snowflake_region   = 
snowflake_account  =
endef
export VARS

init:
	terraform -chdir=terraform init
	
	rm -f terraform/terraform.tfvars
	touch terraform/terraform.tfvars
	@echo "$$VARS" >> terraform/terraform.tfvars
	
	python3 -m venv venv
	source venv/bin/activate && pip install --upgrade pip
	source venv/bin/activate && pip install -r requirements.txt

apply:
	terraform -chdir=terraform fmt
	terraform -chdir=terraform apply

validate:
	terraform -chdir=terraform fmt
	terraform -chdir=terraform validate


plan:
	terraform -chdir=terraform fmt
	terraform -chdir=terraform plan

output:
	terraform -chdir=terraform fmt
	terraform -chdir=terraform output


destroy:
	terraform -chdir=terraform fmt
	terraform -chdir=terraform destroy


upgrade:
	terraform -chdir=terraform init --upgrade