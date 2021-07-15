# CHANGELOG

## v9.2.0.0

* Upgrade to Cumulus [v9.2.0](https://github.com/nasa/Cumulus/releases/tag/v9.2.0)
  * Version [v9.0.1](https://github.com/nasa/Cumulus/releases/tag/v9.0.1) has a
    number of migration instructions detailed
    [here](https://nasa.github.io/cumulus/docs/upgrade-notes/upgrade-rds)
  * Per the migration instructions, this version of CIRRUS assumes that the DAACs
    RDS creation is contained the `rds` directory of that DAACs `CIRRUS-DAAC` code.
    The datbase is created by running `make rds` with the appropriate parameters.
    `make plan-rds` can be run to check parameters.
  * A new `make data-migration1` target has been created and can be used for that
    step of the migration.  `make plan-data-migration1` can be run to check parameters
  * Scripts for the migration1 and 2 lambda invokecations can be found in the
    `scripts/cumulus-v9.2.0` directory
  * While there are no specific migration instructions, the release notes for
    Version [v9.1.0](https://github.com/nasa/Cumulus/releases/tag/v9.1.0) should
    also be reviewed
  * a serverless RDS requires at least 2 subnets to be defined, CIRRUS had only been
    using one via commands like this:

```terraform
data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.application_vpcs.id

  tags = {
    Name = "Private application ${data.aws_region.current.name}a subnet"
  }
}
```

* subnets are now defined like this throughout CIRRUS:

```terraform
data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.application_vpcs.id

  filter {
    name   = "tag:Name"
    values = ["Private application ${data.aws_region.current.name}a subnet",
              "Private application ${data.aws_region.current.name}b subnet"]
  }
}
```

* ElasticSearch stacks with mulitiple subnets require at least 2 nodes
    so the default number was raised to 2
* If using a serverless RDS make sure to set `rds_connection_heartbeat` to true
in the cumulus module

## v8.1.1.0

* Upgrade to Cumulus [v8.1.1](https://github.com/nasa/Cumulus/releases/tag/v8.1.1)

## v8.1.0.0

* Upgrade to Cumulus [v8.1.0](https://github.com/nasa/Cumulus/releases/tag/v8.1.0)
  * While there are no specific migration instructions, please review the changes in all releases since v6.0.0
    * [v7.0.0](https://github.com/nasa/Cumulus/releases/tag/v7.0.0)
    * [v7.1.0](https://github.com/nasa/Cumulus/releases/tag/v7.1.0)
    * [v7.2.0](https://github.com/nasa/Cumulus/releases/tag/v7.2.0)
    * [v8.0.0](https://github.com/nasa/Cumulus/releases/tag/v8.0.0)
* Cumulus v7.0.0 removed the `log2elasticsearch_lambda_function_arn` output from the
cumulus module.  Any workflows which expected it will need to be updated.
* Any workflows using DMRPP should upgrade to [v2.1.0](https://ghrcdaac.github.io/dmrpp-generator/#v210)
* This version requires [v6.0.0](https://github.com/nasa/cumulus-dashboard/releases/tag/v6.0.0)
of the Cumulus Dashboard

### Prerequisites

* The Cumulus team recommends updgrading your CIRRUS-core release to v6.0.0.0 across all your
environments prior to upgrading to Cumulus 8.1.0.

## v6.0.0.0

* Upgrade to Cumulus [v6.0.0](https://github.com/nasa/Cumulus/releases/tag/v6.0.0)
  * review the upgrade instructions
* Upgrade to TEA to build [103](https://github.com/asfadmin/thin-egress-app/releases/tag/tea-build.103)

### Prerequisites

* Upgrade your CIRRUS-core release to v5.0.1.3 across all your environments to
ensure Terraform is upgraded to v13.6.

## v5.0.1.3

The purpose of this update is to upgrade Terraform to v0.13.6 on existing
deployments of Cumulus v5.0.1.  Cumulus notes for upgrading Terraform are
available [here](https://github.com/nasa/cumulus/blob/master/docs/upgrade-notes/upgrading-tf-version-0.13.6.md).

This CIRRUS update takes care of the running of the `0.13upgrade` command across
all modules.  It resulted in the creation of a versions.tf file in each module
and a syntax change to the `required_providers` section in the main.tf file in
each module.

### Prerequisites

* Upgrade your CIRRUS-core release to v5.0.1.2 across all your environments.
* Per the Cumulus notes, apply any configuration across all environments.

### Upgrade Steps

* Review the changes in CIRRUS-DAAC.  Add the versions.tf file and update the
`required_providers` section of the main.tf file in your `daac` and `workflows` modules
* In CIRRUS-core run `make image` to create a new Docker `cirrus-core` image with
Terraform 0.13.6.
* Run `make container-shell` - all the following commands are run from inside the
container.
* use the `source env.sh ...` command to set up your environment variables for
the deployment you will be upgrading.
* For each module run `make plan-modulename` (`make plan-tf`, `make plan-daac`, etc).
Only `make plan-tf` will succeed the first time.  Even though unsuccessul, this step
is necessary as it runs the `terraform init --reconfigure` mentioned in the Cumulus
upgrade instructions.
* cd to the module directory and run the necessary `terraform state replace-provider`
commands to resolve the issues noted in the `plan` failure.
* Run `make plan-module` again to confirm the issues are resolved

The `scripts/cumulus-v5.0.1-tf-upgrade/replace_tf_providers.sh` script has all
the commands necessary to iterate over each module.  **BE WARNED** You may want
to use this as more of a copy-paste guide rather than actually running it.  It
does work running end-to-end on my deployments but your mileage may vary.  In
particular, you may want to remove the `-auto-approve` switch from the
`terraform state replace-provider` command so you have a chance to review the
changes before accepting them.

* Once all `plans` run successfully you can then run `make modulename` for each
module to complete the upgrade.

The process will need to be repeated for each deployment.

## v5.0.1.2

* Expose elasticsearch configuration parameters in both data-persistence and cumulus modules.
* **Breaking change**:  the `Makefile` updated to handle per maturity data-persistence variables.  To be
consistent with how other `make` targets behave, the CIRRUS-DAAC
`data-persistence/terraform.tfvars` file needs to exist for `make data-persistence` to work.
The file can be empty, but must exist.

## v5.0.1.1

* Upgrade to TEA to build [102](https://github.com/asfadmin/thin-egress-app/releases/tag/tea-build.102)

## v5.0.1.0

* Upgrade to Cumulus [v5.0.1](https://github.com/nasa/Cumulus/releases/tag/v5.0.1)

## v5.0.0.0

* Upgrade to Cumulus [V5.0.0](https://github.com/nasa/Cumulus/releases/tag/v5.0.0)
* Update includes the addition of the `egress_lambda_log_group` and
  `egress_lambda_log_subscription_filter` plus the removal of the `tea_stack_name`
  mentioned in the migration steps
* Cumulus 5.0.0 requires a one time [reindex](https://nasa.github.io/cumulus-api/#reindex)
  and [changeindex](https://nasa.github.io/cumulus-api/#change-index)
* Update adds a `egress_lambda_log_retention_days` variable with a default of 30
  to allow a DAAC to control the number of days to keep logs.

## v4.0.0.1

* Upgrade aws terraform provider to 3.19.x and ignore gsfc-ngap tags when deciding what components need to be rebuilt

## v4.0.0.0

* Upgrade to Cumulus [V4.0.0](https://github.com/nasa/Cumulus/releases/tag/v4.0.0)
* change `cumulus_message_adapter_lambda_layer_arn` -> `cumulus_message_adapter_lambda_layer_arn` under the `cumulus` module in `cumulus/main.tf`
* change `thin_egress_app` module's source to  `thin-egress-app/tea-terraform-build.100.zip` in `cumulus/thin_egress_app`
* add cumulus module output for new `update_granules_cmr_metadata_file_links` workflow lambda
* add `egress_api_gateway_log_subscription_filter` subscription filter in `cumulus/thin_egress.tf` per Cumulus upgrade instructions
* expose several ecs_cluster variables in `cumulus/main.tf` and `cumulus/variables.tf` for modification by CIRRUS users

## v3.0.1.0

* Upgrade to Cumulus [V3.0.1](https://github.com/nasa/Cumulus/releases/tag/v3.0.1)

## v3.0.0.0

* Upgrade to Cumulus [V3.0.0](https://github.com/nasa/Cumulus/releases/tag/v3.0.0)
* NOTE: Make sure to follow the upgrade instructions to prevent the
  deletion and recreation of your TEA API Gateway.
* change `Makefile` to add new `plan-*` targets for each step to allow running of
  `terraform plan` for each step (ex. `make plan-cumulus`)
* change `cumulus/main.tf` changes to support separation of TEA from Cumulus
* change `cumulus/outputs.tf` update the TEA outputs needed by workflows
* change `cumulus/variables.tf` add new variables and formatting
* change `data-persistence/main.tf` update for cumulus 3.0.0

* add `cumulus/common.tf` items which are needed by both cumulus and tea
* add `cumulus/thin_egress.tf` TEA tf module definition
* add `cumulus/thin-egress-app/bucket_map.yaml.tmpl` the default TEA bucket map template
* add `scripts/cumulus-v3.0.0/move-tea-tf-state.sh` contains the commands mentioned
in the TEA migration instructions (https://nasa.github.io/cumulus/docs/upgrade-notes/migrate_tea_standalone)

### Notes about v3.0.0 migration as relates to CIRRUS

* The `make daac` step of this version of CIRRUS generates a new output (`bucket_map_key`).  Look at the corresponding
[CIRRUS-DAAC](https://github.com/asfadmin/CIRRUS-DAAC/blob/master/daac/outputs.tf) to add that value to your `daac/outputs.tf` file and then run `make daac`
* Where the TEA migration instructions mention `terraform plan` use the new `make plan-cumulus` target get the output mentioned
* Run `make daac` and `make data-persistence` prior to `make plan-cumulus`
* Normally you run all CIRRUS `make` commands from the root `CIRRUS-core` directory.  All the `terraform state mv *` commands
require being in the `CIRRUS-core/cumulus` directory.  A script has been added to `scripts/cumulus-v3.0.0` with all the commands
in one file.  You may wish to run them from the script, or you may want to run them one at a time.  Make sure you have a
backup of your state per the Cumulus instructions.

## v2.0.7.0

* Upgrade to Cumulus [V2.0.7](https://github.com/nasa/Cumulus/releases/tag/v2.0.7)

## v2.0.6.0

* Upgrade to Cumulus [V2.0.6](https://github.com/nasa/Cumulus/releases/tag/v2.0.6)

## v2.0.4.0

* Upgrade to Cumulus [V2.0.4](https://github.com/nasa/Cumulus/releases/tag/v2.0.4) to upgrade TEA to build 88

## v2.0.3.0

* Upgrade to Cumulus [V2.0.3](https://github.com/nasa/Cumulus/releases/tag/v2.0.3) to fix syncgranule checksum and dashboard stats issues

## v2.0.2.0

* Upgrade to Cumulus [V2.0.2](https://github.com/nasa/Cumulus/releases/tag/v2.0.2) to fix delete granule bug
* add optional bucket_map_key variable to allow override of default TEA bucket_map
* output cmr environment and hyrax-metadata-update task for use in workflows

## v2.0.1.0

### CHANGES

* Upgrade to Cumulus v2.0.1.
* review Cumulus deployment instructions for version [2.0.0](https://github.com/nasa/Cumulus/releases/tag/v2.0.0)
there is a manual step. [2.0.1](https://github.com/nasa/Cumulus/releases/tag/v2.0.1) only contains a bug fix
* Expose EC2 instance type for the default Cumulus ECS cluster.  Still deafaults to `t3.medium`.
  Can be changed via any of the cumulus .tfvars files in CIRRUS-DAAC

## v1.24.0.0

### CHANGES

* Upgrade to Cumulus v1.24.0.
* review Cumulus
  [deployment instructions](https://github.com/nasa/Cumulus/releases/tag/v1.24.0)
* added two extra cumulus outputs which are needed for ECS based tasks

## v1.23.2.0

### CHANGES

* Upgrade to Cumulus v1.23.2.
* review Cumulus
  [deployment instructions](https://github.com/nasa/Cumulus/releases/tag/v1.23.2)

## v1.22.1.0

### CHANGES

* Upgrade to Cumulus v1.22.1.
* review Cumulus
  [deployment instructions](https://github.com/nasa/Cumulus/releases/tag/v1.21.0)

## v1.21.0.0

### CHANGES

* Upgrade to Cumulus v1.21.0.
* review Cumulus
  [deployment instructions](https://github.com/nasa/Cumulus/releases/tag/v1.21.0)

## v1.20.0.0

### CHANGES

* Upgrade to Cumulus v1.20.0.  There are several breaking changes in this
  release.
* `cumulus/main.tf` added `deploy_to_ngap = true` per Cumulus
  [deployment instructions](https://github.com/nasa/Cumulus/releases/tag/v1.20.0)

## v1.19.0.0

### CHANGES

* Upgrade to Cumulus v1.19.0.  There are several breaking changes in this
  release.  Make sure to follow the
  [deployment instructions](https://github.com/nasa/Cumulus/releases/tag/v1.19.0).
* `setup_jwt_cookie.sh` script added to create and deploy a TEA secret with the
  name of `${DEPLOY_NAME}-cumulus-${MATURITY}-jwt_secret_for_tea`
* `cumulus/main.tf` updated to make use of secret created by
  `setup_jwt_cookie.sh`
* `cumuluse/outputs.tf` updated to output `sf_sqs_report_task` rather than
  `sf_sns_report_task`

## v1.18.0.1

### CHANGES

* Remove the deprecated TF state resources that are no longer needed.

## v1.18.0.0

### CHANGES

* Upgrade to Cumulus v1.18.0. There should be no breaking changes from
  CIRRUS v1.17.0.0.

## v1.17.0.0

### Upgrade Notes:

1. CIRRUS' Makefile will now delegate to the DAAC repo for the
   following make targets:

   * migrate-tf-state: NEW--see note below
   * daac
   * workflows

  Add these three targets to your DAAC Makefile. See the CIRRUS-DAAC
  repo for examples of each of these three targets.

2. If you're currently using a previous version of CIRRUS, you'll
need to migrate the Terraform state from the old backend AWS resources
to new ones. You can do this by running this for _*each*_ deployment /
maturity combination that you've deployed:

        $ source env.sh ...        # See README
        $ make migrate-tf-state

You'll be prompted to migrate state from the old resources to the
new. Simply respond with 'yes' to each of the four prompts and you'll
be ready to go.

3. For local development, CIRRUS no longer looks for secrets in the
   CIRRUS-core repo's `.secrets` directory. Instead, it relies on the
   secrets being configured as described in the CIRRUS-DAAC
   repo. Remove any local `.secrets` files and directory and see the
   CIRRUS-DAAC README for instructions on how to setup local
   development secrets.

### CHANGES

* First official full release of CIRRUS
* Uses Cumulus v1.17.0
* Fix TF state resource names and add a Makefile target to migrate
  state from the old resources to the new one.
* Get the bucket config from the DAAC module (which needs to create
  it) and pass it to Cumulus.
* Set and export the AWS_PROFILE envvar in the `env.sh` script.
* Fix a stringification bug in the Jenkinsfile.
* Fix the extra 'retry' command if deploying Cumulus fails randomly
  the first time.
* Pass the ECS cluster instance AMI id to Cumulus.
* The Makefile now defers to the DAAC repo to run the `daac` and
  `workflows` targets. It does this by `cd`ing into the DAAC repo
  directory and simply executing `make daac` and `make
  workflows`. This means that the DAAC repo should have a Makefile
  with those two targets defined.
* Use the MATURITY as the value for Cumulus' `api_gateway_stage` and
  `distribution_api_gateway_stage`. This means the API gateway stage
  in each NGAP account corresponds with the MATURITY.
* Fix various Jenkinsfile parameter declarations, defaults, and
  descriptions.

## v0.1.2

* Include an example secrets TF variable file.
* Add output variables for all Cumulus tasks (lambdas) so they can be
  used in downstream TF modules.
* Add output variables for Cumulus' `lambda_processing_role_arn` and
  `no_ingress_all_egress` AWS security group.
* Turn off TF color output.
* The default Makefile target is now `all`. So running `make` and
  `make all` are equivalent.

## v0.1.1

* Lookup the correct NGAP VPC using the Name property.

## v0.1.0

* Initial CIRRUS release
