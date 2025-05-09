#!/bin/bash

terraform init -upgrade
terraform apply

terraform output -json > terraform_output.json

sudo ansible-playbook ansible/moodle.yml -i ansible/inventory/hosts