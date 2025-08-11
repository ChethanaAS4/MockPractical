resource "aws_s3_bucket" "MockS3" {
  bucket = "mock-test-bucket-cas-aug11"

  tags = {
    Name        = "Mock bucket"
  }
}
