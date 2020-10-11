data "aws_iam_policy_document" "ebs-rexray" {
  count = var.instance_enabled_rexray ? 1 : 0
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

resource "aws_iam_policy" "ebs-rexray" {
  count  = var.instance_enabled_rexray ? 1 : 0
  policy = data.aws_iam_policy_document.ebs-rexray[0].json
  name   = "${var.name}-rexray"
}

resource "aws_iam_role_policy_attachment" "ebs-rexray" {
  count      = var.instance_enabled_rexray ? 1 : 0
  policy_arn = aws_iam_policy.ebs-rexray[0].arn
  role       = aws_iam_role.ecs_instance_role.name
}
