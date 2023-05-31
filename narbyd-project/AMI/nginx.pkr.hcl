variable "region" {
  type    = string
  default = "us-east-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }


# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.
source "amazon-ebs" "narbyd-nginx" {
  ami_name      = "narbyd-nginx-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "RHEL-8.2.0_HVM-20210907-x86_64-0-Hourly2-GP2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["939895954199"]
  }
  ssh_username = "ec2-user"
  tag {
    key   = "Name"
    value = "narbyd-nginx"
  }
}


# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.narbyd-nginx"]

  provisioner "shell" {
    script = "nginx.sh"
  }
}