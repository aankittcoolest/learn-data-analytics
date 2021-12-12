
provider "aws" {
  region = "ap-south-1"
}

resource "aws_kinesis_stream" "test_stream" {
  name             = "CadabraOrders"
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = "test"
  }
}