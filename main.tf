terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "host_requires_reboot_incident" {
  source    = "./modules/host_requires_reboot_incident"

  providers = {
    shoreline = shoreline
  }
}