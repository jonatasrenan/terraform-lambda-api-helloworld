data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "src"
  output_path = "src.zip"
}

resource "aws_lambda_function" "example" {
  function_name = "ServerlessExample"
  filename = "src.zip"
  source_code_hash = "${base64sha256(file("src.zip"))}"
  handler = "main.handler"
  runtime = "nodejs6.10"

  role = "${aws_iam_role.lambda_exec.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

