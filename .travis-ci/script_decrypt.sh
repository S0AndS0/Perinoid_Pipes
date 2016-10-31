#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
echo "# ${Var_script_name} started at: $(date -u +%s)"
if [ -e "${Var_install_name}" ]; then
	echo "# ${Var_script_name} running test one as ${USER}: ${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_script_copy_permissions=750 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_decrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_decrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir} Var_parsing_command=\"$(which gpg) ${Var_gnupg_decrypt_opts}\""
	${Var_install_name} Var_debugging='2' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_script_copy_permissions='750' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_decrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_decrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}" Var_parsing_command="$(which gpg) ${Var_gnupg_decrypt_opts}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
elif [ -e "${Var_install_path}/${Var_install_name}" ]; then
	echo "# ${Var_script_name} running test one as ${USER}: ${Var_install_path}/${Var_install_name} Var_debugging=2 Var_pipe_permissions=666 Var_log_file_permissions=666 Var_gpg_recipient=${Var_gnupg_email} Var_log_rotate_recipient=${Var_gnupg_email} Var_pipe_file_name=${Var_decrypt_pipe_location} Var_log_file_name=${Var_encrypt_pipe_log} Var_parsing_output_file=${Var_decrypted_location} Var_parsing_bulk_out_dir=${Var_encrypted_bulk_dir} Var_parsing_command=\"$(which gpg) ${Var_gnupg_decrypt_opts}\""
	${Var_install_path}/${Var_install_name} Var_debugging='2' Var_pipe_permissions='666' Var_log_file_permissions='666' Var_gpg_recipient="${Var_gnupg_email}" Var_log_rotate_recipient="${Var_gnupg_email}" Var_pipe_file_name="${Var_decrypt_pipe_location}" Var_log_file_name="${Var_encrypt_pipe_log}" Var_parsing_output_file="${Var_decrypted_location}" Var_parsing_bulk_out_dir="${Var_encrypted_bulk_dir}" Var_parsing_command="$(which gpg) ${Var_gnupg_decrypt_opts}"
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} could not find: ${Var_install_path}/${Var_install_name}"
	exit 1
fi
if [ -p "${Var_decrypt_pipe_location}" ]; then
	## Use helper script to decrypt multi-block file
	echo "# ${Var_script_name} running: chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh"
	chmod u+x Script_Helpers/Paranoid_Pipes_Scenario_One.sh
	echo "# ${Var_script_name} running: Script_Helpers/Paranoid_Pipes_Scenario_One.sh \"${Var_encrypted_location}\" \"${Var_decrypt_pipe_location}\""
	Script_Helpers/Paranoid_Pipes_Scenario_One.sh "${Var_encrypted_location}" "${Var_decrypt_pipe_location}"
else
	echo "# ${Var_script_name} could not find pipe file: ${Var_decrypt_pipe_location}"
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
