output "waf_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.waf.arn
}

output "waf_id" {
  description = "WAF Web ACL ID"
  value       = aws_wafv2_web_acl.waf.id
}
