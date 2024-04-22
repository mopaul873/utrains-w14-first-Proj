resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "utc-dev-database"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "utcuser"
  password             = "utcdev12345"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}