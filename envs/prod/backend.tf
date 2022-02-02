terraform {
  cloud {
    organization = "elanco_animal_health"
    workspaces {
      name = "sol-fern-prod"
    }
  }
}
