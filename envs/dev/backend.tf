terraform {
  backend "s3" {
    bucket       = "dev-terraform-cloud-infra"
    key          = "terraform/cloud-infra/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}