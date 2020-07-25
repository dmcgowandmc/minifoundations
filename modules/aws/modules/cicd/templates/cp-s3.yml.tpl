version: 0.2

env:
  variables:
    s3: "s3"
            
phases:
  build:
    commands:
      - aws s3 cp . s3://${bucket} --recursive