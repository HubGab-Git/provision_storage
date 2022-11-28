resource "aws_instance" "nebo_instance" {
  ami                    = "ami-01cae1550c0adea9c"
  instance_type          = "t3.nano"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  monitoring             = true ## detailed monitoring
  tags = {
    Name = "NeboInstance"
  }
}