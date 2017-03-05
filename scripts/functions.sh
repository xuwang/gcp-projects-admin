#!/bin/bash

###############################################################################
# Helper functions
###############################################################################

# colors
yellow='\[\033[0;33m\]'
red='\[\033[0;31m\]'
reset='\[\033[0m\]'

# http://stackoverflow.com/a/25515370
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

err() {
  echo
  echo ${red}ERROR: ${@}$reset
  echo
  exit 1
}

err_report() {
  echo "$1: error on line $2"
}

trap_errors() {
  set -eeuo pipefail
  trap 'err_report $BASH_SOURCE $LINENO' err
  export shellopts
}

# check if a variable is set. useful for set -u
is_set() {
  declare -p $1 &> /dev/null
}

# is the variable set and have length?
not_empty_var() {
  is_set $1 && eval val=\$$1 && [[ "$val" ]]
}

# is the variable unset or zero length? useful for set -u
empty_var() {
   ! not_empty_var $1
}

export -f yell die try err err_report trap_errors is_set not_empty_var empty_var
