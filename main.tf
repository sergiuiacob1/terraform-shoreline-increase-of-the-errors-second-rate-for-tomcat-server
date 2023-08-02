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

module "increase_of_the_errors_second_rate_for_tomcat_server" {
  source    = "./modules/increase_of_the_errors_second_rate_for_tomcat_server"

  providers = {
    shoreline = shoreline
  }
}