terraform {
  required_providers {
    mgc = {
      version = "~> 0.30.0"
      source  = "MagaluCloud/mgc"
    }
  }
}

provider "mgc" {
  region = "br-se1"
}

