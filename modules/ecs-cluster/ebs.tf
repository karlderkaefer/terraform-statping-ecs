data "aws_iam_policy_document" "rexray-ebs" {
  count = var.instance_enabled_rexray && var.instance_enabled_ebs_rexray ? 1 : 0
  statement {
    actions = [
      "ec2:DescribeSnapshots",
      "ec2:AttachVolume",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteVolume",
      "ec2:DeleteSnapshot",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeInstances",
      "ec2:CopySnapshot",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DetachVolume",
      "ec2:ModifySnapshotAttribute",
      "ec2:ModifyVolumeAttribute",
      "ec2:DescribeTags",
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "rexray-efs" {
  count = var.instance_enabled_rexray && var.instance_enabled_efs_rexray ? 1 : 0
  statement {
    actions = [
      "elasticfilesystem:CreateFileSystem",
      "elasticfilesystem:CreateMountTarget",
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "elasticfilesystem:CreateTags",
      "elasticfilesystem:DeleteFileSystem",
      "elasticfilesystem:DeleteMountTarget",
      "ec2:DeleteNetworkInterface",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "rexray-ebs" {
  count  = var.instance_enabled_rexray && var.instance_enabled_ebs_rexray ? 1 : 0
  policy = data.aws_iam_policy_document.rexray-ebs[0].json
  name   = "${var.name}-rexray-ebs"
}

resource "aws_iam_policy" "rexray-efs" {
  count  = var.instance_enabled_rexray && var.instance_enabled_efs_rexray ? 1 : 0
  policy = data.aws_iam_policy_document.rexray-efs[0].json
  name   = "${var.name}-rexray-efs"
}

resource "aws_iam_role_policy_attachment" "rexray-ebs" {
  count      = var.instance_enabled_rexray && var.instance_enabled_ebs_rexray ? 1 : 0
  policy_arn = aws_iam_policy.rexray-ebs[0].arn
  role       = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role_policy_attachment" "rexray-efs" {
  count      = var.instance_enabled_rexray && var.instance_enabled_efs_rexray ? 1 : 0
  policy_arn = aws_iam_policy.rexray-efs[0].arn
  role       = aws_iam_role.ecs_instance_role.name
}
