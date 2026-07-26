############################################################
# IAM Role for External Secrets Operator
############################################################

resource "aws_iam_role" "external_secrets_role" {

  name = "${var.project_name}-${var.environment}-ExternalSecretsRole"

  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume_role.json

}

############################################################
# Assume Role Policy
############################################################

data "aws_iam_policy_document" "external_secrets_assume_role" {

  statement {

    actions = [

      "sts:AssumeRoleWithWebIdentity"

    ]

    principals {

      type = "Federated"

      identifiers = [

        var.oidc_provider_arn

      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(var.oidc_provider_url,"https://","")}:sub"

      values = [

        "system:serviceaccount:enterprise:external-secrets-sa"

      ]

    }

  }

}

############################################################
# Attach Policy
############################################################

resource "aws_iam_role_policy_attachment" "external_secrets_attach" {

  role = aws_iam_role.external_secrets_role.name

  policy_arn = aws_iam_policy.external_secrets_policy.arn

}