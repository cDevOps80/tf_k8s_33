terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_scheduler_schedule" "scheduler" {
  name       = "lambda-schedule"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = "cron(* * * * ? *)"
  schedule_expression_timezone = "Asia/Kolkata"

  target {
    arn      = var.arn
    role_arn = aws_iam_role.iam_role.arn
  }
}


resource "aws_iam_role" "iam_role" {
  name = "eventbridge_lambda"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Statement1",
        "Effect": "Allow",
        "Principal": {
          "Service": "scheduler.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "role_policy" {
  role = aws_iam_role.iam_role.id
  name = "eventbridge_lambda_policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "sid1",
        "Effect": "Allow",
        "Action": "lambda:InvokeFunction",
        "Resource": "*"
      }
    ]
  })
}

