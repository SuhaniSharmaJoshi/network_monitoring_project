terraform{
    required_version = ">= 1.5.0"

    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }

    cloud {
      organization = "SuhaniOrg"
      workspaces {
        name = "network_monitoring_project"
      }
    }
}
  provider "aws" {
    region = var.region
    
  }