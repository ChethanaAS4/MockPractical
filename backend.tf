terraform {
  backend "s3" {
    bucket = "mock-test-bucket-cas-aug11"
    key    = "MockS3/terraform.tfstate"
    region = "ap-south-1"
  }
}
