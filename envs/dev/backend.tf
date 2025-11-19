terraform {
  backend "s3" {
    bucket       = "sahu-dev-terraform-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    # Optional: if you want state locking you should configure a DynamoDB table:
    # dynamodb_table = "terraform-state-locks"
  }
}