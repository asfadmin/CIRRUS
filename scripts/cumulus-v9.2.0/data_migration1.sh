#!/usr/bin/env bash

# run this lambda after deploying the data_migration1 module

aws lambda invoke --function-name $DEPLOY_NAME-cumulus-$MATURITY-data-migration1 $DEPLOY_NAME-cumulus-$MATURITY-dm1.log