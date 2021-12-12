
provider "aws" {
  region = "ap-south-1"
}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "PurchaseLogs"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.bucket.arn
    buffer_size = 5
    buffer_interval = 60
  }
}


resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "s3-aankittcoolest-"
  acl    = "private"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"
  assume_role_policy = file("${path.module}/conf/assumeRolePolicy.json")
}
