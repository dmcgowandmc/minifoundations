############################################################
## All outputs from the creation of sns topic reside here ##
############################################################

output "sns_arn" {
    description = "The ARN of the SNS topic"
    value       = module.sns_topic.this_sns_topic_arn
}
