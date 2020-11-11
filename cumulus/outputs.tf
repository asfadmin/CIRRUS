# ---------
# Cumulus workflow config
output "workflow_config" {
  value = module.cumulus.workflow_config
}

# ---------
# Cumulus Tasks
output "sf_sqs_report_task" {
  value = module.cumulus.sf_sqs_report_task
}
output "fake_processing_task" {
  value = module.cumulus.fake_processing_task
}
output "discover_granules_task" {
  value = module.cumulus.discover_granules_task
}
output "discover_pdrs_task" {
  value = module.cumulus.discover_pdrs_task
}
output "files_to_granules_task" {
  value = module.cumulus.files_to_granules_task
}
output "hello_world_task" {
  value = module.cumulus.hello_world_task
}
output "hyrax_metadata_updates_task" {
  value = module.cumulus.hyrax_metadata_updates_task
}
output "move_granules_task" {
  value = module.cumulus.move_granules_task
}
output "parse_pdr_task" {
  value = module.cumulus.parse_pdr_task
}
output "pdr_status_check_task" {
  value = module.cumulus.pdr_status_check_task
}
output "post_to_cmr_task" {
  value = module.cumulus.post_to_cmr_task
}
output "queue_granules_task" {
  value = module.cumulus.queue_granules_task
}
output "queue_pdrs_task" {
  value = module.cumulus.queue_pdrs_task
}
output "sync_granule_task" {
  value = module.cumulus.sync_granule_task
}

# ---------
# Cumulus IAM Resources
output "lambda_processing_role_arn" {
  value = module.cumulus.lambda_processing_role_arn
}
output "no_ingress_all_egress" {
  value = aws_security_group.no_ingress_all_egress
}

# ---------
# Cumulus URIs
output "archive_api_uri" {
  value = module.cumulus.archive_api_uri
}
output "archive_api_redirect_uri" {
  value = module.cumulus.archive_api_redirect_uri
}
output "s3_credentials_redirect_uri" {
  value = module.cumulus.s3_credentials_redirect_uri
}
# ---------
# Workflow reporting SNS topics
output "report_executions_sns_topic_arn" {
  value = module.cumulus.report_executions_sns_topic_arn
}
output "report_granules_sns_topic_arn" {
  value = module.cumulus.report_executions_sns_topic_arn
}
output "report_pdrs_sns_topic_arn" {
  value = module.cumulus.report_pdrs_sns_topic_arn
}
output "subnet_ids" {
  value = data.aws_subnet_ids.subnet_ids.ids
}

output "ecs_cluster_arn" {
  value = module.cumulus.ecs_cluster_arn
}

output "log2elasticsearch_lambda_function_arn" {
  value = module.cumulus.log2elasticsearch_lambda_function_arn
}

output "cmr_environment" {
  value = var.cmr_environment
}