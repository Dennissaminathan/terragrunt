# Set global variables for the environment. Variables are automatically imported in terragrunt.hcl configuration file
locals {
  common_vars = yamldecode(file("${find_in_parent_folders("global_vars.yaml")}"))
  region = local.common_vars.default.aws_region
 }

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket = "terraform-up-and-running-state"

    key = "shared-prod/${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region}"
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite" # Allow modules to override provider settings
  contents = <<EOF
  provider "aws" {
    profile = "default"
    region = "${local.region}"
  }
  terraform {
    required_version = ">= 0.12.0"

    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 2.70"
      }
    }
  }
EOF
}
