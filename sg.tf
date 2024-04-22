resource "aws_security_group" "albsg" {
    vpc_id = aws_vpc.myvpc.id
    description = "Allow http and https"
    name = "lb-sg"
  


   ingress {
    description = "allow http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
   }

   ingress {
    description = "allow https"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
     }

     tags = {
        env = "Dev"
        Team = "config management"
     }
}

resource "aws_security_group" "bastion-host-sg" {
    name = "bastion-sg"
    vpc_id = aws_vpc.myvpc.id
    description = "Allow ssh"
    
    ingress {
        description = "Allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      env = "dev"
      Team = "config management"
    }
}

resource "aws_security_group" "app-server-sg" {
    name = "Aserver-sg"
    vpc_id = aws_vpc.myvpc.id
    description = "Allow http ahd ssh"
    
    ingress {
        description = "Allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

       ingress {
        description = "Allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      env = "dev"
      Team = "config management"
    }
}

resource "aws_security_group" "database-sg" {
    name = "db-sg"
    vpc_id = aws_vpc.myvpc.id
    description = "Allow http ahd ssh"




       ingress {
        description = "Allow mysql"
        from_port = 3306
        to_port = 3306
        protocol = "mysql"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      env = "dev"
      Team = "config management"
    }
}




