#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
Func_source_file "${Var_script_dir}/lib/config_pipe_variables_encrypt.sh"
## If installed script is executable then make test keys,
## pipe and listener, else exit wth errors
if [ -e "${Var_install_path}/${Var_install_name}" ]; then
	_pass_phrase=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")
	echo "${_pass_phrase}" > "${Var_pass_location}"
	echo "# ${Var_script_name}: Func_gen_gnupg_test_keys \"\${_pass_phrase}\""
	Func_gen_gnupg_test_keys "${_pass_phrase}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	## RUnning main script with root permissions to make customized
	##  script copy within install directories that maybe write protected.
	Func_run_sanely "${Var_install_path}/${Var_install_name} ${Arr_encrypt_opts[*]}" "0"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_name}"
	exit 1
fi
## If test pipe file exists then test, else exit with errors
if [ -p "${Var_encrypt_pipe_location}" ]; then
	_test_string=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")
	Func_run_sanely "cat <<<\"${_test_string}\" > \"${Var_encrypt_pipe_location}\"" "${USER}"
	Func_run_sanely "cat <<<\"quit\" > \"${Var_encrypt_pipe_location}\"" "${USER}"
else
	echo "# ${Var_script_name} could not find: ${Var_encrypt_pipe_location}"
	exit 1
fi
## Report encryption pipe tests success if we have gotten this far
echo "# ${Var_script_name} finished at: $(date -u +%s)"
