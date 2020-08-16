{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "CFGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${cf_oai_iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "${s3_bucket_arn}/*"
        }
    ]
}
