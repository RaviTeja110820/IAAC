############################################################
# IAM Policy for External Secrets Operator
############################################################

resource "aws_iam_policy" "external_secrets_policy" {

  name = "${var.project_name}-${var.environment}-external-secrets-policy"

  description = "Allows External Secrets Operator to read AWS Secrets Manager"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "secretsmanager:GetSecretValue",

          "secretsmanager:DescribeSecret"

        ]

        Resource = "*"

      }

    ]

  })

}