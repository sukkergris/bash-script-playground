#!/usr/bin/env bash


a() {
  local i=$((${#FUNCNAME} - 1))
  cat << EOF
  bash_source[0]: ${BASH_SOURCE[0]}
  \$0: $0
  file: ${BASH_SOURCE[i+1]}
  function: ${FUNCNAME[i]}
  executed at: ${BASH_LINENO[i]}
EOF
}

a
