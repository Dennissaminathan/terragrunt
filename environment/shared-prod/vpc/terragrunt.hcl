locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out global variables for reuse
  region      = local.environment_vars.locals.aws_region
  env         = local.environment_vars.locals.environment
  common_vars = local.environment_vars.locals.common_vars
}

include {
  path = find_in_parent_folders()
}


# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
    source = "git@github.com:Dennissaminathan/terragrunt.git//network//vpc-subnets"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  # #########################################
  # TAGS values
  # #########################################
  tags = {
    Name            = "vpc-${local.env}"
    Namespace       = "gsep"
    Description     = "VPC for ${local.env} environment in ${local.region} region"
    Environment     = local.env
    Creator         = local.common_vars.common.tags.creator
    Terragrunt-path = path_relative_to_include()
  }

  region                    = local.region
  environment               = local.env
  cidr_block                = "10.5.0.0/16"
  private_availability_zones = ["eu-west-3a"]
  public_availability_zones = ["eu-west3b"]
  private_subnet_cidr_block = ["10.5.0.0/22"]
  public_subnet_cidr_block  = ["10.5.8.0/22"]

  enable_nat_gateway = true

}
