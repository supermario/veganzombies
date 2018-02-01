#!/usr/bin/env bash
#set -ex

MAKEFILE=$1

function print_section() {
  local section_name
  local filter

  section_name="$1"
  echo
  echo "${section_name}" \
    | awk '{printf "\033[32m%-15s\033[0m \n", $1}'

  filter='^[a-zA-Z_-]+:.*?#'$section_name'# .*$$'
  grep -E "$filter" $MAKEFILE \
    | awk 'BEGIN {FS = ":.*?#'$section_name'# "}; {printf "\033[36m%-15s\033[0m %s\n", $1, $2}'
}

# print_section "App"
print_section "Development"
# print_section "Tools"
