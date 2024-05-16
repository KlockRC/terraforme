terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_ecs_cluster" "example_cluster" {
  name = "xirimbaugos"
}

resource "aws_ecs_task_definition" "example_task_definition" {
  family                   = "growthsuplements"
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      "name": "cesinha",
      "image": "klockrc/dev-ops-29-02-2024-rg:tagname",
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        },
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "example_service" {
  name            = "cesazika"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = ["subnet-0af92731be6ba7875"]
    security_groups = ["sg-0eaefbc0185d0a1f9"]
#    assign_public_ip = true
  }
}


# Criação de uma instância RDS MySQL
resource "aws_db_instance" "example_db_instance" {
  identifier             = "cuzudo"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "Mudar123"
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.example_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.example_db_security_group.id]
}

# Criação de um grupo de subnets para o RDS
resource "aws_db_subnet_group" "example_db_subnet_group" {
  name       = "rodingers"
  subnet_ids = ["subnet-07328e61d76f495bf", "subnet-0af92731be6ba7875"]
}

# Criação de um security group para o RDS
resource "aws_security_group" "example_db_security_group" {
  name        = "robertojusto"
  description = "este grupo esta focado em MySQL database"
  vpc_id      = "vpc-0081aee0b7d5173d7"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
