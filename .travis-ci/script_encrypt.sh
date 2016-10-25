#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
## First test if script is installed and excessable via name alone, elif check
##  if executable via full file path and name else exit with errors.
if [ -e "${Var_install_name}" ]; then
	echo "# ${Var_script_name} running test one as ${USER}: ${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_script_copy_permissions=750 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}"
	${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_script_copy_permissions=750 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
elif [ -e "${Var_install_path}/${Var_install_name}" ]; then
	## Make pipe for listening with main script loops owned by current user.
	echo "# ${Var_script_name} running test one as ${USER}: ${Var_install_path}/${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}"
	${Var_install_path}/${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_encrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_encrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir}
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_name}"
	exit 1
fi
echo -e "# ${Var_script_name} checking background processes:\n# $(ps aux | grep ${Var_install_name} | grep -v grep)\n\n Number of processes $(pgrep -c ${Var_install_name})"
## If test pipe file exists then test, else exit with errors
if [ -p "${Var_encrypt_pipe_location}" ]; then
	## Note we are saving the test string to a file but will be cat-ing
	##  it back out to named pipe file.
	_test_string=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")
	echo "# ${Var_script_name} running as ${USER}: echo \"${_test_string}\" > ${Var_raw_test_location}"
	echo "${_test_string}" > ${Var_raw_test_location}
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	echo "# ${Var_script_name} running as ${USER}: cat ${Var_raw_test_location} > ${Var_encrypt_pipe_location}"
	cat ${Var_raw_test_location} > ${Var_encrypt_pipe_location}
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	echo "# ${Var_script_name} running as ${USER}: echo \"quit\" > ${Var_encrypt_pipe_location}"
	echo "quit" > ${Var_encrypt_pipe_location}
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find: ${Var_encrypt_pipe_location}"
	exit 1
fi
## Report on pipe auto-removal
if ! [ -p "${Var_encrypt_pipe_location}" ]; then
	echo "# ${Var_script_name} detected pipe corectly removed: ${Var_encrypt_pipe_location}"
else
	echo "# ${Var_script_name} detected pipe still exsists: ${Var_encrypt_pipe_location}"
	ls -hal ${Var_encrypt_pipe_location}
fi
## Report on background processes
if [ "$(pgrep -c ${Var_install_name})" -gt "0" ]; then
	echo -e "# ${Var_script_name} reports background processes still running:\n# $(ps aux | grep ${Var_install_name} | grep -v grep)\n\n Number of processes $(pgrep -c ${Var_install_name})"
else
	echo "# ${Var_script_name} reports no more background processes: $(pgrep -c ${Var_install_name})"
fi
## Test decryption of first entry in output file
if [ -r "${Var_encrypted_location}" ]; then
	cat ${Var_encrypted_location}
	_exit_status=$?
	echo "# ${Var_script_name} running as ${USER}: Func_check_exit_status \"${_exit_status}\""
	Func_check_exit_status "${_exit_status}"
	cat ${Var_pass_location} | gpg --always-trust --passphrase-fd 0 --decrypt ${Var_encrypted_location} > ${Var_decrypt_raw_location}
	_exit_status=$?
	echo "# ${Var_script_name} running as ${USER}: Func_check_exit_status \"${_exit_status}\""
	Func_check_exit_status "${_exit_status}"
	_un_encrypted_string="$(cat ${Var_raw_test_location})"
	_decrypted_string="$(cat ${Var_decrypt_raw_location})"
	if [[ "${_un_encrypted_string}" == "${_decrypted_string}" ]]; then
		echo "# ${Var_script_name} tests for encryption & decryption: OK"
		echo "# ${Var_script_name}: [${_un_encrypted_string}] = [${_decrypted_string}]"
	else
		echo "# ${Var_script_name} reports encryption & decryption: failed"
		echo "# ${Var_script_name}: [${_un_encrypted_string}] != [${_decrypted_string}]"
	#	exit 1
	fi
else
	echo "# ${Var_script_name} could not read: ${Var_encrypted_location}"
	if [ -f "${Var_encrypted_location}" ]; then
		echo "# ${Var_script_name} reports it is a file though: ${Var_encrypted_location}"
	else
		echo "# ${Var_script_name} reports it not a file: ${Var_encrypted_location}"
	fi
fi
## Report encryption pipe tests success if we have gotten this far
echo "# ${Var_script_name} finished at: $(date -u +%s)"
