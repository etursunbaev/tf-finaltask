resource "aws_ecr_repository" "this_repo" {
  name                 = "ghost-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

resource "aws_ecr_registry_policy" "ecr_registry_policy" {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "testpolicy",
        Effect = "Allow",
        Principal = {
          "AWS" : "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = [
          "ecr:*"
        ],
        Resource = [
          "arn:${data.aws_partition.current.partition}:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/*"
        ]
      }
    ]
  })
}
resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  repository = aws_ecr_repository.this_repo.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}