#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
## Variables custom to this script using above sourced variables
Var_install_script="${Var_install_name}"
## Check that path found in 'Var_install_path' variable is also within
##  ${PATH} variable, uncomment if not running on travis-ci
Var_check_path=$(echo "${PATH}" | grep -q "${Var_install_path}")
echo "# ${Var_script_name} started at: $(date -u +%s)"
if [ -z "${Var_check_path}" ]; then
	echo "${Var_script_name}: PATH+=\":${Var_install_path}\""
	export PATH+=":${Var_install_path}"
fi
Func_run_sanely "cp -va ${Var_install_script} ${Var_install_path}/${Var_install_name}" "0"
Func_run_sanely "chmod 754 ${Var_install_path}/${Var_install_name}" "0"
## Try running help
Func_run_sanely "${Var_install_path}/${Var_install_name} --version" "${USER}"
echo "# ${Var_script_name} finished at: $(date -u +%s)"
