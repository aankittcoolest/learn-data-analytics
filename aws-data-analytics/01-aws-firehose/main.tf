
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
  bucket = "s3-aankittcoolest-terraform-firehose"
  acl    = "private"
  force_destroy = true
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"
  assume_role_policy = file("${path.module}/conf/assumeRoleFirehosePolicy.json")
}

resource "aws_iam_policy" "firehose_policy" {
  name        = "firehose-policy"
  description = "Firehose policy"
  policy      = file("${path.module}/conf/firehosePolicy.json")
}

resource "aws_iam_policy_attachment" "test-attach-firehose" {
  name       = "test-attachment-firehose"
  roles      = [aws_iam_role.firehose_role.name]
  policy_arn = aws_iam_policy.firehose_policy.arn
}