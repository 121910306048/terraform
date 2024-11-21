#creating public instance(ec2)
resource "aws_instance" "public" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.sg.id]
    associate_public_ip_address = true
    
    tags = {
        Name = "public"
    }
    }
#creating priavate instance(ec2)
resource "aws_instance" "priavte" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = {
        Name = "private"
    }
    }
