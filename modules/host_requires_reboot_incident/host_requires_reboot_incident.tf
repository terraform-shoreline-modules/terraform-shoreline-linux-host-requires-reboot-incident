resource "shoreline_notebook" "host_requires_reboot_incident" {
  name       = "host_requires_reboot_incident"
  data       = file("${path.module}/data/host_requires_reboot_incident.json")
  depends_on = [shoreline_action.invoke_system_check,shoreline_action.invoke_reboot_script,shoreline_action.invoke_reboot_status_check]
}

resource "shoreline_file" "system_check" {
  name             = "system_check"
  input_file       = "${path.module}/data/system_check.sh"
  md5              = filemd5("${path.module}/data/system_check.sh")
  description      = "The host system might have encountered a critical error or failure, leading to a reboot requirement."
  destination_path = "/agent/scripts/system_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "reboot_script" {
  name             = "reboot_script"
  input_file       = "${path.module}/data/reboot_script.sh"
  md5              = filemd5("${path.module}/data/reboot_script.sh")
  description      = "Reboot the host"
  destination_path = "/agent/scripts/reboot_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "reboot_status_check" {
  name             = "reboot_status_check"
  input_file       = "${path.module}/data/reboot_status_check.sh"
  md5              = filemd5("${path.module}/data/reboot_status_check.sh")
  description      = "Verify that the host has successfully rebooted and that all services and applications have started up correctly."
  destination_path = "/agent/scripts/reboot_status_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_system_check" {
  name        = "invoke_system_check"
  description = "The host system might have encountered a critical error or failure, leading to a reboot requirement."
  command     = "`chmod +x /agent/scripts/system_check.sh && /agent/scripts/system_check.sh`"
  params      = ["DISK_PATH"]
  file_deps   = ["system_check"]
  enabled     = true
  depends_on  = [shoreline_file.system_check]
}

resource "shoreline_action" "invoke_reboot_script" {
  name        = "invoke_reboot_script"
  description = "Reboot the host"
  command     = "`chmod +x /agent/scripts/reboot_script.sh && /agent/scripts/reboot_script.sh`"
  params      = ["HOSTNAME"]
  file_deps   = ["reboot_script"]
  enabled     = true
  depends_on  = [shoreline_file.reboot_script]
}

resource "shoreline_action" "invoke_reboot_status_check" {
  name        = "invoke_reboot_status_check"
  description = "Verify that the host has successfully rebooted and that all services and applications have started up correctly."
  command     = "`chmod +x /agent/scripts/reboot_status_check.sh && /agent/scripts/reboot_status_check.sh`"
  params      = ["HOSTNAME","SERVICE_NAME"]
  file_deps   = ["reboot_status_check"]
  enabled     = true
  depends_on  = [shoreline_file.reboot_status_check]
}

