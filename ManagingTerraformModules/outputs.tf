output "instance_id" {

  value = module.ec2_instance.instance_id

}

output "public_ip" {

  value = module.ec2_instance.public_ip

}

output "public_dns" {

  value = module.ec2_instance.public_dns

}