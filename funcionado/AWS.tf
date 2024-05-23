terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.k8s.endpoint
  token                  = data.aws_eks_cluster_auth.k8s.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.k8s.certificate_authority.0.data)
}

data "aws_eks_cluster_auth" "k8s" {
  name = aws_eks_cluster.k8s.name
}

# Crie um security group para o RDS
resource "aws_security_group" "example_db_security_group" {
  name        = "livia-23052024-2"
  description = "este grupo esta focado em MySQL database"
  vpc_id      = "vpc-0081aee0b7d5173d7"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# Criação de um grupo de subnets para o RDS
resource "aws_db_subnet_group" "example_db_subnet_group" {
  name       = "rg-23052024-2"
  subnet_ids = ["subnet-04894801b78b506d2", "subnet-05c1ce333c4a6494a"]
}

# Criação de uma instância RDS MySQL
resource "aws_db_instance" "example_db_instance" {
  identifier             = "db-xorango"
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

# Crie um cluster do ECS
resource "aws_ecs_cluster" "example_cluster" {
  name = "xirimbaugos"
}

# Crie uma definição de tarefa do ECS
resource "aws_ecs_task_definition" "example_task_definition" {
  family                   = "growthsuplements"
  network_mode             = "awsvpc"

  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      "name": "cesinha",
      "image": "klockrc/sapequinhassite:zen",
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ])
}

# Crie um serviço do ECS
resource "aws_ecs_service" "example_service" {
  name            = "ceasar"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task_definition.arn
  desired_count   = 1

  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-04894801b78b506d2", "subnet-05c1ce333c4a6494a"]
    security_groups = [aws_security_group.example_db_security_group.id]
    assign_public_ip = true
  }
}

# ECS Task Definition for Adminer
resource "aws_ecs_task_definition" "adminer_task_definition" {
  family                   = "adminer"
  network_mode             = "awsvpc"

  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      "name": "adminer",
      "image": "adminer",
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ]
    }
  ])
}

# ECS Service for Adminer
resource "aws_ecs_service" "adminer_service" {
  name            = "adminer"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.adminer_task_definition.arn
  desired_count   = 1

  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-04894801b78b506d2", "subnet-05c1ce333c4a6494a"]
    security_groups = [aws_security_group.example_db_security_group.id]
    assign_public_ip = true
  }
}

resource "aws_eks_cluster" "k8s" {
  role_arn = "arn:aws:iam::260038652745:role/LabRole"
  name     = "teste-kube-aws"
  version  = "1.29"
  vpc_config {
    subnet_ids              = ["subnet-04894801b78b506d2", "subnet-05c1ce333c4a6494a"]
    endpoint_public_access  = true
  }
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.k8s.name
  node_group_name = "node_group_k8s"
  node_role_arn   = "arn:aws:iam::260038652745:role/LabRole"
  subnet_ids      = ["subnet-04894801b78b506d2", "subnet-05c1ce333c4a6494a"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }
}

resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name = "nginx-deployment"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "klockrc/tamissite:scribbo"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
