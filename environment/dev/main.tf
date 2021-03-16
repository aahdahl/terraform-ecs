terraform {
  backend s3 {
    bucket = "systek.terraform"
    key    = "dev_networking"
    region = "eu-west-1"
  }
}

provider aws {
  region = "eu-west-1"
}

module networking {
  source = "../../networking"
  environment = "dev"
  name = "systek"
}

module ecs {
  source = "../../cluster"
  environment = "dev"
  name = "systek"
  vpc_id = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
}
