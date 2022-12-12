resource "aws_iam_user" "nebo" {
  count = 2
  name  = join("-", ["neboUser", count.index])
}

resource "aws_iam_role" "s3_read_only" {
  name               = "S3ReadOnly"
  assume_role_policy = data.aws_iam_policy_document.assume_role_read_only.json
}

resource "aws_iam_role" "s3_read_write" {
  name               = "S3ReadWrite"
  assume_role_policy = data.aws_iam_policy_document.assume_role_read_write.json
}


data "aws_iam_policy_document" "assume_role_read_only" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.nebo[0].arn]
    }
  }
}

data "aws_iam_policy_document" "assume_role_read_write" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.nebo[1].arn]
    }
  }
}

data "aws_iam_policy_document" "s3_read_only" {
  statement {

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"
    ]

    resources = [
      "*",
    ]
  }
}


data "aws_iam_policy_document" "s3_read_write" {
  statement {

    actions = [
      "s3:*",
      "s3-object-lambda:*"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "s3_read_write" {
  policy = data.aws_iam_policy_document.s3_read_write.json
}

resource "aws_iam_policy" "s3_read_only" {
  policy = data.aws_iam_policy_document.s3_read_only.json
}

resource "aws_iam_policy" "replication" {
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "s3_read_write" {
  role       = aws_iam_role.s3_read_write.name
  policy_arn = aws_iam_policy.s3_read_write.arn
}

resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.s3_read_only.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_iam_role" "replication" {
  name               = "replication"
  assume_role_policy = data.aws_iam_policy_document.assume_role_replication.json
}


data "aws_iam_policy_document" "assume_role_replication" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "replication" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.nebo.arn,
    ]
  }
  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "${aws_s3_bucket.nebo.arn}/*",
    ]
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = [
      "${aws_s3_bucket.nebo_replication.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "sns" {

  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      "arn:aws:sns:*:*:s3-event-notification-topic",
    ]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.nebo.arn]
    }
  }
}


### Instance profile

resource "aws_iam_instance_profile" "instance" {
  name = "ec2_profile"
  role = aws_iam_role.instance.name
}

resource "aws_iam_role" "instance" {
  name               = "instance-role"
  description        = "The role for SSM connection and CLoudwatch monitoring"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
}
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy" "ssm" {
  name = "EC2-Inline-Policy"
  role = aws_iam_role.instance.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}