data "aws_instances" "app_servers" {
  filter {
    name   = "tag:Role"
    values = ["app-server"]
  }
 
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}
 
resource "local_file" "prometheus_config" {
  content = templatefile("${path.module}/templates/prometheus.yml.tpl", {
    app_targets = data.aws_instances.app_servers.private_ips
  })
 
  filename = "${path.module}/generated/prometheus.yml"
}
 