###################################
# S3 IAM User for Supabase Storage
###################################

# IAM user for S3 access
resource "aws_iam_user" "supabase_s3_user" {
  name = "${var.name_prefix}-${var.env}-supabase-s3-user"
  path = "/"

  tags = var.tags
}

# S3 admin policy for the user
resource "aws_iam_user_policy" "supabase_s3_policy" {
  name = "${var.name_prefix}-${var.env}-supabase-s3-policy"
  user = aws_iam_user.supabase_s3_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Access key for the S3 user
resource "aws_iam_access_key" "supabase_s3_access_key" {
  user = aws_iam_user.supabase_s3_user.name
}
