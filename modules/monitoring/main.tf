# TERRAFORM LOCALS (monitoring/main.tf)
locals {
  app_targets = [
    for ip in data.aws_instances.app_servers.private_ips : "${ip}:9100"
  ]

  prometheus_config = templatefile("${path.module}/templates/prometheus.yml.tpl", {
    targets = local.app_targets
  })

  prometheus_user_data = fileexists("${path.module}/scripts/prometheus_userdata.sh") ? file("${path.module}/scripts/prometheus_userdata.sh") : null

  grafana_user_data = fileexists("${path.module}/scripts/grafana_userdata.sh") ? file("${path.module}/scripts/grafana_userdata.sh") : null

  provisioner_connection = {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }
}

# EC2 for Prometheus + PROVISIONERS
resource "aws_instance" "prometheus" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.monitoring_sg_id]
  key_name               = var.key_name
  iam_instance_profile   = var.prometheus_instance_profile

  user_data  = local.prometheus_user_data
  depends_on = [data.aws_instances.app_servers]

  tags = merge(var.tags, {
    Name = "${var.ResourcePrefix}-Prometheus"
  })

  provisioner "file" {
    source      = "${path.module}/generated/prometheus.yml"
    destination = "/tmp/prometheus.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.private_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/prometheus.yml /etc/prometheus/prometheus.yml",
      "sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml",
      "sudo systemctl restart prometheus",
      "sudo systemctl enable prometheus"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.private_ip
    }
  }
}

# EC2 for Grafana.
resource "aws_instance" "grafana" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.grafana_instance_profile

  depends_on = [aws_instance.prometheus] // Ensures Prometheus comes first

  user_data = local.grafana_user_data

  tags = merge(var.tags, {
    Name = "${var.ResourcePrefix}-Grafana"
  })
}
