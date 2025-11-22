output "instance_profile_name" {
  description = "Instance profile name to attach to EC2 / launch template"
  value       = aws_iam_instance_profile.ec2_ssm_profile.name
}

output "instance_profile_arn" {
  description = "Instance profile ARN"
  value       = aws_iam_instance_profile.ec2_ssm_profile.arn
}

output "role_name" {
  description = "IAM role name"
  value       = aws_iam_role.ec2_ssm_role.name
}
