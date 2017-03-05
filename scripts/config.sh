#!/bin/bash

###############################################################################
# Set up gcloud config for both local and CD systems and authenticate
###############################################################################

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# include functions
source $THIS_DIR/functions.sh
source env.sh

# fail on error or undeclared vars
trap_errors

if ! gcloud config configurations describe ${GCP_CONFIGURATION} &> /dev/null
then
  # create a new gcloud conf if doesn't exist
  gcloud config configurations create --activate ${GCP_CONFIGURATION}
else
  # activate config
  gcloud config configurations activate ${GCP_CONFIGURATION}
fi


# always set config from environment variables (env.sh)
gcloud config set project ${GCP_ADMIN_PROJECT_ID}
gcloud config set core/disable_usage_reporting False

# authenticate via key file, GCP_KEY env variable, or webauth login
if [ -f ${GCP_KEY_FILE} ]
then
  # key file is accessable
  gcloud auth activate-service-account --key-file ${GCP_KEY_FILE}
elif [ -z ${GCP_KEY+x} ]
then
  echo "can't find $GCP_KEY_FILE, authenticating via interactive webauth"
  gcloud auth login
else
  # GCP_KEY env variable is set
  KEY_FILE=mktemp
  echo ${GCP_KEY} | base64 -d > ${KEY_FILE}
  gcloud auth activate-service-account --key-file ${KEY_FILE}
  rm -f ${KEY_FILE}
fi
