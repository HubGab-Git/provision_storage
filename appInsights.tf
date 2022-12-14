resource "aws_applicationinsights_application" "instance" {
  resource_group_name = aws_resourcegroups_group.instance.name
  auto_config_enabled = true
  auto_create         = true
  cwe_monitor_enabled = true
}
