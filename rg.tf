terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "aws" {
  region = "us-east-1"
}

# Crie uma VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Crie um cluster do ECS
resource "aws_ecs_cluster" "example_cluster" {
  name = "xirimbaugos"
}

# Crie uma definição de tarefa do ECS
resource "aws_ecs_task_definition" "example_task_definition" {
  family                   = "growthsuplements"
  network_mode             = "awsvpc"

  cpu                      = "256"  # Adicione a configuração de CPU para Fargate
  memory                   = "512"  # Adicione a configuração de memória para Fargate

  container_definitions = jsonencode([
    {
      "name": "cesinha",
      "image": "klockrc/nakassite:toplingo",
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

# Crie um serviço do ECS
resource "aws_ecs_service" "example_service" {
  name            = "ceasar"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task_definition.arn
  desired_count   = 1

  launch_type     = "FARGATE"  # Especifique o tipo de lançamento como Fargate

  network_configuration {
    subnets         = ["subnet-0af92731be6ba7875"]
    security_groups = ["sg-0eaefbc0185d0a1f9"]
    assign_public_ip = true  # Atribua um IP público para as tarefas do Fargate
  }
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

resource "azurerm_resource_group" "example" {
  name     = "cuzcuz-16052024"
  location = "East US"
}

# Crie um contêiner personalizado com uma porta aberta
resource "azurerm_container_group" "example_container_group" {
  name                = "ovocuzido"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  os_type       = "Linux"
  dns_name_label = "example-container-group"

  container {
    name   = "xerango"
    image  = "klockrc/nakassite:toplingo"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}


resource "azurerm_virtual_network" "example" {
  name                = "chumate"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "kubernets"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "kubernets"
    admin_username = "chibiu"
    admin_password = "Mudar123"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}