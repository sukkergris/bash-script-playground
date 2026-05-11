#!/usr/bin/env bash

# Root of the project (adjust if needed)
: "${PROJECT_ROOT:="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"
: "${LIB_DIR:="$PROJECT_ROOT/lib"}"

declare -Ag __MODULES_LOADED=()
declare -Ag __MODULES_META_NAME=()
declare -Ag __MODULES_META_VERSION=()
declare -Ag __MODULES_META_DESC=()

# Simple internal debug (opt-in)
: "${MODULE_DEBUG:=0}"
_module_debug() {
  (( MODULE_DEBUG )) && printf '[MODULE-DEBUG] %s\n' "$*" >&2
}

# Public: load a module by name, e.g. "logging" -> lib/logging.sh
load_module() {
  local name="$1"
  [[ -z "$name" ]] && { echo "load_module: missing name" >&2; return 1; }

  # Already loaded?
  if [[ -n "${__MODULES_LOADED[$name]:-}" ]]; then
    _module_debug "Module '$name' already loaded"
    return 0
  fi

  local file="$LIB_DIR/${name}.sh"
  if [[ ! -f "$file" ]]; then
    echo "load_module: module '$name' not found at '$file'" >&2
    return 1
  fi

  _module_debug "Loading module '$name' from '$file'"

  # shellcheck source=/dev/null
  source "$file"

  # Optional: module can define a metadata function
  if declare -F "${name}::__meta" >/dev/null 2>&1; then
    local meta
    meta="$("${name}::__meta")" || true
    # Expected format: NAME|VERSION|DESC
    local m_name m_ver m_desc
    IFS='|' read -r m_name m_ver m_desc <<<"$meta"
    __MODULES_META_NAME["$name"]="$m_name"
    __MODULES_META_VERSION["$name"]="$m_ver"
    __MODULES_META_DESC["$name"]="$m_desc"
    _module_debug "Meta for '$name': name='$m_name' version='$m_ver'"
  fi

  # Optional: module init hook
  if declare -F "${name}::__init" >/dev/null 2>&1; then
    _module_debug "Running init for '$name'"
    "${name}::__init"
  fi

  __MODULES_LOADED["$name"]=1
}

# Public: show loaded modules
list_modules() {
  local name
  for name in "${!__MODULES_LOADED[@]}"; do
    printf '%s (v%s) - %s\n' \
      "${__MODULES_META_NAME[$name]:-$name}" \
      "${__MODULES_META_VERSION[$name]:-unknown}" \
      "${__MODULES_META_DESC[$name]:-no description}"
  done
}
