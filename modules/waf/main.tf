##############################################
# AWS WAFv2 Web ACL
##############################################

resource "aws_wafv2_web_acl" "waf" {
  name        = "${var.resource_prefix}-waf"
  description = "WAF Web ACL for ${var.resource_prefix}"
  scope       = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${var.resource_prefix}-waf"
    sampled_requests_enabled   = true
  }

  # ================================
  # Managed Rule Groups
  # ================================

  rule {
    name     = "AWSManagedCommonRules"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
      metric_name                = "AWSManagedCommonRules"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedIPReputation"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
      metric_name                = "AWSManagedIPReputation"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedAnonymousIPs"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
      metric_name                = "AWSManagedAnonymousIPs"
      sampled_requests_enabled   = true
    }
  }

  tags = merge(
    {
      Name        = "${var.resource_prefix}-waf"
      Environment = var.environment
    },
    var.tags
  )
}

##############################################
# Web ACL Association
##############################################

resource "aws_wafv2_web_acl_association" "waf_association" {
  count        = length(var.associated_arns)
  resource_arn = var.associated_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}


