resource "shoreline_notebook" "increase_of_the_errors_second_rate_for_tomcat_server" {
  name       = "increase_of_the_errors_second_rate_for_tomcat_server"
  data       = file("${path.module}/data/increase_of_the_errors_second_rate_for_tomcat_server.json")
  depends_on = [shoreline_action.invoke_threshold_check,shoreline_action.invoke_tomcat_diagnosis,shoreline_action.invoke_get_tomcat_logs,shoreline_action.invoke_check_application_status]
}

resource "shoreline_file" "threshold_check" {
  name             = "threshold_check"
  input_file       = "${path.module}/data/threshold_check.sh"
  md5              = filemd5("${path.module}/data/threshold_check.sh")
  description      = "The host machine running the Tomcat server is experiencing high CPU or memory usage, causing the server to become unresponsive and generate errors."
  destination_path = "/agent/scripts/threshold_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "tomcat_diagnosis" {
  name             = "tomcat_diagnosis"
  input_file       = "${path.module}/data/tomcat_diagnosis.sh"
  md5              = filemd5("${path.module}/data/tomcat_diagnosis.sh")
  description      = "A software update or configuration change was made to the Tomcat server that caused it to malfunction and produce errors."
  destination_path = "/agent/scripts/tomcat_diagnosis.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_tomcat_logs" {
  name             = "get_tomcat_logs"
  input_file       = "${path.module}/data/get_tomcat_logs.sh"
  md5              = filemd5("${path.module}/data/get_tomcat_logs.sh")
  description      = "Check the server logs to determine the cause of the errors and identify any patterns or trends that may be contributing to the increase in errors."
  destination_path = "/agent/scripts/get_tomcat_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_application_status" {
  name             = "check_application_status"
  input_file       = "${path.module}/data/check_application_status.sh"
  md5              = filemd5("${path.module}/data/check_application_status.sh")
  description      = "Check the deployed application to ensure that it is functioning correctly and that there are no coding errors or configuration issues."
  destination_path = "/agent/scripts/check_application_status.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_threshold_check" {
  name        = "invoke_threshold_check"
  description = "The host machine running the Tomcat server is experiencing high CPU or memory usage, causing the server to become unresponsive and generate errors."
  command     = "`/agent/scripts/threshold_check.sh`"
  params      = ["NODE_NAME","MEMORY_THRESHOLD","CPU_THRESHOLD"]
  file_deps   = ["threshold_check"]
  enabled     = true
  depends_on  = [shoreline_file.threshold_check]
}

resource "shoreline_action" "invoke_tomcat_diagnosis" {
  name        = "invoke_tomcat_diagnosis"
  description = "A software update or configuration change was made to the Tomcat server that caused it to malfunction and produce errors."
  command     = "`/agent/scripts/tomcat_diagnosis.sh`"
  params      = ["TOMCAT_CONFIG_FILE","EXPECTED_TOMCAT_SETTINGS","TOMCAT_POD_NAME"]
  file_deps   = ["tomcat_diagnosis"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_diagnosis]
}

resource "shoreline_action" "invoke_get_tomcat_logs" {
  name        = "invoke_get_tomcat_logs"
  description = "Check the server logs to determine the cause of the errors and identify any patterns or trends that may be contributing to the increase in errors."
  command     = "`/agent/scripts/get_tomcat_logs.sh`"
  params      = ["TOMCAT_POD_NAME","TOMCAT_CONTAINER_NAME"]
  file_deps   = ["get_tomcat_logs"]
  enabled     = true
  depends_on  = [shoreline_file.get_tomcat_logs]
}

resource "shoreline_action" "invoke_check_application_status" {
  name        = "invoke_check_application_status"
  description = "Check the deployed application to ensure that it is functioning correctly and that there are no coding errors or configuration issues."
  command     = "`/agent/scripts/check_application_status.sh`"
  params      = ["DEPLOYMENT_NAME","SERVICE_NAME","SERVICE_IP","PORT"]
  file_deps   = ["check_application_status"]
  enabled     = true
  depends_on  = [shoreline_file.check_application_status]
}

