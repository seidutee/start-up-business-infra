##############################################
# Launch Template for App Servers
##############################################
resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.resource_prefix}-app-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  vpc_security_group_ids = var.security_group_ids

  
 # ebs configuration
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }
  
     
   lifecycle {
    create_before_destroy = true
  }
}

##############################################
# Auto Scaling Group
##############################################
resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.resource_prefix}-app-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity           = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.resource_prefix}-app-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

##############################################
# Optional Scaling Policies
##############################################
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.resource_prefix}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.resource_prefix}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
}
