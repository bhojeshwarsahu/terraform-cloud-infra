terraform {
  backend "s3" {
    bucket       = "sahu-dev-terraform-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}