resource "aws_instance" "nebo_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  monitoring             = true ## detailed monitoring
  iam_instance_profile   = aws_iam_instance_profile.instance.name
  key_name               = var.instance_name
  user_data              = local.userdata
  tags = {
    Name = var.instance_name
  }
}