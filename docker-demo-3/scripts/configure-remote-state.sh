#!/bin/bash

tee -a backend.tf <<EOF
terraform {
  backend "s3" {
    bucket = "terraform-state-a3c6219"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
EOF
