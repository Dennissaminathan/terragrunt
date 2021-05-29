# Set global variables for the environment. Variables are automatically imported in terragrunt.hcl configuration file
locals {
  common_vars = yamldecode(file("${find_in_parent_folders("global_vars.yaml")}"))

  aws_region = local.common_vars.default.aws_region
  creator    = local.common_vars.common.tags.creator

  environment         = "shared-prod"
  account_id          = ""
  allowed_account_ids = [""]
}
