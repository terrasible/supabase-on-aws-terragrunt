# Get current caller identity for IP restriction
data "aws_caller_identity" "current" {}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}
