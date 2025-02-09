# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [aws-unreleased]
* Add input variable `additional_user_data_end` to execute commands after users creation.
* Add `ssh_key_name` to support external `aws_key_pair` resource.
* Make userdata exit with code 0 when no reboot is required. This avoid cloud-init status to report an error.
* `route53_zone_id` is now optional.
* Add `autoscaling_group_id` and `autoscaling_group_arn` outputs. Those new outputs can be used to attached a Load Balancer with [autoscaling_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment#with-an-autoscaling-group-resource).

## [aws-v3.0.0]
* Introducting a breaking change by updating the terraform required_providers block to the format supported for terraform versions >=0.13

## [aws-v2.1.0]
* Add input to encrypt the root volume (true by default).

## [aws-v2.0.1]
* Update startup-script so that the upgrade command runs as an `at`. This is a bugfix in the situation that it upgrades a package that could restart the startup-script and DNS Update + user creation will never happen.

## [aws-v2.0.0]

* Revert the previous change to `associate_public_ip_address` as there were [unintended consequences](https://github.com/FairwindsOps/terraform-bastion/pull/44) with the default value.

## [aws-v1.0.0]

* Remove `associate_public_ip_address` argument; this is a potentially backwards-incompatible change that will cause public IP address allocation for the host to be determined based on the subnet in which the bastion host is launched. To ensure bastion hosts still receive public IP addresses, make sure they are launched within a public subnet.

## [aws-v0.6.2]

* Add input variable for retrieving AMIs within an AWS GovCloud account. Use this value automatically when `arn_prefix` is set to an AWS partition other than `aws`, i.e., when the `arn_prefix` has a value other than `arn:aws`.

## [aws-v0.6.1]

* Update user-data to not include a `dist-upgrade`

## [aws-v0.6.0]
* Removed optional infrastructure_bucket_region parameter. Always inherits from provider
* The path for this module has moved from the root of the repository, to the `aws` sub-directory, to accommodate a new module for Google Cloud. Please update the `source` argument of your AWS module instances to include the new path and module-specific release tag, such as: `source = "git@github.com:FairwindsOps/terraform-bastion.git//aws?ref=aws-v0.5.0"`

## [0.5.0]
### Changed
* The bastion security group now manages its rules as standalone Terraform resources, instead of inline rules, to allow non-Terraform things to manage other rules in the bastion security group. This requires the security group (and bastion) to be recreated, as Terraform does not support a straightforward transition from inline to standalone rules.

### Added
* The SSH ingress security group rule will not be created if the `ssh_cidr_blocks` module input is an empty list. This allows the module default to be overridden when no SSH rule is desired, if rules will be managed elsewhere.

## [0.4.1]
### Fixed
* Resolved Terraform 0.12 warnings around quoting.

## [0.4.0]
## Terraform 0.12 Release
### Breaking
* This module now supports Terraform 0.12. Versions <= 0.11.x are no longer supported.

### Added
* Most terraform files have been updated to 0.12 syntax
* Added `versions.tf` to ensure compatible providers and tf version
* Added `infrastructure_bucket_region` input for S3 buckets in different provider regions

## [0.3.4]
### Added 
* A special input for loading lots of SSH user's keys has been added under `additional_external_users`. The format of the list is the same as `additional_users`, however this list ends up in a separate script uploaded to S3 and then loaded as a systemd unit in the userdata boot script, to avoid data limitations on the userdata field in cloud config. This is typically used with a list of github usernames.

## [0.3.3]
### Added

* Added inputs for the ARN prefix to include support for GovCloud.

### Fixed

* Include the EC2 region when running `aws s3 sync|cp` commands, to accommodate govcloud which requires the region! This fixes exchanging sshd hostkeys with S3 in govcloud.

## [0.3.2]
### Added

* Added inputs for the AMI owner and filter, so that a different AMI could be used. Keep in mind that the UserData is strongly biased toward an Ubuntu AMI.

## [0.3.1]
### Changed
* Ignore tags on the SSH security group.
* Fixing apt install prompt issues.  Fixes #6

## [0.3.0]
### Added

* An `additional_users` input creates SSH users on the bastion. The available per-user fields are login, gecos (full name), shell, supplemental groups, and SSH authorized\_keys.
* A `additional_user-data` input adds content toward the end of EC2 User Data. The additional User Data is executed before users specified in `additional_users` are added.

### Changed

* The Auto Scaling Group (and its bastion EC2) will now be recreated when there is an update to the Launch Configuration. The new Auto Scaling Group will be created before the current one is deleted. Previously the EC2 remained untouched after a Launch Configuration update, which left its recycling to operator discretion.

### Fixed

* The Launch Configuration lifecycle block incorrectly specified ignoring `image_id`, and a new AMI caused an update to the Launch Configuration. A new AMI will now be ignored. Recycling the EC2 due to a new AMI should be less necessary as this module enables automatic Ubuntu updates.

## [0.2.0]

### Changed

* The `bastion_name` module input is now used as the hostname for DNS registration, instead of `bastion`. After running `terraform apply` and updating SSH configurations to use the new hostname, please manually remove the Route53 record named `bastion`.

### Fixed

* The Route53 zone ID is now used by the DNS registration script instead of the zone name. This is more explicit, and handles cases where multiple (public and private) zones exist with the same name.

## [0.1.1]

### Added

* A new `remove_root_access` input to remove sudo access from the ubuntu user.

### Fixed

* The instructions for modifying ssh_config files to use the bastion are now more complete.

## [0.1.0]

Initial commit / release.

