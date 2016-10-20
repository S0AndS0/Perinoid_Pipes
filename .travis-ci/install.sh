#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
## Variables custom to this script using above sourced variables
Var_install_script="${Var_parent_dir}/${Var_install_name}"
Var_check_path=$(echo "${PATH}" | grep -q "${Var_install_path}")
## Check that path found in 'Var_install_path' variable is also within
##  ${PATH} variable
if [ -z "${Var_check_path}" ]; then
	echo "${Var_script_name}: PATH+=\":${Var_install_path}\""
	PATH+=":${Var_install_path}"
fi
Func_run_sainly "cp -va \"${Var_install_script}\" \"${Var_install_path}/${Var_install_name}\"" "0"
Func_run_sainly "chmod 111 \"${Var_install_path}/${Var_install_name}\"" "0"
## Try running help
Func_run_sainly "${Var_install_name} --help" "${USER}"
echo "# ${Var_script_name} finished at: $(date -u +%s)"
