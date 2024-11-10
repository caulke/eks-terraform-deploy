terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    key            = "kevin/terraform.state"
    bucket         = "team1-bucket-001"
    region         = "us-east-1"
    dynamodb_table = "team1-db-001"
  }
}
