resource "aws_iam_user" "nebo_efs" {
  name  = "neboUser-efs"
}

resource "aws_iam_user_policy" "nebo_user_efs" {
  name = "nebo_user_efs"
  user = aws_iam_user.nebo_efs.name
  policy = data.aws_iam_policy_document.nebo_user_efs.json
}

data "aws_iam_policy_document" "nebo_user_efs" {
  statement {
    actions = [
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeReplicationConfigurations",
      "elasticfilesystem:DescribeMountTargets",
      "elasticfilesystem:CreateFileSystem",
      "elasticfilesystem:CreateReplicationConfiguration",
      "elasticfilesystem:DeleteReplicationConfiguration",
      "elasticfilesystem:CreateMountTarget",
      "elasticfilesystem:DescribeMountTargetSecurityGroups",
      "elasticfilesystem:ModifyMountTargetSecurityGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeAvailabilityZones"
    ]
    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "ec2-instance-connect:SendSSHPublicKey"
    ]
    resources = [
      aws_instance.nebo_instance.arn,
    ]
  }
}