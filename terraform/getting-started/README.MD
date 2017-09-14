# Terraform Getting Started
This directory contains the files generated from going through the [Terraform getting started guide][1] with a few modifications of my own to better understand how to manipulate things. It requires having Terraform installed and a valid AWS account.

The version of Terraform that was used for these examples was v0.10.2.

## Assumptions
The code in this directory assumes you are using a credential file for AWS access located at `~/.aws/credentials` per the [AWS documentation][2]. I created a separate profile called "learning" that I used for my testing.

This code also assumes that you have a key pair created in AWS for injection into your instances. You can specify which key to use via the "key_name" variable in your **terraform.tfvars** file or enter it when prompted.

## License

This material is licensed under the MIT License.

[1]: https://www.terraform.io/intro/getting-started/install.html
[2]: http://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html
