#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
#exec 3<${Var_pass_location}
if [ -e "${Var_install_name}" ]; then
	echo "# ${Var_script_name} running test two as ${USER}: ${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_script_copy_permissions=750 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_decrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_decrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir} Var_parsing_command=\"cat ${Var_pass_location} | $(which gpg) ${Var_gnupg_decrypt_opts}\""
	${Var_install_name} Var_debugging='2' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_script_copy_permissions='750' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_decrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_decrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}" Var_parsing_command="$(which gpg) ${Var_gnupg_decrypt_opts}"
#	${Var_install_name} Var_debugging='2' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_script_copy_permissions='750' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_decrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_decrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}" Var_parsing_command="cat ${Var_pass_location} | $(which gpg) ${Var_gnupg_decrypt_opts}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
elif [ -e "${Var_install_path}/${Var_install_name}" ]; then
	echo "# ${Var_script_name} running test two as ${USER}: ${Var_install_path}/${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_decrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_decrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir} Var_parsing_command=\"cat ${Var_pass_location} | $(which gpg) ${Var_gnupg_decrypt_opts}\""
	${Var_install_path}/${Var_install_name} Var_debugging='2' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_decrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_decrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}" Var_parsing_command="$(which gpg) ${Var_gnupg_decrypt_opts}"
#	${Var_install_path}/${Var_install_name} Var_debugging='2' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_decrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_decrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}" Var_parsing_command="cat ${Var_pass_location} | $(which gpg) ${Var_gnupg_decrypt_opts}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_name}"
	exit 1
fi
echo -e "# ${Var_script_name} checking background processes:\n# $(ps aux | grep "${Var_install_name}" | grep -v grep)\n\n Number of processes $(pgrep -c "${Var_install_name}")"
if [ -p "${Var_decrypt_pipe_location}" ]; then
	## Use helper script to decrypt multi-block file
	echo "# ${Var_script_name} running: chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh"
	chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh
	echo "# ${Var_script_name} running: Script_Helpers/Paranoid_Pipes_Scenario_One.sh \"${Var_encrypted_location}\" \"${Var_decrypt_pipe_location}\""
	Script_Helpers/Paranoid_Pipes_Scenario_One.sh "${Var_encrypted_location}" "${Var_decrypt_pipe_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	## Send quit string to named pipe to re-test auto clean-up functions.
	echo "# ${Var_script_name} running as ${USER}: echo \"quit\" > \"${Var_decrypt_pipe_location}\""
	echo "quit" > "${Var_decrypt_pipe_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find pipe file: ${Var_decrypt_pipe_location}"
fi
## If test pipe file exists then test, else exit with errors
## Report on pipe auto-removal
if ! [ -p "${Var_decrypt_pipe_location}" ]; then
	echo "# ${Var_script_name} detected pipe corectly removed: ${Var_decrypt_pipe_location}"
else
	echo "# ${Var_script_name} detected pipe still exsists: ${Var_decrypt_pipe_location}"
	ls -hal "${Var_decrypt_pipe_location}"
	echo "# ${Var_script_name} will cleanup: ${Var_decrypt_pipe_location}"
	rm -v "${Var_decrypt_pipe_location}"
fi
## Report on background processes
if [ "$(pgrep -c "${Var_install_name}")" -gt "0" ]; then
	echo -e "# ${Var_script_name} reports background processes still running:\n# $(ps aux | grep "${Var_install_name}" | grep -v grep)\n\n Number of processes $(pgrep -c "${Var_install_name}")"
	for _pid in $(pgrep "${Var_install_name}"); do
		echo "# ${Var_script_name} killing: ${_pid}"
	done
else
	echo "# ${Var_script_name} reports no more background processes: $(pgrep -c "${Var_install_name}")"
fi
## Test decryption output against non-encryted input from previous script.
if [ -r "${Var_decrypted_location}" ]; then
	echo "# ${Var_script_name} running: cat \"${Var_decrypted_location}\""
	cat "${Var_decrypted_location}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
	_decrypted_strings="$(cat "${Var_decrypted_location}")"
	if [ -r "${Var_raw_test_location}" ]; then
		echo "# ${Var_script_name} running: cat \"${Var_raw_test_location}\""
		cat "${Var_raw_test_location}"
		_exit_status=$?
		Func_check_exit_status "${_exit_status}"
		_raw_strings="$(cat "${Var_raw_test_location}")"
		if [[ "${_decrypted_strings}" == "${_raw_strings}" ]]; then
			echo "${Var_script_name} reports: all checks passed"
		else
			echo "${Var_script_name} reports: failed checks?"
			diff "${Var_decrypted_location}" "${Var_raw_test_location}"
		fi
	else
		echo "# ${Var_script_name} could not read: ${Var_raw_test_location}"
		if [ -f "${Var_raw_test_location}" ]; then
			echo "# ${Var_script_name} reports it is a file though: ${Var_raw_test_location}"
		else
			echo "# ${Var_script_name} reports it not a file: ${Var_raw_test_location}"
		fi
	fi
else
	echo "# ${Var_script_name} could not read: ${Var_decrypted_location}"
	if [ -f "${Var_encrypted_location}" ]; then
		echo "# ${Var_script_name} reports it is a file though: ${Var_decrypted_location}"
	else
		echo "# ${Var_script_name} reports it not a file: ${Var_decrypted_location}"
	fi
fi
## Report encryption pipe tests success if we have gotten this far
echo "# ${Var_script_name} finished at: $(date -u +%s)"
#export Var_gnupg_decrypt_opts="--always-trust --yes --bulk --passphrase-fd 0 --decrypt"
