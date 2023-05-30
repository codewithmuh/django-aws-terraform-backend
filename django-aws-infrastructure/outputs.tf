output "prod_lb_domain" {
  value = aws_lb.prod.dns_name
}