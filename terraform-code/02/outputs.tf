output "public_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "aws_info" {
  value = data.aws_instances.aws_info
}