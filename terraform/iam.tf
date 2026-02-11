resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name        = "CloudWatchAgentPolicy"
  description = "Permissions for CloudWatch Agent"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ssm:GetParameter"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role" "ec2_role" {
    name = "ec2-cloudwatch-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

  resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
    role = aws_iam_role.ec2_role.name
    policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}
  

  resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2-instance-profile"
    role = aws_iam_role.ec2_role.name
    
  }
