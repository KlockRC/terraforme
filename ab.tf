terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "k8s" {
  role_arn = "arn:aws:iam::260038652745:role/LabRole"
  name     = "teste-kube-aws"
  version  = "1.29"
  vpc_config {
    subnet_ids              = ["subnet-05c1ce333c4a6494a", "subnet-04894801b78b506d2", "subnet-0fec9f58a53374f0f"]
    endpoint_public_access  = true
  }
}

resource "aws_eks_node_group" "node" {
  cluster_name   = aws_eks_cluster.k8s.name
  node_group_name = "node_group_k8s"
  node_role_arn  = "arn:aws:iam::260038652745:role/LabRole"
  subnet_ids     = ["subnet-05c1ce333c4a6494a", "subnet-04894801b78b506d2", "subnet-0fec9f58a53374f0f"]

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
          image = "klockrc/paivassite:paiva-ia"

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
