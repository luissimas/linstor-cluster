terraform {
  required_providers {
    mgc = {
      version = "~> 0.30.0"
      source  = "MagaluCloud/mgc"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}

provider "mgc" {
  region = "br-se1"
}

