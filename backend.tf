terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    key            = "infra/terraform.state"
    bucket         = "kelvin-bucket-001"
    region         = "us-east-2"
    dynamodb_table = "kelvin-db-001"
  }
}
