# Network Module Test

Test for the Terraform network module.

## Quick Start

To run the test do the following:
1. Create a `terraform.tfvars` file from `terraform.tfvars.template`.
1. Fill in all the empty fields in `terraform.tfvars`. You should set
   `private_key_path` to the path for the private key that corresponds to the
   `key_name` parameter. Set `authorized_key_path` to a personal public key
   (something like `~/.ssh/id_rsa.pub`).
1. Run `terraform init`.
1. Run `terraform apply`.
1. Enter the AWS region when prompted.
1. The code will create a VPC.

## Details

The test determines a list of availability zones for the specified region, and
creates a list with half the availabilty zones. For regions with an odd number
of availability zones round up (so for regions with 3 availability zones the
list will contain 2).

We then produce a network with the following parameters:

| Variable | Value |
| -------- | ----- |
| `vpc_cidr` | 172.16.0.0/20 |
| `public_cidr_prefix` | 28 |
| `private_cidr_prefix` | 24 |

## Experimentation

You can run terraform plan to see how the test behaves in different regions.
Simply capture the output in a log file like so to see what would have
happened:

    $ terraform plan -no-color -var region=us-east-1 | tee terraform.log

Note the AMIs are region specific so you need to adjust the AMI settings if you
actually apply the code in a new region. Also running plan in a different
region after running apply can lead to inconsistencies in list sizes that
result in runtime errors.
