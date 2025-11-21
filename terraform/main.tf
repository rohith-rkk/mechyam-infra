terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.project}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false
  map_public_ip_on_launch = true
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "${var.project}-eks"
  cluster_version = "1.30"

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_size  = 1
      max_size      = 1
      min_size      = 1
      instance_types = ["t3.micro"]
    }
  }

  enable_irsa = true
}

output "kubeconfig" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
