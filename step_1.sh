#!/bin/bash

#########################################################
#    Create an option group so that                     #
#    we can restore backup etc                          #
#########################################################

#########################################################
#    Get engine name and version                        #
#########################################################

# Source Database
aws rds describe-db-instances --no-paginate --db-instance-identifier mlssdevsql --query 'DBInstances[0].[Engine,EngineVersion]'

# Target Database
aws rds describe-db-instances --no-paginate --db-instance-identifier mlssdevsql --query 'DBInstances[0].[Engine,EngineVersion]'

# Create Option Group
aws rds create-option-group \
    --option-group-name testoptiongroup \
    --engine-name oracle-ee \
    --major-engine-version 12.1 \
    --option-group-description "Test option group"


