#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
Var_install_v2_name="${Var_install_v2_name}"
Func_run_sanely "cp -va ${Var_install_v2_name} ${Var_install_path}/${Var_install_v2_name}" "0"
Func_run_sanely "chmod 754 ${Var_install_path}/${Var_install_v2_name}" "0"
Var_check_path="$(echo "${PATH}" | grep -q "${Var_install_path}")"
if [ -z "${Var_check_path}" ]; then
	echo "${Var_script_name}: PATH+=\":${Var_install_path}\""
	export PATH+=":${Var_install_path}"
fi
Func_run_sanely "${Var_install_path}/${Var_install_v2_name} --version" "${USER}"

