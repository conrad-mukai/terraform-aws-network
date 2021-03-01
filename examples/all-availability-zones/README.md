# Network Example

Deployment of the Terraform network module.

## Quick Start

To run the example do the following:
1. Create an EC2 key pair.
1. Create a `terraform.tfvars` file from `terraform.tfvars.example`.
1. Fill in all the empty fields in `terraform.tfvars`. You should set
   `private_key` to the path for the private key that corresponds to the
   `key_name` parameter. Set `authorized_key` to a personal public key
   (something like `~/.ssh/id_rsa.pub`).
1. Run `terraform init`.
1. Run `terraform apply`.
1. The code will create a VPC.

## Details

The example determines the names of the availability zones for a given region
and creates a VPC that spans all of them.

## Test Bastion Access

You can test ssh access to the internal server via the bastion by adding the
following to you `~/.ssh/config` file:

    Host bastion
        HostName <bastion-ip>
        User guest
        IdentityFile <your-private-key>

    Host 172.16.*
        User ec2-user
        IdentityFile <private-key-from-AWS-key-pair>
        ProxyCommand ssh -q bastion -W %h:%p

Then you will be able to ssh directly to the internal server using the private
IP address.

> Normally you would not use the same key used to configure the bastion as you
> would for internal servers. This is only done for convenience in setting up
> the example.

## Clean Up

To destroy the resources you must manually remove the Elastic IP from the
Terraform state by doing the following:

    terraform state rm module.network.aws_eip.nat_gateways

You can then run `terraform destroy`. Use the AWS console to manually release
the elastic IP.
