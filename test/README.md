# Network Module Test

Test for the Terraform network module.

## Warning

This test will create instances and NAT gateways. These resources will incur a
cost.

## Quick Start

To run the test do the following:
1. Create a `terraform.tfvars` file from `terraform.tfvars.template`.
1. Fill in all the empty fields in `terraform.tfvars`. You should set
   `private_key_path` to the path for the private key that corresponds to the
   `key_name` parameter. Set `authorized_key_path` to a personal public key
   (something like `~/.ssh/id_rsa.pub`).
1. Run `terraform init`.
1. Run `terraform apply`.
1. The code will create a VPC.

## Details

The test determines the names of the availability zones for a given region and
creates a VPC that spans all of them.

## Experimentation

You can run terraform plan to see how the test behaves in different regions.
Simply capture the output in a log file like so to see what would have
happened:

    $ terraform plan -no-color -var region=us-east-1 | tee terraform.log

Note the AMIs are region specific so you need to adjust the AMI settings if you
actually apply the code in a new region. Also running plan in a different
region after running apply can lead to inconsistencies in list sizes that
result in runtime errors.
