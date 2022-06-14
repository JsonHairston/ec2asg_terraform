## Creating Instance Resources
resource "aws_launch_configuration" "terraform_config" {
  name                   = "web_config"
  image_id               = var.image_id
  instance_type          = var.instance_type
  security_groups = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  
  user_data = file("apache.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terraform_asg" {
  name                 = "terraform-asg-example"
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]
  launch_configuration = aws_launch_configuration.terraform_config.name
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  force_delete         = true


  lifecycle {
    create_before_destroy = true
  }
}