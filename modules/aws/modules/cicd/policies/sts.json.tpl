{
    "Version": "2012-10-17",
    "Id": "Allow use of STS",
    "Statement": [
        {
            "Sid": "stsAssumeRole",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "sts:GetCallerIdentity"
            ],
            "Resource": "${cbcp_role_arn}"
        }
    ]
}