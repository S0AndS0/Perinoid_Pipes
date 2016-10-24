#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
Func_source_file "${Var_script_dir}/lib/config_pipe_variables_encrypt.sh"
## If installed script is executable then make test keys, pipe and listener,
##  else exit wth errors
if [ -e "${Var_install_path}/${Var_install_name}" ]; then
	## Make pipe for listening with main script loops owned by current user.
	echo "# ${Var_script_name} running test one: ${Var_install_path}/${Var_install_name} Var_debugging=2 Var_pipe_permissions=660 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}"
	${Var_install_path}/${Var_install_name} Var_debugging=2 Var_pipe_permissions=660 Var_log_file_permissions=660 Var_scipt_copy_permissions=750 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}
	_exit_status=$?
	echo "# ${Var_script_name} running: Func_check_exit_status \"${_exit_status}\""
	Func_check_exit_status "${_exit_status}"
#	Func_run_sanely "${Var_install_path}/${Var_install_name} ${Arr_encrypt_opts[*]}" "0"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_name}"
	exit 1
fi
## If test pipe file exists then test, else exit with errors
if [ -p "${Var_encrypt_pipe_location}" ]; then
	_test_string=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")
	echo "# ${Var_script_name} running: echo \"${_test_string}\" > ${Var_raw_test_location}"
	echo "${_test_string}" > ${Var_raw_test_location}
	_exit_status=$?
	echo "# ${Var_script_name} running: Func_check_exit_status \"${_exit_status}\""
	Func_check_exit_status "${_exit_status}"
	echo "# ${Var_script_name} running: cat ${Var_raw_test_location} > ${Var_encrypt_pipe_location}"
	cat ${Var_raw_test_location} > ${Var_encrypt_pipe_location}
	_exit_status=$?
	echo "# ${Var_script_name} running: Func_check_exit_status \"${_exit_status}\""
	Func_check_exit_status "${_exit_status}"
#	echo "${_test_string}" > ${Var_encrypt_pipe_location}
#	Func_run_sanely "echo ${_test_string} > ${Var_encrypt_pipe_location}" "0"
	if [ -r "${Var_encrypted_location}" ]; then
		cat ${Var_encrypted_location}
		_exit_status=$?
		echo "# ${Var_script_name} running: Func_check_exit_status \"${_exit_status}\""
		Func_check_exit_status "${_exit_status}"
#		Func_run_sanely "cat ${Var_encrypted_location}" "0"
		cat ${Var_pass_location} | gpg --decrypt ${Var_encrypted_location} --passphrase-fd 0 > ${Var_decrypt_raw_location}
		_exit_status=$?
		echo "# ${Var_script_name} running: Func_check_exit_status \"${_exit_status}\""
		Func_check_exit_status "${_exit_status}"
#		Func_run_sanely "gpg --batch --yes --decrypt ${Var_encrypted_location} --passphrase-file ${Var_pass_location}" "0"
	else
		echo "# ${Var_script_name} could not find: ${Var_encrypted_location}"
		if [ -f "${Var_encrypted_location}" ]; then
			echo "# ${Var_script_name} reports it is a file though: ${Var_encrypted_location}"
		else
			echo "# ${Var_script_name} reports it not a file: ${Var_encrypted_location}"
		fi
	fi
	echo "# ${Var_script_name} running: echo \"quit\" > ${Var_encrypt_pipe_location}"
	echo "quit" > ${Var_encrypt_pipe_location}
	_exit_status=$?
	echo "# ${Var_script_name} running: Func_check_exit_status \"${_exit_status}\""
	Func_check_exit_status "${_exit_status}"
#	Func_run_sanely "echo quit > ${Var_encrypt_pipe_location}" "0"
else
	echo "# ${Var_script_name} could not find: ${Var_encrypt_pipe_location}"
	exit 1
fi
if [[ "$(cat ${Var_decrypt_raw_location})" == "$(cat ${Var_raw_test_location})" ]]; then
	echo "# ${Var_script_name} tests for encryption & decryption: OK"
	echo "# ${Var_script_name}: [$(cat ${Var_decrypt_raw_location})] = [$(cat ${Var_raw_test_location})]"
else
	echo "# ${Var_script_name} reports encryption & decryption: failed"
	exit 1
fi
## Report encryption pipe tests success if we have gotten this far
echo "# ${Var_script_name} finished at: $(date -u +%s)"
