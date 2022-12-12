output "instance_dns_name" {
  value = aws_instance.nebo_instance.public_dns
  description = "Public DNS of Istance"
}