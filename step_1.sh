#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 <SOURCE_DATABASE> <TARGET_DATABASE>"
	echo -e "\tNote: Do not change the order of parameters."
	echo -e "\n\tExample: $0 dev-database new-database"
	exit 1
fi

SOURCE_DATABASE="$1"
TARGET_DATABASE="$2"

START_STRING=""

#########################################################
#    Get Source Database Engine and Engine Version      #
#########################################################

# Source Engine
SOURCE_ENGINE="${START_STRING} $(aws rds describe-db-instances --region "${REGION}" --db-instance-identifier "${SOURCE_DATABASE}" --query 'DBInstances[0].Engine' --output text)" || { echo "Failed to run aws rds describe-db-instances commandline, exiting..."; exit 1; }
[ "${SOURCE_ENGINE}x" == "x" ] && { echo "There is no engine found for the given source database ${SOURCE_DATABASE} in region ${REGION}, exiting..."; exit 1; }

# Source Engine Version
SOURCE_ENGINE_VERSION="${START_STRING} $(aws rds describe-db-instances --region "${REGION}" --db-instance-identifier "${SOURCE_DATABASE}" --query 'DBInstances[0].EngineVersion' --output text)" || { echo "Failed to run aws rds describe--db-instances commandline, exiting..."; exit 1; }
[ "${SOURCE_ENGINE_VERSION}x" == "x" ] && { echo "There is no engine version found for the given source database ${SOURCE_DATABASE} in region ${REGION}, exiting..."; exit 1; }

#########################################################
#    Get Target Database Engine and Engine Version      #
#########################################################

# Target Engine
TARGET_ENGINE="${START_STRING} $(aws rds describe-db-instances --region "${REGION}" --db-instance-identifier "${TARGET_DATABASE}" --query 'DBInstances[0].Engine' --output text)" || { echo "Failed to run aws rds describe-db-instances commandline, exiting..."; exit 1; }
[ "${TARGET_ENGINE}x" == "x" ] && { echo "There is no engine found for the given source database ${TARGET_DATABASE} in region ${REGION}, exiting..."; exit 1; }

# Target Engine Version
TARGET_ENGINE_VERSION="${START_STRING} $(aws rds describe-db-instances --region "${REGION}" --db-instance-identifier "${TARGET_DATABASE}" --query 'DBInstances[0].EngineVersion' --output text)" || { echo "Failed to run aws rds describe--db-instances commandline, exiting..."; exit 1; }
[ "${TARGET_ENGINE_VERSION}x" == "x" ] && { echo "There is no engine version found for the given source database ${TARGET_DATABASE} in region ${REGION}, exiting..."; exit 1; }

# Create Option Group
aws rds create-option-group \
  --option-group-name mlssdevsql-native-backup \
  --engine-name "$SOURCE_ENGINE_VERSION" \
  --major-engine-version 12.1 \
  --option-group-description "Test option group"
