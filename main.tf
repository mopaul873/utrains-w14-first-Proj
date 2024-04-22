resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "utc-vpc"
    env = "dev"
    Team = "config management"
  }
  
}

resource "aws_subnet" "pubsub1" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "pubsub2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
     
  
}

resource "aws_subnet" "pubsub3" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
  
}

resource "aws_subnet" "privsub1" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.3.0/24"
  
}

resource "aws_subnet" "privsub2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
  
}

resource "aws_subnet" "privsub3" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.5.0/24"
    availability_zone = "us-east-1c"
      
    }

    resource "aws_subnet" "privsub4" {
      vpc_id = aws_vpc.myvpc.id
      cidr_block = "10.0.6.0/24"
      availability_zone = "us-east-1c"
    }

    resource "aws_subnet" "privsub5" {
      vpc_id = aws_vpc.myvpc.id
      cidr_block = "10.0.7.0/24"
      availability_zone = "us-east-1c"
    }

    resource "aws_subnet" "privsub6" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.8.0/24"
    availability_zone = "us-east-1b"
  
}

resource "aws_eip" "eip" {
  
}

resource "aws_nat_gateway" "natgw1" {
    subnet_id = aws_subnet.pubsub1.id
    allocation_id = aws_eip.eip.id
    
  
}

resource "aws_nat_gateway" "natgw2" {
    subnet_id = aws_subnet.pubsub2.id
    allocation_id = aws_eip.eip.id
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
  
}

resource "aws_instance" "bastion" {
    ami = "ami-0a1179631ec8933d7"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.bastion-host-sg.id]
    key_name = "utc-key"
    subnet_id = aws_subnet.privsub1.id

    tags = {
      env = "dev"
      Team = "config management"
    }
     
  
}
  
  resource "aws_instance" "server1" {
    ami = "ami-0a1179631ec8933d7"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.app-server-sg.id]
    key_name = "utc-key"
    subnet_id = aws_subnet.privsub1.id
    user_data = file("userdata.sh")

    tags = {
      env = "dev"
      Team = "config management"
    }
     
  
}

  resource "aws_instance" "server2" {
    ami = "ami-0a1179631ec8933d7"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.app-server-sg.id]
    key_name = "utc-key"
    subnet_id = aws_subnet.privsub2.id
    user_data = file("userdata.sh")

    tags = {
      env = "dev"
      Team = "config management"
    }
     
  
}

resource "aws_lb" "myalb" {
    name = "myalb"
    internal = false
    load_balancer_type = "application"

    security_groups =  [ aws_security_group.app-server-sg.id]
    subnets = [ aws_subnet.privsub1.id, aws_subnet.privsub2.id]
  
}

resource "aws_lb_target_group" "tg" {
    name = "utc-target-group"
    vpc_id = aws_vpc.myvpc.id
    port = 80
    protocol = "http"

    health_check {
      protocol = "http"
      path = "/"
      enabled = true
      matcher = 200
      timeout = 6
      unhealthy_threshold = 3

    }

    tags = {
      env = "dev"
      Team = "config management"
    }
  
}

resource "aws_lb_target_group_attachment" "attach1" {
    target_id = aws_instance.server1.id
    target_group_arn = aws_lb_target_group.tg.arn
    port = 80
  
}

resource "aws_lb_target_group_attachment" "attach2" {
    target_id = aws_instance.server2.id
    target_group_arn = aws_lb_target_group.tg.arn
    port = 80
  
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.myalb.arn
    port = 80
    protocol = "http"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
  
}

resource "aws_route_table" "Rt-public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table" "Rt-private" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "10.0.9.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "rta-public" {
  route_table_id = aws_route_table.Rt.id
  subnet_id = [ aws_subnet.pubsub1.id , aws_subnet.pubsub2.id , aws_subnet.privsub3.id]
  
}
