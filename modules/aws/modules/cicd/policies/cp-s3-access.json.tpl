{
    "Version": "2012-10-17",
    "Id": "Secure S3 access for cp-s3 instructions"
    "Statement": [
        {
            "Sid": "ListArtefact",
            "Action": [
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${artefact_bucket}"
            ]
        },
        {
            "Sid": "GetPutArtefactThisCustomer",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${artefact_bucket}/${customer_path}/*"
            ]
        },
        {
            "Sid": "GetPutContentThisCustomer",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${customer_bucket}",
                "arn:aws:s3:::${customer_bucket}/*"
            ]
        }
    ]
}