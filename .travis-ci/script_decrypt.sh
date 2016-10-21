#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
export Var_pipe_location="/tmp/Paranoid_Pipes/decrypt.pipe"
export Var_helper_location="${Var_parent_dir}/Script_Helpers/Paranoid_Pipes_Scenario_One.sh"
export Var_helper_name="decrypting_pipe_feeder.sh"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
## Copy helper script to install path if available
Func_run_sanely "cp -va ${Var_helper_location} ${Var_install_path}/${Var_helper_name}" "${USER}"
Func_run_sanely "chmod 111 ${Var_install_path}/${Var_helper_name}" "${USER}"
## Install customized  decrypting named pipe listener script
if [ -e "${Var_install_name}" ]; then
	Func_run_sanely "${Var_install_path}/${Var_install_name} --source-var-file=${Var_script_dir}/lib/config_pipe_variables_encrypt.sh" "${USER}"
else
	echo "${Var_script_name} could not execute: ${Var_install_path}/${Var_install_name}"
fi
## Run decryption with the aid of helper script
if [ -e "${Var_install_path}/${Var_helper_name}" ]; then
	Func_run_sanely "${Var_install_path}/${Var_helper_name} ${Var_encrypted_location} ${Var_decrypt_pipe_location}" "${USER}"
else
	echo "${Var_script_name} could not execute: ${Var_install_path}/${Var_helper_name}"
fi
echo "${Var_script_name} finished at: $(date -u +%s)"
