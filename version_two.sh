#!/usr/bin/env bash
set +o history
## Assign name of this script and file path to variables for latter use
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
Var_debug_level="0"
Var_log_level="0"
Var_script_log_path="${PWD}/${Var_script_name%.sh*}.log"
Var_columns="${COLUMNS:-$(tput cols)}"
Var_columns="${COLUMNS:-80}"
Var_authors_contact='strangerthanbland@gmail.com'
Var_save_variables_yn="no"
Var_source_var_file=""
Var_script_version_main="2"
Var_script_version_sub="0"
Var_script_version_full="${Var_script_version_main}.${Var_script_version_sub}"
## Assigne executable paths as variables
Var_dev_null="/dev/null"
Var_echo="$(which echo)"
Var_chmod="$(which chmod)"
Var_chown="$(which chown)"
Var_mkfifo="$(which mkfifo)"
Var_mv="$(which mv)"
Var_rm="$(which rm)"
Var_tar="$(which tar)"
Var_cat="$(which cat)"
Var_gpg="$(which gpg)"
Var_mkdir="$(which mkdir)"
## Variables for encryption script copy
Var_enc_copy_save_yn="no"
Var_enc_copy_save_path="${PWD}/Slim_${Var_script_name}"
Var_enc_copy_save_ownership="${USER}:${USER}"
Var_enc_copy_save_permissions="750"
## Variables for encryption processes
Var_enc_yn=""
Var_enc_gpg_opts="--always-trust --armor --batch --no-tty --encrypt"
Var_enc_padding_enable_yn="no"
Var_enc_padding_length="adaptive"
Var_enc_padding_placement="append,prepend"
Var_enc_parsing_bulk_out_dir="${PWD}/Bulk_Encrypted"
Var_enc_parsing_bulk_output_suffix=".gpg"
Var_enc_parsing_disown_yn="yes"
Var_enc_parsing_filter_input_yn="no"
Var_enc_parsing_filter_comment_pattern='\#*'
Var_enc_parsing_filter_allowed_chars='[^a-zA-Z0-9 _.@!#%&:;$\/\^\-\"\(\)\{\}\\]'
Var_enc_parsing_recipient="${USER}@${HOSTNAME}.local"
Var_enc_parsing_output_file="${PWD}/Encrypted_Results.gpg"
Var_enc_parsing_output_rotate_yn="yes"
Var_enc_parsing_output_rotate_actions="compress-encrypt,remove-old"
Var_enc_parsing_output_rotate_recipient="${USER}@${HOSTNAME}.local"
Var_enc_parsing_output_max_size="4096"
Var_enc_parsing_output_check_frequency="100"
Var_enc_parsing_save_output_yn="yes"
Var_enc_parsing_quit_string="quit"
Var_enc_pipe_permissions="600"
Var_enc_pipe_ownership="${USER}:${USER}"
Var_enc_pipe_file="${PWD}/Encryption_Named.pipe"
Var_enc_trap_command="/bin/rm -f ${Var_enc_pipe_file}"
Var_enc_parsing_output_permissions="640"
Var_enc_parsing_output_ownership="${USER}:${USER}"
## Decryption variables
Var_dec_yn=""
Var_dec_copy_save_yn="no"
Var_dec_copy_save_path=""
Var_dec_gpg_opts="--quiet --no-tty --always-trust --passphrase-fd 9 --decrypt"
Var_dec_parsing_bulk_out_dir=""
Var_dec_parsing_disown_yn="no"
Var_dec_parsing_save_output_yn="yes"
Var_dec_parsing_output_file="${PWD}/Decrypted_Results.txt"
Var_dec_pass=""
Var_dec_search_string=""
## Special variables
Var_dec_diff_count_max="0"
Var_dec_diff_opts="--suppress-common-lines"
Var_dec_diff_sleep="120"

${Var_echo} "### ... Starting [${Var_script_name}] at $(date) ... ###"
Func_enc_clean_up_trap(){
	_exit_code="$1"
	${Var_echo} "## ${Var_script_name} detected [${_exit_code}] exit code, cleaning up before quiting..."
	if [ -p "${Var_enc_pipe_file}" ]; then
		${Var_enc_trap_command}
	fi
	${Var_echo} -n "### ... Finished [${Var_script_name}] at $(date) press [Enter] to resume terminal ... ###"
}
## Wrap up function operations inside bellow function
Func_main(){
	_input=( "$@" )
	if [ "${#_input[@]}" = "0" ]; then
		Func_message "# Func_main running: Func_check_args \"--help\"" '1' '2'
		Func_check_args "--help"
	else
		Func_message "# Func_main running: Func_check_args \"${_input[*]}\"" '1' '2'
		Func_check_args "${_input[@]}"
		case "${Var_enc_parsing_disown_yn}" in
			Y|y|Yes|yes|YES)
				${Var_echo} "## ${Var_script_name} will differ cleanup trap assignment until after reading has from named pipe [${Var_enc_pipe_file}] has finished..."
			;;
			*)
				${Var_echo} "## ${Var_script_name} will set exit trap now."
				trap 'Func_enc_clean_up_trap ${?}' EXIT
			;;
		esac
		## Functions for encryption
		case "${Var_enc_yn}" in
			Y|y|Yes|yes|YES)
				Func_message "# Func_main running: Func_enc_main" '1' '2'
				Func_enc_main
			;;
			*)
				Func_message "# Func_main skipping: Func_enc_main" '1' '2'
			;;
		esac
		## Functions for decryption
		case "${Var_dec_yn}" in
			Y|y|Yes|yes|YES)
				Func_message "# Func_main running: Func_dec_main" '1' '2'
				Func_dec_main
			;;
			*)
				Func_message "# Func_main skipping: Func_dec_main" '1' '2'
			;;
		esac
	fi
	unset -v _input[@]
}
Func_enc_main(){
	case "${Var_enc_copy_save_yn}" in
		Y|y|Yes|yes|YES)
			Func_message "# Func_main running: Func_enc_write_script_copy" '2' '3'
			Func_enc_write_script_copy
			if [ -e "${Var_enc_copy_save_path}" ]; then
				Func_message "# Func_main running: ${Var_enc_copy_save_path}" '2' '3'
				${Var_enc_copy_save_path}
			else
				Func_message "# Func_main could not exicute: ${Var_enc_copy_save_path}" '2' '3'
			fi
		;;
		*)
			Func_message "# Func_main running: Func_enc_make_named_pipe" '2' '3'
			Func_enc_make_named_pipe
			case "${Var_enc_parsing_disown_yn}" in
				Y|y|Yes|yes|YES)
					Func_message "# Func_main running: Func_enc_pipe_parser_loop >\"${Var_dev_null}\" 2>&1 &" '2' '3'
					Func_enc_pipe_parser_loop >"${Var_dev_null}" 2>&1 &
					PID_Func_enc_pipe_parser_loop=$!
					Func_message "# Func_main running: disown \"${PID_Func_enc_pipe_parser_loop}\"" '2' '3'
					disown "${PID_Func_enc_pipe_parser_loop}"
					Func_message "# Func_main disowned PID ${PID_Func_enc_pipe_parser_loop} parsing loops" '2' '3'
				;;
				*)
					Func_message "# Func_main running: Func_enc_pipe_parser_loop" '2' '3'
					Func_enc_pipe_parser_loop
					Func_message "# Func_main quitting: Func_enc_pipe_parser_loop" '2' '3'
					set -o history
				;;
			esac
			Func_message "# Func_main exiting encryption checks with: [$?]" '2' '3'
		;;
	esac
}
Func_dec_main(){
	case "${Var_dec_copy_save_yn}" in
		Y|y|Yes|yes|YES)
			Func_message "# Func_main running: Func_enc_write_script_copy" '2' '3'
			Func_dec_write_script_copy
			if [ -e "${Var_dec_copy_save_path}" ]; then
				Func_message "# Func_main running: ${Var_dec_copy_save_path}" '2' '3'
				${Var_dec_copy_save_path}
			else
				Func_message "# Func_main could not exicute: ${Var_enc_copy_save_path}" '2' '3'
			fi
		;;
		*)
			case "${Var_dec_parsing_save_output_yn}" in
				y|Y|yes|Yes)
					if ! [ -f "${Var_dec_parsing_output_file}" ]; then
						touch "${Var_dec_parsing_output_file}"
						chmod 660 "${Var_dec_parsing_output_file}"
					fi
				;;
			esac
			case "${Var_dec_parsing_disown_yn}" in
				Y|y|Yes|yes|YES)
					Func_message "# Func_main running: Func_dec_watch_file \"${Var_enc_parsing_output_file}\"" '2' '3'
					Func_dec_watch_file "${Var_enc_parsing_output_file}" >"${Var_dev_null}" 2>&1 &
					PID_Func_enc_pipe_parser_loop=$!
					Func_message "# Func_main running: disown \"${PID_Func_enc_pipe_parser_loop}\"" '2' '3'
					disown "${PID_Func_enc_pipe_parser_loop}"
					Func_message "# Func_main disowned PID ${PID_Func_enc_pipe_parser_loop} parsing loops" '2' '3'
					Func_message "# Func_main running: Func_dec_watch_bulk_dir" '2' '3'
					Func_dec_watch_bulk_dir >"${Var_dev_null}" 2>&1 &
					PID_Func_enc_pipe_parser_loop=$!
					Func_message "# Func_main running: disown \"${PID_Func_enc_pipe_parser_loop}\"" '2' '3'
					disown "${PID_Func_enc_pipe_parser_loop}"
					Func_message "# Func_main disowned PID ${PID_Func_enc_pipe_parser_loop} parsing loops" '2' '3'
				;;
				*)
					Func_message "# Func_main running: Func_dec_watch_file \"${Var_enc_parsing_output_file}\"" '2' '3'
					Func_dec_watch_file "${Var_enc_parsing_output_file}"
					Func_message "# Func_main running: Func_dec_watch_bulk_dir" '2' '3'
					Func_dec_watch_bulk_dir
				;;
			esac
			Func_message "# Func_main exiting decryption checks with: [$?]" '2' '3'
		;;
	esac
}
Func_check_args(){
	_arr_input=( "${@}" )
	Func_message "# ${Var_script_name} parsing: ${_arr_input[*]}" '2' '3'
	let _arr_count=0
	until [ "${#_arr_input[@]}" = "${_arr_count}" ]; do
		_arg="${_arr_input[${_arr_count}]}"
		case "${_arg%=*}" in
			--debug-level|Var_debug_level)
				Func_assign_arg "Var_debug_level" "${_arg#*=}"
			;;
			--log-level|Var_log_level)
				Func_assign_arg "Var_log_level" "${_arg#*=}"
			;;
			--script-log-path|Var_script_log_path)
				Func_assign_arg "Var_script_log_path" "${_arg#*=}"
			;;
			--columns|Var_columns)
				Func_assign_arg "Var_columns" "${_arg#*=}"
			;;
			--dec-yn|Var_dec_yn)
				Func_assign_arg "Var_dec_yn" "${_arg#*=}"
			;;
			--dec-copy-save-yn|Var_dec_copy_save_yn)
				Func_assign_arg "Var_dec_copy_save_yn" "${_arg#*=}"
			;;
			--dec-copy-save-path|Var_dec_copy_save_path)
				Func_assign_arg "Var_dec_copy_save_path" "${_arg#*=}"
			;;
			--dec-diff-count-max|Var_dec_diff_count_max)
				Func_assign_arg "Var_dec_diff_count_max" "${_arg#*=}"
			;;
			--dec-diff-opts|Var_dec_diff_opts)
				Func_assign_arg "Var_dec_diff_opts" "${_arg#*=}"
			;;
			--dec-diff-sleep|Var_dec_diff_sleep)
				Func_assign_arg "Var_dec_diff_sleep" "${_arg#*=}"
			;;
			--dec-gpg-opts|Var_dec_gpg_opts)
				Func_assign_arg "Var_dec_gpg_opts" "${_arg#*=}"
			;;
			--dec-parsing-bulk-out-dir|Var_dec_parsing_bulk_out_dir)
				Func_assign_arg "Var_dec_parsing_bulk_out_dir" "${_arg#*=}"
			;;
			--dec-parsing-disown-yn|Var_dec_parsing_disown_yn)
				Func_assign_arg "Var_dec_parsing_disown_yn" "${_arg#*=}"
			;;
			--dec-parsing-save-output-yn|Var_dec_parsing_save_output_yn)
				Func_assign_arg "Var_dec_parsing_save_output_yn" "${_arg#*=}"
			;;
			--dec-parsing-output-file|Var_dec_parsing_output_file)
				Func_assign_arg "Var_dec_parsing_output_file" "${_arg#*=}"
			;;
			--dec-pass|Var_dec_pass)
				Func_assign_arg "Var_dec_pass" "${_arg#*=}"
			;;
			--dec-search-string|Var_dec_search_string)
				Func_assign_arg "Var_dec_search_string" "${_arg#*=}"
			;;
			--help|help)
				Func_message "# Func_check_args read variable [${_arg%=*}] with value [${_arg#*=}]" '2' '3'
				Func_help
				exit 0
			;;
			--license)
				Func_script_license_customizer
				exit 0
			;;
			--save-options-yn|Var_save_options_yn)
				Func_assign_arg "Var_save_options_yn" "${_arg#*=}"
			;;
			--save-variables-yn|Var_save_variables_yn)
				Func_assign_arg "Var_save_variables_yn" "${_arg#*=}"
			;;
			--source-var-file|Var_source_var_file)
				Func_assign_arg "Var_source_var_file" "${_arg#*=}"
				if [ -f "${Var_source_var_file}" ]; then
					Func_message "# Func_check_args running: source \"${Var_source_var_file}\"" '2' '3'
					source "${Var_source_var_file}"
				fi
			;;
			--enc-yn|Var_enc_yn)
				Func_assign_arg "Var_enc_yn" "${_arg#*=}"
			;;
			--enc-copy-save-yn|Var_enc_copy_save_yn)
				Func_assign_arg "Var_enc_copy_save_yn" "${_arg#*=}"
			;;
			--enc-copy-save-path|Var_enc_copy_save_path)
				Func_assign_arg "Var_enc_copy_save_path" "${_arg#*=}"
			;;
			--enc-copy-save-ownership|Var_enc_copy_save_ownership)
				Func_assign_arg "Var_enc_copy_save_ownership" "${_arg#*=}"
			;;
			--enc-copy-save-permissions|Var_enc_copy_save_permissions)
				Func_assign_arg "Var_enc_copy_save_permissions" "${_arg#*=}"
			;;
			--enc-gpg-opts|Var_enc_gpg_opts)
				Func_assign_arg "Var_enc_gpg_opts" "${_arg#*=}"
			;;
			--enc-padding-enabled-yn|Var_enc_padding_enable_yn)
				Func_assign_arg "Var_enc_padding_enable_yn" "${_arg#*=}"
			;;
			--enc-padding-length|Var_enc_padding_length)
				Func_assign_arg "Var_enc_padding_length" "${_arg#*=}"
			;;
			--enc-padding-placement|Var_enc_padding_placement)
				Func_assign_arg "Var_enc_padding_placement" "${_arg#*=}"
			;;
			--enc-parsing-bulk-out-dir|Var_enc_parsing_bulk_out_dir)
				Func_assign_arg "Var_enc_parsing_bulk_out_dir" "${_arg#*=}"
			;;
			--enc-parsing-bulk-output-suffix|Var_enc_parsing_bulk_output_suffix)
				Func_assign_arg "Var_enc_parsing_bulk_output_suffix" "${_arg#*=}"
			;;
			--enc-parsing-disown-yn|Var_enc_parsing_disown_yn)
				Func_assign_arg "Var_enc_parsing_disown_yn" "${_arg#*=}"
			;;
			--enc-parsing-filter-input-yn|Var_enc_parsing_filter_input_yn)
				Func_assign_arg "Var_enc_parsing_filter_input_yn" "${_arg#*=}"
			;;
			--enc-parsing-filter-comment-pattern|Var_enc_parsing_filter_comment_pattern)
				Func_assign_arg "Var_enc_parsing_filter_comment_pattern" "${_arg#*=}"
			;;
			--enc-parsing-filter-allowed-chars|Var_enc_parsing_filter_allowed_chars)
				Func_assign_arg "Var_enc_parsing_filter_allowed_chars" "${_arg#*=}"
			;;
			--enc-parsing-recipient|Var_enc_parsing_recipient)
				Func_assign_arg "Var_enc_parsing_recipient" "${_arg#*=}"
			;;
			--enc-parsing-output-file|Var_enc_parsing_output_file)
				Func_assign_arg "Var_enc_parsing_output_file" "${_arg#*=}"
			;;
			--enc-parsing-output-rotate-yn|Var_enc_parsing_output_rotate_yn)
				Func_assign_arg "Var_enc_parsing_output_rotate_yn" "${_arg#*=}"
			;;
			--enc-parsing-output-rotate-actions|Var_enc_parsing_output_rotate_actions)
				Func_assign_arg "Var_enc_parsing_output_rotate_actions" "${_arg#*=}"
			;;
			--enc-parsing-output-rotate-recipient|Var_enc_parsing_output_rotate_recipient)
				Func_assign_arg "Var_enc_parsing_output_rotate_recipient" "${_arg#*=}"
			;;
			--enc-parsing-output-max-size|Var_enc_parsing_output_max_size)
				Func_assign_arg "Var_enc_parsing_output_max_size" "${_arg#*=}"
			;;
			--enc-parsing-output-check-frequency|Var_enc_parsing_output_check_frequency)
				Func_assign_arg "Var_enc_parsing_output_check_frequency" "${_arg#*=}"
			;;
			--enc-parsing-output-permissions|Var_enc_parsing_output_permissions)
				Func_assign_arg "Var_enc_parsing_output_permissions" "${_arg#*=}"
			;;
			--enc-parsing-output-ownership|Var_enc_parsing_output_ownership)
				Func_assign_arg "Var_enc_parsing_output_ownership" "${_arg#*=}"
			;;
			--enc-parsing-save-output-yn|Var_enc_parsing_save_output_yn)
				Func_assign_arg "Var_enc_parsing_save_output_yn" "${_arg#*=}"
			;;
			--enc-parsing-quit-string|Var_enc_parsing_quit_string)
				Func_assign_arg "Var_enc_parsing_quit_string" "${_arg#*=}"
			;;
			--enc-pipe-permissions|Var_enc_pipe_permissions)
				Func_assign_arg "Var_enc_pipe_permissions" "${_arg#*=}"
			;;
			--enc-pipe-ownership|Var_enc_pipe_ownership)
				Func_assign_arg "Var_enc_pipe_ownership" "${_arg#*=}"
			;;
			--enc-pipe-file|Var_enc_pipe_file)
				Func_assign_arg "Var_enc_pipe_file" "${_arg#*=}"
				Func_assign_arg "Var_enc_trap_command" "${Var_rm} ${_arg#*=}"
			;;
			--enc-trap-command|Var_enc_trap_command)
				Func_assign_arg "Var_enc_trap_command" "${_arg#*=}"
			;;
			---*)
				_extra_var="${_arg%=*}"
				_extra_arg="${_arg#*=}"
				Func_assign_arg "${_extra_var/---/}" "${_extra_arg}"
			;;
			--version)
				${Var_echo} "# ${Var_script_name} version: ${Var_script_version_full}"
				exit 0
			;;
			*)
				Func_message "# Func_check_args running: declare -ag \"Arr_extra_input+=( \${_arg} )\"" '2' '3'
				declare -ag "Arr_extra_input+=( ${_arg} )"
			;;
		esac
		let _arr_count++
	done
	unset _arr_count
}
Func_help(){
	echo "# ${Var_script_dir}/${Var_script_name} knows the following command line options"
	echo "## Standard command line options"
	echo "# --columns			Var_columns=\"${Var_columns}\""
	echo "# --debug-level			Var_debug_level=\"${Var_debug_level}\""
	echo "# --log-level			Var_log_level=\"${Var_log_level}\""
	echo "# --script-log-path		Var_script_log_path=\"${Var_script_log_path}\""
	echo "# --save-variables-yn		Var_save_variables_yn=\"${Var_save_variables_yn}\""
	echo "# --source-var-file		Var_source_var_file=\"${Var_source_var_file}\""
	echo "# --license			Display the license for this script."
	echo "# --help			Display this message."
	echo "# --version			Display version for this script."
	echo "## Decryption command line options"
	echo "# --dec-yn				Var_dec_yn=\"${Var_dec_yn}\""
	echo "# --dec-copy-save-yn			Var_dec_copy_save_yn=\"${Var_dec_copy_save_yn}\""
	echo "# --dec-copy-save-path			Var_dec_copy_save_path=\"${Var_dec_copy_save_path}\""
	echo "# --dec-diff-count-max			Var_dec_diff_count_max=\"${Var_dec_diff_count_max}\""
	echo "# --dec-diff-opts			Var_dec_diff_opts=\"${Var_dec_diff_opts}\""
	echo "# --dec-diff-sleep			Var_dec_diff_sleep=\"${Var_dec_diff_sleep}\""
	echo "# --dec-gpg-opts			Var_dec_gpg_opts=\"${Var_dec_gpg_opts}\""
	echo "# --dec-parsing-bulk-out-dir		Var_dec_parsing_bulk_out_dir=\"${Var_dec_parsing_bulk_out_dir}\""
	echo "# --dec-parsing-disown-yn		Var_dec_parsing_disown_yn=\"${Var_dec_parsing_disown_yn}\""
	echo "# --dec-parsing-save-output-yn	Var_dec_parsing_save_output_yn=\"${Var_dec_parsing_save_output_yn}\""
	echo "# --dec-parsing-output-file		Var_dec_parsing_output_file=\"${Var_dec_parsing_output_file}\""
	echo "# --dec-pass				Var_dec_pass=\"${Var_dec_pass}\""
	echo "# --dec-search-string			Var_dec_search_string=\"${Var_dec_search_string}\""
	echo "## Encryption command line options"
	echo "# --enc-yn				Var_enc_yn=\"${Var_enc_yn}\""
	echo "# --enc-copy-save-yn			Var_enc_copy_save_yn=\"${Var_enc_copy_save_yn}\""
	echo "# --enc-copy-save-path			Var_enc_copy_save_path=\"${Var_enc_copy_save_path}\""
	echo "# --enc-copy-save-ownership		Var_enc_copy_save_ownership=\"${Var_enc_copy_save_ownership}\""
	echo "# --enc-copy-save-permissions		Var_enc_copy_save_permissions=\"${Var_enc_copy_save_permissions}\""
	echo "# --enc-gpg-opts			Var_enc_gpg_opts=\"${Var_enc_gpg_opts}\""
	echo "# --enc-padding-enabled-yn		Var_enc_padding_enable_yn=\"${Var_enc_padding_enable_yn}\""
	echo "# --enc-padding-length			Var_enc_padding_length=\"${Var_enc_padding_length}\""
	echo "# --enc-padding-placement		Var_enc_padding_placement=\"${Var_enc_padding_placement}\""
	echo "# --enc-parsing-bulk-out-dir		Var_enc_parsing_bulk_out_dir=\"${Var_enc_parsing_bulk_out_dir}\""
	echo "# --enc-parsing-bulk-output-suffix	Var_enc_parsing_bulk_output_suffix=\"${Var_enc_parsing_bulk_output_suffix}\""
	echo "# --enc-parsing-disown-yn		Var_enc_parsing_disown_yn=\"${Var_enc_parsing_disown_yn}\""
	echo "# --enc-parsing-filter-input-yn		Var_enc_parsing_filter_input_yn=\"${Var_enc_parsing_filter_input_yn}\""
	echo "# --enc-parsing-filter-comment-pattern	Var_enc_parsing_filter_comment_pattern=\"${Var_enc_parsing_filter_comment_pattern}\""
	echo "# --enc-parsing-filter-allowed-chars	Var_enc_parsing_filter_allowed_chars=\"${Var_enc_parsing_filter_allowed_chars}\""
	echo "# --enc-parsing-recipient		Var_enc_parsing_recipient=\"${Var_enc_parsing_recipient}\""
	echo "# --enc-parsing-output-file		Var_enc_parsing_output_file=\"${Var_enc_parsing_output_file}\""
	echo "# --enc-parsing-output-rotate-yn	Var_enc_parsing_output_rotate_yn=\"${Var_enc_parsing_output_rotate_yn}\""
	echo "# --enc-parsing-output-rotate-actions	Var_enc_parsing_output_rotate_actions=\"${Var_enc_parsing_output_rotate_actions}\""
	echo "# --enc-parsing-output-rotate-recipient	Var_enc_parsing_output_rotate_recipient=\"${Var_enc_parsing_output_rotate_recipient}\""
	echo "# --enc-parsing-output-max-size		Var_enc_parsing_output_max_size=\"${Var_enc_parsing_output_max_size}\""
	echo "# --enc-parsing-output-check-frequency	Var_enc_parsing_output_check_frequency=\"${Var_enc_parsing_output_check_frequency}\""
	echo "# --enc-parsing-save-output-yn		Var_enc_parsing_save_output_yn=\"${Var_enc_parsing_save_output_yn}\""
	echo "# --enc-parsing-quit-string		Var_enc_parsing_quit_string=\"${Var_enc_parsing_quit_string}\""
	echo "# --enc-pipe-permissions		Var_enc_pipe_permissions=\"${Var_enc_pipe_permissions}\""
	echo "# --enc-pipe-ownership			Var_enc_pipe_ownership=\"${Var_enc_pipe_ownership}\""
	echo "# --enc-pipe-file			Var_enc_pipe_file=\"${Var_enc_pipe_file}\""
	echo "# --enc-trap-command			Var_enc_trap_command=\"${Var_enc_trap_command}\""
	echo "# --enc-parsing-output-permissions	Var_enc_parsing_output_permissions=\"${Var_enc_parsing_output_permissions}\""
	echo "# --enc-parsing-output-ownership	Var_enc_parsing_output_ownership=\"${Var_enc_parsing_output_ownership}\""
	echo "## File path variables"
	echo "# ---Var_dev_null			Var_dev_null=\"${Var_dev_null}\""
}
Func_script_license_customizer(){
	Func_message "## Salutations ${Var_script_current_user:-${USER}}, the following license" '0' '42'
	Func_message "#  only applies to this script [${Var_script_title}]. Software external to but" '0' '42'
	Func_message "#  used by [${Var_script_name}] are protected under their own licensing" '0' '42'
	Func_message "#  usage agreements. The authors of this project assume **no** rights" '0' '42'
	Func_message "#  to modify software licensing agreements external to [${Var_script_name}]" '0' '42'
	Func_message '## GNU AGPL v3 Notice start' '0' '42'
	Func_message "# ${Var_script_name}, maker of named pipe parsing template Bash scripts." '0' '42'
	Func_message "#  Copyright (C) 2016 S0AndS0" '0' '42'
	Func_message '# This program is free software: you can redistribute it and/or modify' '0' '42'
	Func_message '#  it under the terms of the GNU Affero General Public License as' '0' '42'
	Func_message '#  published by the Free Software Foundation, version 3 of the' '0' '42'
	Func_message '#  License.' '0' '42'
	Func_message '# You should have received a copy of the GNU Afferno General Public License' '0' '42'
	Func_message '# along with this program. If not, see <http://www.gnu.org/licenses/>.' '0' '42'
	Func_message "#  Contact authors of [${Var_script_name}] at: ${Var_authors_contact}" '0' '42'
	Func_message '# GNU AGPL v3 Notice end' '0' '42'
	if [ -r "${Var_script_dir}/Licenses/GNU_AGPLv3_Code.md" ]; then
		Func_message '## Found local license file, prompting to display...' '0' '42'
		Func_prompt_continue "Func_script_license_customizer"
		less -R5 "${Var_script_dir}/Licenses/GNU_AGPLv3_Code.md"
	else
		${Var_echo_exec_path} -en "Please input the downloaded source directory for ${Var_script_name}: "
		read -r _responce
		if [ -d "${_responce}" ] && [ -r "${_responce}/Licenses/GNU_AGPLv3_Code.md" ]; then
			Func_message '## Found local license file, prompting to display...' '0' '42'
			Func_prompt_continue "Func_script_license_customizer"
			fold -sw $((${Var_columns}-8)) "${_responce}/Licenses/GNU_AGPLv3_Code.md" | less -R5
		else
			Func_message '## Unable to find full license, see linke in above short version or find full license under downloaded source directory for this script.' '0' '42'
		fi
	fi
}
Func_message(){
	_message="${1}"
	_debug_level="${2:-${Var_debug_level}}"
	_log_level="${3:-${Var_log_level}}"
	if [ "${#_message}" != "0" ]; then
		if [ "${_debug_level}" = "${Var_debug_level}" ] || [ "${Var_debug_level}" -gt "${_debug_level}" ]; then
			_folded_message="$(fold -sw $((${Var_columns}-6)) <<<"${_message}" | sed -e "s/^.*$/$(${Var_echo} -n "#DBL-${_debug_level}") &/g")"
			${Var_cat} <<<"${_folded_message}"
		fi
	fi
	if [ "${#_message}" != "0" ]; then
		if [ "${Var_log_level}" -gt "${_log_level}" ]; then
			${Var_cat} <<<"${_message}" >> "${Var_script_log_path}"
		fi
	fi
}
Func_assign_arg(){
	_variable="${1}"
	_value="${2}"
	Func_message "# Func_assign_arg running: declare -g \"${_variable}=${_value}\"" '3' '4'
	declare -g "${_variable}=${_value}"
	Func_save_variables "${_variable}" "${_value}"
	unset _variable
	unset _value
}
Func_save_variables(){
	_variable="${1}"
	_value="${2}"
	case "${Var_save_variables_yn}" in
		Y|y|Yes|yes|YES)
			${Var_cat} >> "${Var_source_var_file}" <<EOF
${_variable}="${_value}"
EOF
		;;
	esac
}
Func_enc_make_named_pipe(){
	if ! [ -p "${Var_enc_pipe_file}" ]; then
		Func_message "# Func_enc_make_named_pipe running: ${Var_mkfifo} \"${Var_enc_pipe_file}\" || exit 1" '2' '3'
		${Var_mkfifo} "${Var_enc_pipe_file}" || exit 1
	fi
	Func_message "# Func_enc_make_named_pipe running: ${Var_chmod} \"${Var_enc_pipe_permissions}\" \"${Var_enc_pipe_file}\" || exit 1" '2' '3'
	${Var_chmod} "${Var_enc_pipe_permissions}" "${Var_enc_pipe_file}" || exit 1
	Func_message "# Func_enc_make_named_pipe running: ${Var_chown} \"${Var_enc_pipe_ownership}\" \"${Var_enc_pipe_file}\" || exit 1" '2' '3'
	${Var_chown} "${Var_enc_pipe_ownership}" "${Var_enc_pipe_file}" || exit 1
}
Func_enc_rotate_output_file(){
	_parsing_output_file="${1:-${Var_enc_parsing_output_file}}"
	_output_rotate_yn="${2:-${Var_enc_parsing_output_rotate_yn}}"
	_output_max_size="${3:-${Var_enc_parsing_output_max_size}}"
	_output_rotate_actions="${4:-${Var_enc_parsing_output_rotate_actions}}"
	_output_rotate_recipient="${5:-${Var_enc_parsing_output_rotate_recipient}}"
	case "${_output_rotate_yn}" in
		y|Y|yes|Yes|YES)
			if [ -f "${_parsing_output_file}" ]; then
				_file_size="$(du --bytes "${_parsing_output_file}" | awk '{print $1}' | head -n1)"
				if [ "${_file_size}" -gt "${_output_max_size}" ]; then
					_timestamp="$(date -u +%s)"
					for _actions in ${_output_rotate_actions//,/ }; do
						case "${_actions}" in
							mv|move)
								Func_message "# Func_enc_rotate_output_file running: ${Var_mv} \"${_parsing_output_file}\" \"${_parsing_output_file}.${_timestamp}\"" '4' '5'
								${Var_mv} "${_parsing_output_file}" "${_parsing_output_file}.${_timestamp}"
							;;
							compress-encrypt|encrypt)
								Func_message "# Func_enc_rotate_output_file running: ${Var_tar} -cz - \"${_parsing_output_file}\" | ${Var_gpg} --encrypt --recipient \"${_output_rotate_recipient}\" --output \"${_parsing_output_file}.${_timestamp}.tgz.gpg\"" '4' '5'
								${Var_tar} -cz - "${_parsing_output_file}" | ${Var_gpg} --encrypt --recipient "${_output_rotate_recipient}" --output "${_parsing_output_file}.${_timestamp}.tgz.gpg"
							;;
							encrypted-email)
								Func_message "# Func_enc_rotate_output_file running: ${Var_tar} -cz - \"${_parsing_output_file}\" | ${Var_gpg} --encrypt --recipient \"${_output_rotate_recipient}\" --output \"${_parsing_output_file}.${_timestamp}.tgz.gpg\"" '4' '5'
								${Var_tar} -cz - "${_parsing_output_file}" | ${Var_gpg} --encrypt --recipient "${_output_rotate_recipient}" --output "${_parsing_output_file}.${_timestamp}.tgz.gpg"
								Func_message "# Func_enc_rotate_output_file running: ${Var_echo} \"Sent at ${_timestamp}\" | mutt -s \"${_parsing_output_file}.${_timestamp}.tar.gz.gpg\" -a \"${_parsing_output_file}.${_timestamp}.tar.gz.gpg\" \"${_output_rotate_recipient}\"" '4' '5'
								${Var_echo} "Sent at ${_timestamp}" | mutt -s "${_parsing_output_file}.${_timestamp}.tar.gz.gpg" -a "${_parsing_output_file}.${_timestamp}.tar.gz.gpg" "${_output_rotate_recipient}"
							;;
							compressed-email)
								Func_message "# Func_enc_rotate_output_file running: ${Var_tar} -cz \"${_parsing_output_file}\" \"${_parsing_output_file}.${_timestamp}.tar.gz\"" '4' '5'
								${Var_tar} -cz "${_parsing_output_file}" "${_parsing_output_file}.${_timestamp}.tar.gz"
								Func_message "# Func_enc_rotate_output_file running: ${Var_echo} \"Sent at ${_timestamp}\" | mutt -s \"${_parsing_output_file}.${_timestamp}.tar.gz\" -a \"${_parsing_output_file}.${_timestamp}.tar.gz\" \"${_output_rotate_recipient}\"" '4' '5'
								${Var_echo} "Sent at ${_timestamp}" | mutt -s "${_parsing_output_file}.${_timestamp}.tar.gz" -a "${_parsing_output_file}.${_timestamp}.tar.gz" "${_output_rotate_recipient}"
							;;
							compress)
								Func_message "# Func_enc_rotate_output_file running: ${Var_tar} -cz \"${_parsing_output_file}\" \"${_parsing_output_file}.${_timestamp}.tar.gz\"" '4' '5'
								${Var_tar} -cz "${_parsing_output_file}" "${_parsing_output_file}.${_timestamp}.tar.gz"
							;;
							remove|rm|remove-old)
								Func_message "# Func_enc_rotate_output_file running: ${Var_rm} -f \"${_parsing_output_file}\"" '4' '5'
								${Var_rm} -f "${_parsing_output_file}"
							;;
						esac
					done
				fi
			fi
		;;
	esac
}
Func_enc_map_read_array_to_output(){
	_file_to_map="$1"
	mapfile -t _lines < "${_file_to_map}"
	let _count=0
	until [ "${_count}" = "${#_lines[@]}" ]; do
		if [ "${Var_enc_parsing_quit_string}" = "${_lines[${_count}]}" ]; then
			${Var_cat} <<<"${_line[${_count}]}"
			break
		else
			case "${Var_enc_padding_enable_yn}" in
				y|Y|yes|Yes|YES)
					_line=( "${_lines[${_count}]}" )
					case "${Var_enc_padding_length}" in
						adaptive)
							_padding_length="${#_lines[${_count}]}"
						;;
						*)
							_padding_length="${Var_enc_padding_length}"
						;;
					esac
					for _option in ${Var_enc_padding_placement//,/ }; do
						case "${_option}" in
							append)
								Var_padding_command="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c${_padding_length})"
								_line+=( "${Var_padding_command}" )
							;;
							prepend)
								Var_padding_command="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c${_padding_length})"
								_line=( "${Var_padding_command}" "${_line[${_count}]}" )
							;;
						esac
					done
					case "${Var_enc_parsing_filter_input_yn}" in
						y|Y|yes|Yes|YES)
							case "${_lines[${_count}]}" in
								${Var_enc_parsing_filter_comment_pattern})
									${Var_cat} <<<"${_line[@]//${Var_enc_parsing_filter_allowed_chars}/}"
								;;
								*)
									${Var_cat} <<<"# ${_line[*]//${Var_enc_parsing_filter_allowed_chars}/}"
								;;
							esac
							let _count++
						;;
						*)
							${Var_cat} <<<"${_line[@]}"
							let _count++
						;;
					esac
				;;
				*)
					case "${Var_enc_parsing_filter_input_yn}" in
						y|Y|yes|Yes|YES)
							case "${_lines[${_count}]}" in
								${Var_enc_parsing_filter_comment_pattern})
									${Var_cat} <<<"${_lines[${_count}]//${Var_enc_parsing_filter_allowed_chars}/}"
								;;
								*)
									${Var_cat} <<<"# ${_lines[${_count}]//${Var_enc_parsing_filter_allowed_chars}/}"
								;;
							esac
							let _count++
						;;
						*)
							${Var_cat} <<<"${_lines[${_count}]}"
							let _count++
						;;
					esac
				;;
			esac
		fi
	done
}
Func_enc_pipe_parser_loop(){
	_enc_gpg_opts="${Var_enc_gpg_opts} --recipient ${Var_enc_parsing_recipient// / --recipient }"
	while [ -p "${Var_enc_pipe_file}" ]; do
		_mapped_array="$(Func_enc_map_read_array_to_output "${Var_enc_pipe_file}")"
		if [ "${#_mapped_array}" != "0" ] && [ "${Var_enc_parsing_quit_string}" != "${_mapped_array}" ]; then
			case "${Var_enc_parsing_save_output_yn}" in
				y|Y|yes|Yes)
					if [ -f "${_mapped_array}" ]; then
						if ! [ -d "${Var_enc_parsing_bulk_out_dir}" ]; then
							Func_message "# Func_enc_pipe_parser_loop running: ${Var_mkdir} -p \"${Var_enc_parsing_bulk_out_dir}\"" '2' '3'
							${Var_mkdir} -p "${Var_enc_parsing_bulk_out_dir}"
						fi
						Var_star_date="$(date -u +%s)"
						Func_message "# Func_enc_pipe_parser_loop running: ${Var_cat} \"\${_mapped_array}\" | ${Var_gpg} ${_enc_gpg_opts} >> \"${Var_enc_parsing_bulk_out_dir}/${Var_star_date}_\${_mapped_array##*/}${Var_enc_parsing_bulk_output_suffix}\"" '2' '3'
						${Var_cat} "${_mapped_array}" | ${Var_gpg} ${_enc_gpg_opts} >> "${Var_enc_parsing_bulk_out_dir}/${Var_star_date}_${_mapped_array##*/}${Var_enc_parsing_bulk_output_suffix}"
					elif [ -d "${_mapped_array}" ]; then
						if ! [ -d "${Var_enc_parsing_bulk_out_dir}" ]; then
							Func_message "# Func_enc_pipe_parser_loop running: ${Var_mkdir} -p \"${Var_enc_parsing_bulk_out_dir}\"" '2' '3'
							${Var_mkdir} -p "${Var_enc_parsing_bulk_out_dir}"
						fi
						Var_star_date="$(date -u +%s)"
						Func_message "# Func_enc_pipe_parser_loop running: ${Var_tar} -cz - \"\${_mapped_array}\" | ${Var_gpg} ${_enc_gpg_opts} > ${Var_enc_parsing_bulk_out_dir}/${Var_star_date}_dir.tgz${Var_enc_parsing_bulk_output_suffix}" '2' '3'
						${Var_tar} -cz - "${_mapped_array}" | ${Var_gpg} ${_enc_gpg_opts} > "${Var_enc_parsing_bulk_out_dir}/${Var_star_date}_dir.tgz${Var_enc_parsing_bulk_output_suffix}"
					else
						if ! [ -f "${Var_enc_parsing_output_file}" ]; then
							Func_message "# Func_enc_pipe_parser_loop running: touch \"${Var_enc_parsing_output_file}\"" '2' '3'
							touch "${Var_enc_parsing_output_file}"
							Func_message "# Func_enc_pipe_parser_loop running: ${Var_chmod} \"${Var_enc_parsing_output_permissions}\" \"${Var_enc_parsing_output_file}\"" '2' '3'
							${Var_chmod} "${Var_enc_parsing_output_permissions}" "${Var_enc_parsing_output_file}"
							Func_message "# Func_enc_pipe_parser_loop running: ${Var_chown} \"${Var_enc_parsing_output_ownership}\" \"${Var_enc_parsing_output_file}\"" '2' '3'
							${Var_chown} "${Var_enc_parsing_output_ownership}" "${Var_enc_parsing_output_file}"
						fi
						Func_message "# Func_enc_pipe_parser_loop running: ${Var_cat} <<<\"\${_mapped_array}\" | ${Var_gpg} ${_enc_gpg_opts} >> \"${Var_enc_parsing_output_file}\"" '2' '3'
						${Var_cat} <<<"${_mapped_array}" | ${Var_gpg} ${_enc_gpg_opts} >> "${Var_enc_parsing_output_file}"
						let _count++
						if [ "${_count}" -gt "${Var_enc_parsing_output_check_frequency}" ] || [ "${_count}" = "${Var_enc_parsing_output_check_frequency}" ]; then
							Func_message "# Func_enc_pipe_parser_loop running: Func_enc_rotate_output_file \"${Var_enc_parsing_output_file}\" \"${Var_enc_parsing_output_rotate_yn}\" \"${Var_enc_parsing_output_max_size}\" \"${Var_enc_parsing_output_rotate_actions}\" \"${Var_enc_parsing_output_rotate_recipient}\"" '2' '3'
							Func_enc_rotate_output_file "${Var_enc_parsing_output_file}" "${Var_enc_parsing_output_rotate_yn}" "${Var_enc_parsing_output_max_size}" "${Var_enc_parsing_output_rotate_actions}" "${Var_enc_parsing_output_rotate_recipient}"
						fi
					fi
				;;
				*)
					Func_message "# Func_enc_pipe_parser_loop running: ${Var_cat} <<<\"\${_mapped_array}\" | ${Var_gpg} ${_enc_gpg_opts}" '2' '3'
					${Var_cat} <<<"${_mapped_array}" | ${Var_gpg} ${_enc_gpg_opts}
					let _count++
				;;
			esac
		elif [ "${Var_enc_parsing_quit_string}" = "${_mapped_array}" ]; then
			case "${Var_enc_parsing_disown_yn}" in
				Y|y|Yes|yes|YES)
					if [ -p "${Var_enc_pipe_file}" ]; then
						Func_message "# Func_enc_pipe_parser_loop running: ${Var_enc_trap_command}" '2' '3'
						${Var_enc_trap_command}
					else
						Func_message "# Func_enc_pipe_parser_loop reports: no pipe to remove at [${Var_enc_pipe_file}]" '2' '3'
					fi
				;;
				*)
					Func_message "# Func_enc_pipe_parser_loop reports: trap set outside [Map_read_input_to_array] function parsing loop" '2' '3'
				;;
			esac
			break
		elif ! [ -p "${Var_enc_pipe_file}" ]; then
			Func_message "# Func_enc_pipe_parser_loop reports: missing pipe ${Var_enc_pipe_file}" '2' '3'
			break
		fi
		unset _exit_status
	done
}
Func_enc_write_script_copy(){
	case "${Var_enc_copy_save_yn}" in
		Y|y|Yes|yes|YES)
			if [ -f "${Var_enc_copy_save_path}" ]; then
				Func_message "# Func_enc_write_script_copy reports script copy already exsists: ${Var_enc_copy_save_path}" '2' '3'
			else
				Func_message "# Func_enc_write_script_copy writing script copy: ${Var_enc_copy_save_path}" '2' '3'
				${Var_cat} > "${Var_enc_copy_save_path}" <<EOF
#!/usr/bin/env bash
set +o history
Var_script_dir="\${0%/*}"
Var_script_name="\${0##*/}"
Var_enc_gpg_opts="${Var_enc_gpg_opts}"
Var_enc_padding_enable_yn="${Var_enc_padding_enable_yn}"
Var_enc_padding_length="${Var_enc_padding_length}"
Var_enc_padding_placement="${Var_enc_padding_placement}"
Var_enc_parsing_bulk_out_dir="${Var_enc_parsing_bulk_out_dir}"
Var_enc_parsing_bulk_output_suffix="${Var_enc_parsing_bulk_output_suffix}"
Var_enc_parsing_disown_yn="${Var_enc_parsing_disown_yn}"
Var_enc_parsing_filter_input_yn="${Var_enc_parsing_filter_input_yn}"
Var_enc_parsing_filter_comment_pattern='${Var_enc_parsing_filter_comment_pattern}'
Var_enc_parsing_filter_allowed_chars='${Var_enc_parsing_filter_allowed_chars}'
Var_enc_parsing_recipient="${Var_enc_parsing_recipient}"
Var_enc_parsing_output_file="${Var_enc_parsing_output_file}"
Var_enc_parsing_output_rotate_yn="${Var_enc_parsing_output_rotate_yn}"
Var_enc_parsing_output_rotate_actions="${Var_enc_parsing_output_rotate_actions}"
Var_enc_parsing_output_rotate_recipient="${Var_enc_parsing_output_rotate_recipient}"
Var_enc_parsing_output_max_size="${Var_enc_parsing_output_max_size}"
Var_enc_parsing_output_check_frequency="${Var_enc_parsing_output_check_frequency}"
Var_enc_parsing_save_output_yn="${Var_enc_parsing_save_output_yn}"
Var_enc_parsing_quit_string="${Var_enc_parsing_quit_string}"
Var_enc_pipe_permissions="${Var_enc_pipe_permissions}"
Var_enc_pipe_ownership="${Var_enc_pipe_ownership}"
Var_enc_pipe_file="${Var_enc_pipe_file}"
Var_enc_trap_command="${Var_enc_trap_command}"
#Var_enc_parsing_output_permissions="${Var_enc_parsing_output_permissions}
Var_dev_null="${Var_dev_null}"
${Var_echo} "### ... Starting [\${Var_script_name}] at \$(date) ... ###"
Func_enc_clean_up_trap(){
	_exit_code="\$1"
	${Var_echo} "## \${Var_script_name} detected [\${_exit_code}] exit code, cleaning up before quiting..."
	if [ -p "\${Var_enc_pipe_file}" ]; then
		\${Var_enc_trap_command}
	fi
	${Var_echo} -n "### ... Finished [\${Var_script_name}] at \$(date) press [Enter] to resume terminal ... ###"
}
Func_enc_make_named_pipe(){
	if ! [ -p "\${Var_enc_pipe_file}" ]; then
		${Var_mkfifo} "\${Var_enc_pipe_file}" || exit 1
	fi
	${Var_chmod} "\${Var_enc_pipe_permissions}" "\${Var_enc_pipe_file}" || exit 1
	${Var_chown} "\${Var_enc_pipe_ownership}" "\${Var_enc_pipe_file}" || exit 1
}
Func_enc_rotate_output_file(){
	_parsing_output_file="\${1:-\${Var_enc_parsing_output_file}}"
	_output_rotate_yn="\${2:-\${Var_enc_parsing_output_rotate_yn}}"
	_output_max_size="\${3:-\${Var_enc_parsing_output_max_size}}"
	_output_rotate_actions="\${4:-\${Var_enc_parsing_output_rotate_actions}}"
	_output_rotate_recipient="\${5:-\${Var_enc_parsing_output_rotate_recipient}}"
	case "\${_output_rotate_yn}" in
		y|Y|yes|Yes|YES)
			if [ -f "\${_parsing_output_file}" ]; then
				_file_size="\$(du --bytes "\${_parsing_output_file}" | awk '{print \$1}' | head -n1)"
				if [ "\${_file_size}" -gt "\${_output_max_size}" ]; then
					_timestamp="\$(date -u +%s)"
					## Split commas into spaces and use case to match action options
					for _actions in \${_output_rotate_actions//,/ }; do
						case "\${_actions}" in
							mv|move)
								${Var_mv} "\${_parsing_output_file}" "\${_parsing_output_file}.\${_timestamp}"
							;;
							compress-encrypt|encrypt)
								${Var_tar} -cz - "\${_parsing_output_file}" | ${Var_gpg} --encrypt --recipient "\${_output_rotate_recipient}" --output "\${_parsing_output_file}.\${_timestamp}.tgz.gpg"
							;;
							encrypted-email)
								${Var_tar} -cz - "\${_parsing_output_file}" | ${Var_gpg} --encrypt --recipient "\${_output_rotate_recipient}" --output "\${_parsing_output_file}.\${_timestamp}.tgz.gpg"
								${Var_echo} "Sent at \${_timestamp}" | mutt -s "\${_parsing_output_file}.\${_timestamp}.tar.gz.gpg" -a "\${_parsing_output_file}.\${_timestamp}.tar.gz.gpg" "\${_output_rotate_recipient}"
							;;
							compressed-email)
								${Var_tar} -cz "\${_parsing_output_file}" "\${_parsing_output_file}.\${_timestamp}.tar.gz"
								${Var_echo} "Sent at \${_timestamp}" | mutt -s "\${_parsing_output_file}.\${_timestamp}.tar.gz" -a "\${_parsing_output_file}.\${_timestamp}.tar.gz" "\${_output_rotate_recipient}"
							;;
							compress)
								${Var_tar} -cz "\${_parsing_output_file}" "\${_parsing_output_file}.\${_timestamp}.tar.gz"
							;;
							remove|rm|remove-old)
								${Var_rm} -f "\${_parsing_output_file}"
							;;
						esac
					done
				fi
			fi
		;;
	esac
}
Func_enc_map_read_array_to_output(){
	_file_to_map="\$1"
	mapfile -t _lines < "\${_file_to_map}"
	let _count=0
	until [ "\${_count}" = "\${#_lines[@]}" ]; do
		if [ "\${Var_enc_parsing_quit_string}" = "\${_lines[\${_count}]}" ]; then
			${Var_cat} <<<"\${_line[\${_count}]}"
			break
		else
			case "\${Var_enc_padding_enable_yn}" in
				y|Y|yes|Yes|YES)
					_line=( "\${_lines[\${_count}]}" )
					case "\${Var_enc_padding_length}" in
						adaptive)
							_padding_length="\${#_lines[\${_count}]}"
						;;
						*)
							_padding_length="\${Var_enc_padding_length}"
						;;
					esac
					for _option in \${Var_enc_padding_placement//,/ }; do
						case "\${_option}" in
							append)
								Var_padding_command="\$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c\${_padding_length})"
								_line+=( "\${Var_padding_command}" )
							;;
							prepend)
								Var_padding_command="\$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c\${_padding_length})"
								_line=( "\${Var_padding_command}" "\${_line[\${_count}]}" )
							;;
						esac
					done
					case "\${Var_enc_parsing_filter_input_yn}" in
						y|Y|yes|Yes|YES)
							case "\${_lines[\${_count}]}" in
								\${Var_enc_parsing_filter_comment_pattern})
									${Var_cat} <<<"\${_line[@]//\${Var_enc_parsing_filter_allowed_chars}/}"
								;;
								*)
									${Var_cat} <<<"# \${_line[*]//\${Var_enc_parsing_filter_allowed_chars}/}"
								;;
							esac
							let _count++
						;;
						*)
							${Var_cat} <<<"\${_line[@]}"
							let _count++
						;;
					esac
				;;
				*)
					case "\${Var_enc_parsing_filter_input_yn}" in
						y|Y|yes|Yes|YES)
							case "\${_lines[\${_count}]}" in
								\${Var_enc_parsing_filter_comment_pattern})
									${Var_cat} <<<"\${_lines[\${_count}]//\${Var_enc_parsing_filter_allowed_chars}/}"
								;;
								*)
									${Var_cat} <<<"# \${_lines[\${_count}]//\${Var_enc_parsing_filter_allowed_chars}/}"
								;;
							esac
							let _count++
						;;
						*)
							${Var_cat} <<<"\${_lines[\${_count}]}"
							let _count++
						;;
					esac
				;;
			esac
		fi
	done
}
Func_enc_pipe_parser_loop(){
	_enc_gpg_opts="\${Var_enc_gpg_opts} --recipient \${Var_enc_parsing_recipient// / --recipient }"
	while [ -p "\${Var_enc_pipe_file}" ]; do
		_mapped_array="\$(Func_enc_map_read_array_to_output "\${Var_enc_pipe_file}")"
		if [ "\${#_mapped_array}" != "0" ] && [ "\${Var_enc_parsing_quit_string}" != "\${_mapped_array}" ]; then
			case "\${Var_enc_parsing_save_output_yn}" in
				y|Y|yes|Yes)
					if [ -f "\${_mapped_array}" ]; then
						if ! [ -d "\${Var_enc_parsing_bulk_out_dir}" ]; then
							${Var_mkdir} -p "\${Var_enc_parsing_bulk_out_dir}"
						fi
						Var_star_date="\$(date -u +%s)"
						${Var_cat} "\${_mapped_array}" | ${Var_gpg} \${_enc_gpg_opts} >> "\${Var_enc_parsing_bulk_out_dir}/\${Var_star_date}_\${_mapped_array##*/}\${Var_enc_parsing_bulk_output_suffix}"
					elif [ -d "\${_mapped_array}" ]; then
						if ! [ -d "\${Var_enc_parsing_bulk_out_dir}" ]; then
							${Var_mkdir} -p "\${Var_enc_parsing_bulk_out_dir}"
						fi
						Var_star_date="\$(date -u +%s)"
						${Var_tar} -cz - "\${_mapped_array}" | ${Var_gpg} \${_enc_gpg_opts} > "\${Var_enc_parsing_bulk_out_dir}/\${Var_star_date}_dir.tgz\${Var_enc_parsing_bulk_output_suffix}"
					else
						if ! [ -f "\${Var_enc_parsing_output_file}" ]; then
							touch "\${Var_enc_parsing_output_file}"
							${Var_chmod} "\${Var_enc_parsing_output_permissions}" "\${Var_enc_parsing_output_file}"
							${Var_chown} "\${Var_enc_parsing_output_ownership}" "\${Var_enc_parsing_output_file}"
						fi
						${Var_cat} <<<"\${_mapped_array}" | ${Var_gpg} \${_enc_gpg_opts} >> "\${Var_enc_parsing_output_file}"
						let _count++
						if [ "\${_count}" -gt "\${Var_enc_parsing_output_check_frequency}" ] || [ "\${_count}" = "\${Var_enc_parsing_output_check_frequency}" ]; then
							Func_enc_rotate_output_file "\${Var_enc_parsing_output_file}" "\${Var_enc_parsing_output_rotate_yn}" "\${Var_enc_parsing_output_max_size}" "\${Var_enc_parsing_output_rotate_actions}" "\${Var_enc_parsing_output_rotate_recipient}"
						fi
					fi
				;;
				*)
					${Var_cat} <<<"\${_mapped_array}" | ${Var_gpg} \${_enc_gpg_opts}
					let _count++
				;;
			esac
		elif [ "\${Var_enc_parsing_quit_string}" = "\${_mapped_array}" ]; then
			case "\${Var_enc_parsing_disown_yn}" in
				Y|y|Yes|yes|YES)
					if [ -p "\${Var_enc_pipe_file}" ]; then
						\${Var_enc_trap_command}
					else
						${Var_echo} "# ...No pipe to remove at [\${Var_enc_pipe_file}]"
					fi
				;;
				*)
					${Var_echo} "# \${Var_script_name} trap set outside [Map_read_input_to_array] function parsing loop"
				;;
			esac
			break
		elif ! [ -p "\${Var_enc_pipe_file}" ]; then
			break
		fi
		unset _exit_status
	done
}
Func_assign_arg(){
	_variable="\${1}"
	_value="\${2}"
	declare -g "\${_variable}=\${_value}"
	unset _variable
	unset _value
}
Func_check_args(){
	_arr_input=( "\${@}" )
	let _arr_count=0
	until [ "\${#_arr_input[@]}" = "\${_arr_count}" ]; do
		_arg="\${_arr_input[\${_arr_count}]}"
		case "\${_arg%=*}" in
			--enc-gpg-opts|Var_enc_gpg_opts)
				Func_assign_arg "Var_enc_gpg_opts" "\${_arg#*=}"
			;;
			--enc-padding-enable-yn|Var_enc_padding_enable_yn)
				Func_assign_arg "Var_enc_padding_enable_yn" "\${_arg#*=}"
			;;
			--enc-padding-length|Var_enc_padding_length)
				Func_assign_arg "Var_enc_padding_length" "\${_arg#*=}"
			;;
			--enc-padding-placement|Var_enc_padding_placement)
				Func_assign_arg "Var_enc_padding_placement" "\${_arg#*=}"
			;;
			--enc-parsing-bulk-out-dir|Var_enc_parsing_bulk_out_dir)
				Func_assign_arg "Var_enc_parsing_bulk_out_dir" "\${_arg#*=}"
			;;
			--enc-parsing-bulk-output-suffix|Var_enc_parsing_bulk_output_suffix)
				Func_assign_arg "Var_enc_parsing_bulk_output_suffix" "\${_arg#*=}"
			;;
			--enc-parsing-disown-yn|Var_enc_parsing_disown_yn)
				Func_assign_arg "Var_enc_parsing_disown_yn" "\${_arg#*=}"
			;;
			--enc-parsing-filter-input-yn|Var_enc_parsing_filter_input_yn)
				Func_assign_arg "Var_enc_parsing_filter_input_yn" "\${_arg#*=}"
			;;
			--enc-parsing-filter-comment-pattern|Var_enc_parsing_filter_comment_pattern)
				Func_assign_arg "Var_enc_parsing_filter_comment_pattern" "\${_arg#*=}"
			;;
			--enc-parsing-filter-allowed-chars|Var_enc_parsing_filter_allowed_chars)
				Func_assign_arg "Var_enc_parsing_filter_allowed_chars" "\${_arg#*=}"
			;;
			--enc-parsing-recipient|Var_enc_parsing_recipient)
				Func_assign_arg "Var_enc_parsing_recipient" "\${_arg#*=}"
			;;
			--enc-parsing-output-file|Var_enc_parsing_output_file)
				Func_assign_arg "Var_enc_parsing_output_file" "\${_arg#*=}"
			;;
			--enc-parsing-output-rotate-yn|Var_enc_parsing_output_rotate_yn)
				Func_assign_arg "Var_enc_parsing_output_rotate_yn" "\${_arg#*=}"
			;;
			--enc-parsing-output-rotate-actions|Var_enc_parsing_output_rotate_actions)
				Func_assign_arg "Var_enc_parsing_output_rotate_actions" "\${_arg#*=}"
			;;
			--enc-parsing-output-rotate-recipient|Var_enc_parsing_output_rotate_recipient)
				Func_assign_arg "Var_enc_parsing_output_rotate_recipient" "\${_arg#*=}"
			;;
			--enc-parsing-output-max-size|Var_enc_parsing_output_max_size)
				Func_assign_arg "Var_enc_parsing_output_max_size" "\${_arg#*=}"
			;;
			--enc-parsing-output-check-frequency|Var_enc_parsing_output_check_frequency)
				Func_assign_arg "Var_enc_parsing_output_check_frequency" "\${_arg#*=}"
			;;
			--enc-parsing-save-output-yn|Var_enc_parsing_save_output_yn)
				Func_assign_arg "Var_enc_parsing_save_output_yn" "\${_arg#*=}"
			;;
			--enc-parsing-output-permissions|Var_enc_parsing_output_permissions)
				Func_assign_arg "Var_enc_parsing_output_permissions" "\${_arg#*=}"
			;;
			--enc-parsing-output-ownership|Var_enc_parsing_output_ownership)
				Func_assign_arg "Var_enc_parsing_output_ownership" "\${_arg#*=}"
			;;
			--enc-parsing-quit-string|Var_enc_parsing_quit_string)
				Func_assign_arg "Var_enc_parsing_quit_string" "\${_arg#*=}"
			;;
			--enc-pipe-permissions|Var_enc_pipe_permissions)
				Func_assign_arg "Var_enc_pipe_permissions" "\${_arg#*=}"
			;;
			--enc-pipe-ownership|Var_enc_pipe_ownership)
				Func_assign_arg "Var_enc_pipe_ownership" "\${_arg#*=}"
			;;
			--enc-pipe-file|Var_enc_pipe_file)
				Func_assign_arg "Var_enc_pipe_file" "\${_arg#*=}"
				Func_assign_arg "Var_enc_trap_command" "${Var_rm} \${_arg#*=}"
			;;
			--enc-trap-command|Var_enc_trap_command)
				Func_assign_arg "Var_enc_trap_command" "\${_arg#*=}"
			;;
			--source-var-file|Var_source_var_file)
				Func_assign_arg "Var_source_var_file" "\${_arg#*=}"
				if [ -f "\${Var_source_var_file}" ]; then
					source "\${Var_source_var_file}"
				fi
			;;
			---*)
				_extra_var="\${_arg%=*}"
				_extra_arg="\${_arg#*=}"
				Func_assign_arg "\${_extra_var/---/}" "\${_extra_arg}"
			;;
			*)
				declare -ag "Arr_extra_input+=( \${_arg} )"
			;;
		esac
		let _arr_count++
	done
	unset _arr_count
}
Func_main(){
	_input=( "\$@" )
	if [ "\${#_input[@]}" != "0" ]; then
		Func_check_args "\${_input[@]}"
	fi
	case "\${Var_enc_parsing_disown_yn}" in
		Y|y|Yes|yes|YES)
			${Var_echo} "## \${Var_script_name} will differ cleanup trap assignment until reading from named pipe [\${Var_enc_pipe_file}] has finished..."
		;;
		*)
			${Var_echo} "## \${Var_script_name} will set exit trap now."
			trap 'Func_enc_clean_up_trap \${?}' EXIT
		;;
	esac
	Func_enc_make_named_pipe
	case "\${Var_enc_parsing_disown_yn}" in
		Y|y|Yes|yes|YES)
			Func_enc_pipe_parser_loop >"\${Var_dev_null}" 2>&1 &
			PID_Func_enc_pipe_parser_loop=\$!
			disown "\${PID_Func_enc_pipe_parser_loop}"
			${Var_echo} "## \${Var_script_name} disowned PID [\${PID_Func_enc_pipe_parser_loop}] parsing loops"
		;;
		*)
			${Var_echo} "## \${Var_script_name} will start parsing loop in this terminal"
			Func_enc_pipe_parser_loop
			${Var_echo} "# Quitting \${Var_script_name} listener"
			set -o history
		;;
	esac
}
Func_main "\$@"
${Var_echo} "# \${Var_script_dir}/\${Var_script_name} exited [\$?] at: \$(date)"

EOF

				Func_message "# Func_enc_write_script_copy running: ${Var_chown} \"${Var_enc_copy_save_ownership}\" \"${Var_enc_copy_save_path}\"" '2' '3'
				${Var_chown} "${Var_enc_copy_save_ownership}" "${Var_enc_copy_save_path}"
				Func_message "# Func_enc_write_script_copy running: ${Var_chmod} \"${Var_enc_copy_save_permissions}\" \"${Var_enc_copy_save_path}\"" '2' '3'
				${Var_chmod} "${Var_enc_copy_save_permissions}" "${Var_enc_copy_save_path}"
			fi
		;;
		*)
			Func_message "# Func_enc_write_script_copy skipping writing of: ${Var_enc_copy_save_path}" '2' '3'
		;;
	esac
}
Func_dec_pass_the_pass(){
	_pass=( "$@" )
	if [ -f "${_pass[@]}" ]; then
		Func_message "# Func_dec_pass_the_pass running: exec 9<\"\${_pass[@]}\"" '4' '5'
		exec 9<"${_pass[@]}"
	else
		Func_message "# Func_dec_pass_the_pass running: exec 9<(${Var_echo} \"\${_pass[@]}\")" '4' '5'
		exec 9<(${Var_echo} "${_pass[@]}")
	fi
}
Func_dec_remove_padding_from_output(){
	_input=( "$@" )
	let _count=0
	until [ "${_count}" = "${#_input[@]}" ]; do
		if grep -qE "append|prepend" <<<"${Var_enc_padding_placement//,/ }"; then
			if grep -qE "append"  <<<"${Var_enc_padding_placement//,/ }" && grep -qE "prepend"  <<<"${Var_enc_padding_placement//,/ }"; then
				case "${Var_enc_padding_length}" in
					adaptive)
						_padding_length="$((${#_input[${_count}]}/3))"
					;;
					*)
						_padding_length="${Var_enc_padding_length}"
					;;
				esac
				_line[${_count}]=( "${_input[${_count}]::-${_padding_length}}" )
				_line[${_count}]=( "${_input[${_count}]:${_padding_length}}" )
			elif grep -qE "append"  <<<"${Var_enc_padding_placement//,/ }"; then
				case "${Var_enc_padding_length}" in
					adaptive)
						_padding_length="$((${#_input[${_count}]}/2))"
					;;
					*)
						_padding_length="${Var_enc_padding_length}"
					;;
				esac
				_line[${_count}]=( "${_input[${_count}]::-${_padding_length}}" )
			else
				case "${Var_enc_padding_length}" in
					adaptive)
						_padding_length="$((${#_input[${_count}]}/2))"
					;;
					*)
						_padding_length="${Var_enc_padding_length}"
					;;
				esac
				_line[${_count}]=( "${_input[${_count}]:${_padding_length}}" )
			fi
		else
			_line[${_count}]=( "${_input[${_count}]}" )
		fi
		let _count++
	done
	${Var_echo} "${_line[@]}"
	unset -v _input[@]
	unset -v _line[@]
}
Func_dec_expand_array_to_block(){
	_input=( "$@" )
	let _count=0
	until [ "${_count}" = "${#_input[@]}" ]; do
		${Var_echo} "${_input[${_count}]}"
		let _count++
	done
	unset _count
	unset -v _input[@]
}
Func_dec_do_stuff_with_lines(){
	_enc_block=( "$@" )
	_enc_input=$(Func_dec_expand_array_to_block "${_enc_block[@]}")
	Func_message "# Func_dec_do_stuff_with_lines running: Func_dec_pass_the_pass \"\${Var_dec_pass}\"" '3' '4'
	Func_dec_pass_the_pass "${Var_dec_pass}"
	if [ -p "${Var_dec_parsing_output_file}" ]; then
		Func_message "# Func_dec_do_stuff_with_lines running: ${Var_cat} <<<\"\${_enc_input}\" > \"${Var_dec_parsing_output_file}\"" '3' '4'
		${Var_cat} <<<"${_enc_input}" > "${Var_dec_parsing_output_file}"
	elif [ -f "${Var_dec_parsing_output_file}" ]; then
		case "${Var_enc_padding_enable_yn}" in
			Y|y|Yes|yes|YES)
				if [ "${#Var_dec_search_string}" = "0" ]; then
					Func_message "# Func_dec_do_stuff_with_lines running: Func_dec_remove_padding_from_output \"\$(${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts})\" >> \"${Var_dec_parsing_output_file}\"" '3' '4'
					Func_dec_remove_padding_from_output "$(${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts})" >> "${Var_dec_parsing_output_file}"
				else
					Func_message "# ${Var_script_name} running: Func_dec_remove_padding_from_output \"\$(${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E \"${Var_dec_search_string}\")\" >> \"${Var_dec_parsing_output_file}\"" '3' '4'
					Func_dec_remove_padding_from_output "$(${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E "${Var_dec_search_string}")" >> "${Var_dec_parsing_output_file}"
				fi
			;;
			*)
				if [ "${#Var_dec_search_string}" = "0" ]; then
					Func_message "# Func_dec_do_stuff_with_lines running: ${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts} >> \"${Var_dec_parsing_output_file}\"" '3' '4'
					${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts} >> "${Var_dec_parsing_output_file}"
				else
					Func_message "# Func_dec_do_stuff_with_lines running: ${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E \"${Var_dec_search_string}\" >> \"${Var_dec_parsing_output_file}\"" '3' '4'
					${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E "${Var_dec_search_string}" >> "${Var_dec_parsing_output_file}"
				fi
			;;
		esac
	else
		case "${Var_enc_padding_enable_yn}" in
			Y|y|Yes|yes|YES)
				if [ "${#Var_dec_search_string}" = "0" ]; then
					Func_message "# Func_dec_do_stuff_with_lines running: Func_dec_remove_padding_from_output \"\$(${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts})\"" '3' '4'
					Func_dec_remove_padding_from_output "$(${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts})"
				else
					Func_message "# Func_dec_do_stuff_with_lines running: Func_dec_remove_padding_from_output \"\$(${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E \"${Var_dec_search_string}\")\"" '3' '4'
					Func_dec_remove_padding_from_output "$(${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E "${Var_dec_search_string}")"
				fi
			;;
			*)
				if [ "${#Var_dec_search_string}" = "0" ]; then
					Func_message "# Func_dec_do_stuff_with_lines running: ${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts}" '3' '4'
					${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts}
				else
					Func_message "# Func_dec_do_stuff_with_lines running: ${Var_cat} <<<\"\${_enc_input}\" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E \"${Var_dec_search_string}\"" '3' '4'
					${Var_cat} <<<"${_enc_input}" | ${Var_gpg} ${Var_dec_gpg_opts} | grep -E "${Var_dec_search_string}"
				fi
			;;
		esac
	fi
	unset -v _enc_block[@]
	unset _enc_input
	exec 9>&-
}
Func_dec_spoon_feed_armored_packets(){
	_input=( "${@}" )
	_beginning_of_line='-----BEGIN PGP MESSAGE-----'
	_end_of_line='-----END PGP MESSAGE-----'
	if [ -f "${_input[@]}" ]; then
		mapfile -t _arr_input < "${_input[@]}"
	else
		mapfile -t _arr_input <<<"${_input[@]}"
	fi
	let _count=0
	until [ "${_count}" = "${#_arr_input[@]}" ]; do
		if [ "${_end_of_line}" = "${_arr_input[${_count}]}" ]; then
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			let _count++
			Func_message "# Func_dec_spoon_feed_armored_packets running: Func_dec_do_stuff_with_lines \"\${_arr_to_parse[@]}\"" '2' '3'
			Func_dec_do_stuff_with_lines "${_arr_to_parse[@]}"
			unset -v _arr_to_parse[@]
		elif [ "${_beginning_of_line}" = "${_arr_input[${_count}]}" ]; then
			_arr_to_parse=( "${_arr_input[${_count}]}" )
			let _count++
		else
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			let _count++
		fi

	done
	unset _count
	unset -v _input[@]
	unset -v _arr_input[@]
}
Func_dec_file_or_dir(){
	_encrypted_path="${1}"
	Func_message "# Func_dec_file_or_dir running: Func_dec_pass_the_pass \"\${Var_dec_pass}\"" '5' '6'
	Func_dec_pass_the_pass "${Var_dec_pass}"
	case "${_encrypted_path}" in
		*.tar.gpg)
			_old_pwd="${PWD}"
			_output_dir="${Var_dec_parsing_bulk_out_dir}/${_encrypted_path##*/}"
			_output_dir="${_output_dir%.tar.gpg*}"
			if ! [ -d "${_output_dir}" ]; then
				Func_message "# Func_dec_file_or_dir running: mkdir -p \"${_output_dir}\"" '5' '6'
				mkdir -p "${_output_dir}"
				Func_message "# Func_dec_file_or_dir running: cd \"${_output_dir}\"" '5' '6'
				cd "${_output_dir}"
				Func_message "# Func_dec_file_or_dir running: ${Var_gpg} ${Var_dec_gpg_opts} \"${_encrypted_path}\" | tar -xf -" '5' '6'
				${Var_gpg} ${Var_dec_gpg_opts}  "${_encrypted_path}" | tar -xf -
				Func_message "# Func_dec_file_or_dir running: cd \"${_old_pwd}\"" '5' '6'
				cd "${_old_pwd}"
			fi
			unset _old_pwd
		;;
		*.tgz.gpg)
			_old_pwd="${PWD}"
			_output_dir="${Var_dec_parsing_bulk_out_dir}/${_encrypted_path##*/}"
			_output_dir="${_output_dir%.tgz.gpg*}"
			if ! [ -d "${_output_dir}" ]; then
				Func_message "# Func_dec_file_or_dir running: mkdir -p \"${_output_dir}\"" '5' '6'
				mkdir -p "${_output_dir}"
				Func_message "# Func_dec_file_or_dir running: cd \"${_output_dir}\"" '5' '6'
				cd "${_output_dir}"
				Func_message "# Func_dec_file_or_dir running: ${Var_gpg} ${Var_dec_gpg_opts} \"${_encrypted_path}\" | tar -xzf -" '5' '6'
				${Var_gpg} ${Var_dec_gpg_opts} "${_encrypted_path}" | tar -xzf -
				Func_message "# Func_dec_file_or_dir running: cd \"${_old_pwd}\"" '5' '6'
				cd "${_old_pwd}"
			fi
			unset _old_pwd
		;;
		*.gpg)
			if ! [ -d "${Var_dec_parsing_bulk_out_dir}" ]; then
				Func_message "# Func_dec_file_or_dir running: mkdir -p \"${Var_dec_parsing_bulk_out_dir}\"" '5' '6'
				mkdir -p "${Var_dec_parsing_bulk_out_dir}"
			fi
			_output_file="${Var_dec_parsing_bulk_out_dir}/${_encrypted_path##*/}"
			_output_file="${_output_file%.gpg*}"
			if ! [ -f "${_output_file}" ]; then
				Func_message "# Func_dec_file_or_dir running: ${Var_cat} \"${_encrypted_path}\" | ${Var_gpg} ${Var_dec_gpg_opts} > \"${_output_file}\"" '5' '6'
				${Var_cat} "${_encrypted_path}" | ${Var_gpg} ${Var_dec_gpg_opts} > "${_output_file}"
				unset _output_file
			fi
		;;
	esac
	exec 9>&-
	unset _encrypted_path
}
Func_dec_watch_bulk_dir(){
	_current_sig=""
	let _watch_count=0
	while [ -d "${Var_enc_parsing_bulk_out_dir}" ]; do
		_new_sig="$(find ${Var_enc_parsing_bulk_out_dir} -xtype f -print0 | xargs -0 sha1sum | awk '{print $1}' | sort | sha1sum | awk '{print $1}')"
		if [ "${_current_sig}" != "${_new_sig}" ]; then
			for _path in $(find ${Var_enc_parsing_bulk_out_dir} -xtype f); do
				Func_message "# Func_dec_watch_bulk_dir running: Func_dec_file_or_dir \"${Var_enc_parsing_bulk_out_dir}/${_path}\"" '3' '4'
				Func_dec_file_or_dir "${Var_enc_parsing_bulk_out_dir}/${_path}"
			done
		fi
		_current_sig="${_new_sig}"
		let _watch_count++
		if [ "${Var_dec_diff_count_max}" != "0" ] && [ "${_diff_count}" -gt "${Var_dec_diff_count_max}" ]; then
			unset _watch_count
			Func_message "# Func_dec_watch_bulk_dir running: break" '3' '4'
			break
		fi
		Func_message "# Func_dec_watch_bulk_dir [${_watch_count}] running: sleep ${Var_dec_diff_sleep}" '3' '4'
		sleep ${Var_dec_diff_sleep}
	done
}
Func_dec_watch_file(){
	_enc_parsing_output_file="${1:-${Var_enc_parsing_output_file}}"
	Func_message "# Func_dec_watch_file parsing: ${_enc_parsing_output_file}" '3' '4'
	if [ -p "${_enc_parsing_output_file}" ]; then
		Func_message "# Func_dec_watch_file detected pipe: ${_enc_parsing_output_file} " '3' '4'
		while [ -p "${_enc_parsing_output_file}" ]; do
			Func_dec_spoon_feed_armored_packets "${_enc_parsing_output_file}"
			if ! [ -p "${_enc_parsing_output_file}" ]; then
				break
			fi
		done
	elif [ -f "${_enc_parsing_output_file}" ]; then
		Func_message "# Func_dec_watch_file running: Func_dec_spoon_feed_armored_packets \"${_enc_parsing_output_file}\"" '3' '4'
		Func_dec_spoon_feed_armored_packets "${_enc_parsing_output_file}"
	else
		Func_message "# Func_dec_watch_file running: Func_dec_spoon_feed_armored_packets \"\${_enc_parsing_output_file}\"" '3' '4'
		Func_dec_spoon_feed_armored_packets "${_enc_parsing_output_file}"
	fi
}
Func_dec_write_script_copy(){
	case "${Var_dec_copy_save_yn}" in
		Y|y|Yes|yes|YES)
			if [ -f "${Var_dec_copy_save_path}" ]; then
				Func_message "# Func_enc_write_script_copy reports script copy already exsists: ${Var_dec_copy_save_path}" '2' '3'
			else
				Func_message "# Func_enc_write_script_copy writing script copy: ${Var_dec_copy_save_path}" '2' '3'
				${Var_cat} > "${Var_dec_copy_save_path}" <<EOF
#!/usr/bin/env bash
Var_script_dir="\${0%/*}"
Var_script_name="\${0##*/}"
Var_enc_parsing_output_file="${Var_enc_parsing_output_file}"
Var_dec_parsing_save_output_yn="${Var_dec_parsing_save_output_yn}"
Var_dec_parsing_output_file="${Var_dec_parsing_output_file}"
Var_dec_pass="${Var_dec_pass}"
Var_dec_search_string="${Var_dec_search_string}"
Var_dec_gpg_opts="${Var_dec_gpg_opts}"
Var_enc_parsing_bulk_out_dir="${Var_enc_parsing_bulk_out_dir}"
Var_dec_parsing_bulk_out_dir="${Var_dec_parsing_bulk_out_dir}"
Var_enc_padding_enable_yn="${Var_enc_padding_enable_yn}"
Var_enc_padding_length="${Var_enc_padding_length}"
Var_enc_padding_placement="${Var_enc_padding_placement}"
Var_dec_parsing_disown_yn="${Var_dec_parsing_disown_yn}"
Var_dec_diff_count_max="${Var_dec_diff_count_max}"
Var_dec_diff_opts="${Var_dec_diff_opts}"
Var_dec_diff_sleep="${Var_dec_diff_sleep}"
Var_dev_null="${Var_dev_null}"
Func_dec_pass_the_pass(){
	_pass=( "\$@" )
	if [ -f "\${_pass[@]}" ]; then
		exec 9<"\${_pass[@]}"
	else
		exec 9<(${Var_echo} "\${_pass[@]}")
	fi
}
Func_dec_remove_padding_from_output(){
	_input=( "\$@" )
	let _count=0
	until [ "\${_count}" = "\${#_input[@]}" ]; do
		if grep -qE "append|prepend" <<<"\${Var_enc_padding_placement//,/ }"; then
			if grep -qE "append"  <<<"\${Var_enc_padding_placement//,/ }" && grep -qE "prepend"  <<<"\${Var_enc_padding_placement//,/ }"; then
				case "\${Var_enc_padding_length}" in
					adaptive)
						_padding_length="\$((\${#_input[\${_count}]}/3))"
					;;
					*)
						_padding_length="\${Var_enc_padding_length}"
					;;
				esac
				_line[\${_count}]=( "\${_input[\${_count}]::-\${_padding_length}}" )
				_line[\${_count}]=( "\${_input[\${_count}]:\${_padding_length}}" )
			elif grep -qE "append"  <<<"\${Var_enc_padding_placement//,/ }"; then
				case "\${Var_enc_padding_length}" in
					adaptive)
						_padding_length="\$((\${#_input[\${_count}]}/2))"
					;;
					*)
						_padding_length="\${Var_enc_padding_length}"
					;;
				esac
				_line[\${_count}]=( "\${_input[\${_count}]::-\${_padding_length}}" )
			else
				case "\${Var_enc_padding_length}" in
					adaptive)
						_padding_length="\$((\${#_input[\${_count}]}/2))"
					;;
					*)
						_padding_length="\${Var_enc_padding_length}"
					;;
				esac
				_line[\${_count}]=( "\${_input[\${_count}]:\${_padding_length}}" )
			fi
		else
			_line[\${_count}]=( "\${_input[\${_count}]}" )
		fi
		let _count++
	done
	${Var_echo} "\${_line[@]}"
	unset -v _input[@]
	unset -v _line[@]
}
Func_dec_expand_array_to_block(){
	_input=( "\$@" )
	let _count=0
	until [ "\${_count}" = "\${#_input[@]}" ]; do
		${Var_echo} "\${_input[\${_count}]}"
		let _count++
	done
	unset _count
	unset -v _input[@]
}
Func_dec_do_stuff_with_lines(){
	_enc_block=( "\$@" )
	_enc_input=$(Func_dec_expand_array_to_block "\${_enc_block[@]}" )
	Func_dec_pass_the_pass "\${Var_dec_pass}"
	if [ -p "\${Var_dec_parsing_output_file}" ]; then
		${Var_cat} <<<"\${_enc_input}" > "\${Var_dec_parsing_output_file}"
	elif [ -f "\${Var_dec_parsing_output_file}" ]; then
		case "\${Var_enc_padding_enable_yn}" in
			Y|y|Yes|yes|YES)
				if [ "\${#Var_dec_search_string}" = "0" ]; then
					Func_dec_remove_padding_from_output "\$(${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts})" >> "\${Var_dec_parsing_output_file}"
				else
					Func_dec_remove_padding_from_output "\$(${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts} | grep -E "\${Var_dec_search_string}")" >> "\${Var_dec_parsing_output_file}"
				fi
			;;
			*)
				if [ "\${#Var_dec_search_string}" = "0" ]; then
					${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts} >> "\${Var_dec_parsing_output_file}"
				else
					${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts} | grep -E "\${Var_dec_search_string}" >> "\${Var_dec_parsing_output_file}"
				fi
			;;
		esac
	else
		case "\${Var_enc_padding_enable_yn}" in
			Y|y|Yes|yes|YES)
				if [ "\${#Var_dec_search_string}" = "0" ]; then
					Func_dec_remove_padding_from_output "\$(${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts})"
				else
					Func_dec_remove_padding_from_output "\$(${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts} | grep -E "\${Var_dec_search_string}")"
				fi
			;;
			*)
				if [ "\${#Var_dec_search_string}" = "0" ]; then
					${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts}
				else
					${Var_cat} <<<"\${_enc_input}" | ${Var_gpg} \${Var_dec_gpg_opts} | grep -E "\${Var_dec_search_string}"
				fi
			;;
		esac
	fi
	unset -v _enc_block[@]
	unset _enc_input
	exec 9>&-
}
Func_dec_spoon_feed_armored_packets(){
	_input=( "\${@}" )
	_beginning_of_line='-----BEGIN PGP MESSAGE-----'
	_end_of_line='-----END PGP MESSAGE-----'
	if [ -f "\${_input[@]}" ]; then
		mapfile -t _arr_input < "\${_input[@]}"
	else
		mapfile -t _arr_input <<<"\${_input[@]}"
	fi
	let _count=0
	until [ "\${_count}" = "\${#_arr_input[@]}" ]; do
		if [ "\${_end_of_line}" = "\${_arr_input[\${_count}]}" ]; then
			_arr_to_parse+=( "\${_arr_input[\${_count}]}" )
			let _count++
			Func_dec_do_stuff_with_lines "\${_arr_to_parse[@]}"
			unset -v _arr_to_parse[@]
		elif [ "\${_beginning_of_line}" = "\${_arr_input[\${_count}]}" ]; then
			_arr_to_parse=( "\${_arr_input[\${_count}]}" )
			let _count++
		else
			_arr_to_parse+=( "\${_arr_input[\${_count}]}" )
			let _count++
		fi

	done
	unset _count
	unset -v _input[@]
	unset -v _arr_input[@]
}
Func_dec_file_or_dir(){
	_encrypted_path="\${1}"
	Func_dec_pass_the_pass "\${Var_dec_pass}"
	case "\${_encrypted_path}" in
		*.tar.gpg)
			_old_pwd="\${PWD}"
			_output_dir="\${Var_dec_parsing_bulk_out_dir}/\${_encrypted_path##*/}"
			_output_dir="\${_output_dir%.tar.gpg*}"
			if ! [ -d "\${_output_dir}" ]; then
				mkdir -p "\${_output_dir}"
			fi
			cd "\${_output_dir}"
			${Var_cat} "\${_encrypted_path}" | ${Var_gpg} \${Var_dec_gpg_opts} | tar -xf -
			cd "\${_old_pwd}"
			unset _old_pwd
			unset _dir_list
		;;
		*.tgz.gpg)
			_old_pwd="\${PWD}"
			_output_dir="\${Var_dec_parsing_bulk_out_dir}/\${_encrypted_path##*/}"
			_output_dir="\${_output_dir%.tgz.gpg*}"
			if ! [ -d "\${_output_dir}" ]; then
				mkdir -p "\${_output_dir}"
			fi
			cd "\${_output_dir}"
			${Var_cat} "\${_encrypted_path}" | ${Var_gpg} \${Var_dec_gpg_opts} | tar -xzf -
			cd "\${_old_pwd}"
			unset _old_pwd
			unset _dir_list
		;;
		*.gpg)
			if ! [ -d "\${Var_dec_parsing_bulk_out_dir}" ]; then
				mkdir -p "\${Var_dec_parsing_bulk_out_dir}"
			fi
			_output_file="\${Var_dec_parsing_bulk_out_dir}/\${_encrypted_path##*/}"
			_output_file="\${_output_file%.gpg*}"
			${Var_cat} "\${_encrypted_path}" | ${Var_gpg} \${Var_dec_gpg_opts} > "\${_output_file}"
			unset _output_file
		;;
	esac
	exec 9>&-
	unset _encrypted_path
}
Func_dec_watch_bulk_dir(){
	_current_sig=""
	let _watch_count=0
	while [ -d "\${Var_enc_parsing_bulk_out_dir}" ]; do
		_new_sig="\$(find \${Var_enc_parsing_bulk_out_dir} -xtype f -print0 | xargs -0 sha1sum | awk '{print \$1}' | sort | sha1sum | awk '{print \$1}')"
		if [ "\${_current_sig}" != "\${_new_sig}" ]; then
			for _path in \$(find \${Var_enc_parsing_bulk_out_dir} -xtype f); do
				Func_dec_file_or_dir "\${Var_enc_parsing_bulk_out_dir}/\${_path}"
			done
		fi
		_current_sig="\${_new_sig}"
		let _watch_count++
		if [ "\${Var_dec_diff_count_max}" != "0" ] && [ "\${_diff_count}" -gt "\${Var_dec_diff_count_max}" ]; then
			unset _watch_count
			break
		fi
		sleep \${Var_dec_diff_sleep}
	done
}
Func_dec_watch_file(){
	_enc_parsing_output_file="\${1:-\${Var_enc_parsing_output_file}}"
	if [ -p "\${_enc_parsing_output_file}" ]; then
		while [ -p "\${_enc_parsing_output_file}" ]; do
			Func_dec_spoon_feed_armored_packets "\${_enc_parsing_output_file}"
		done
	elif [ -f "\${_enc_parsing_output_file}" ]; then
		Func_dec_spoon_feed_armored_packets "\${_enc_parsing_output_file}"
	else
		Func_dec_spoon_feed_armored_packets "\${_enc_parsing_output_file}"
	fi
}
Func_assign_arg(){
	_variable="\${1}"
	_value="\${2}"
	declare -g "\${_variable}=\${_value}"
	unset _variable
	unset _value
}
Func_check_args(){
	_arr_input=( "\${@}" )
	let _arr_count=0
	until [ "\${#_arr_input[@]}" = "\${_arr_count}" ]; do
		_arg="\${_arr_input[\${_arr_count}]}"
		case "\${_arg%=*}" in
			--dec-diff-opts|Var_dec_diff_opts)
				Func_assign_arg "Var_dec_diff_opts" "\${_arg#*=}"
			;;
			--dec-diff-count-max|Var_dec_diff_count_max)
				Func_assign_arg "Var_dec_diff_count_max" "\${_arg#*=}"
			;;
			--dec-diff-sleep|Var_dec_diff_sleep)
				Func_assign_arg "Var_dec_diff_sleep" "\${_arg#*=}"
			;;
			--dec-gpg-opts|Var_dec_gpg_opts)
				Func_assign_arg "Var_dec_gpg_opts" "\${_arg#*=}"
			;;
			--dec-parsing-save-output-yn|Var_dec_parsing_save_output_yn)
				Func_assign_arg "Var_dec_parsing_save_output_yn" "\${_arg#*=}"
			;;
			--dec-parsing-output-file|Var_dec_parsing_output_file)
				Func_assign_arg "Var_dec_parsing_output_file" "\${_arg#*=}"
			;;
			--dec-parsing-disown-yn|Var_dec_parsing_disown_yn)
				Func_assign_arg "Var_dec_parsing_disown_yn" "\${_arg#*=}"
			;;
			--dec-pass|Var_dec_pass)
				Func_assign_arg "Var_dec_pass" "\${_arg#*=}"
			;;
			--dec-search-string|Var_dec_search_string)
				Func_assign_arg "Var_dec_search_string" "\${_arg#*=}"
			;;
			--enc-padding-enable-yn|Var_enc_padding_enable_yn)
				Func_assign_arg "Var_enc_padding_enable_yn" "\${_arg#*=}"
			;;
			--enc-padding-length|Var_enc_padding_length)
				Func_assign_arg "Var_enc_padding_length" "\${_arg#*=}"
			;;
			--enc-padding-placement|Var_enc_padding_placement)
				Func_assign_arg "Var_enc_padding_placement" "\${_arg#*=}"
			;;
			--enc-parsing-output-file|Var_enc_parsing_output_file)
				Func_assign_arg "Var_enc_parsing_output_file" "\${_arg#*=}"
			;;
			--enc-parsing-bulk-out-dir|Var_enc_parsing_bulk_out_dir)
				Func_assign_arg "Var_enc_parsing_bulk_out_dir" "\${_arg#*=}"
			;;
			--dec-parsing-bulk-out-dir|Var_dec_parsing_bulk_out_dir)
				Func_assign_arg "Var_dec_parsing_bulk_out_dir" "\${_arg#*=}"
			;;
			--source-var-file|Var_source_var_file)
				Func_assign_arg "Var_source_var_file" "\${_arg#*=}"
				if [ -f "\${Var_source_var_file}" ]; then
					source "\${Var_source_var_file}"
				fi
			;;
			---*)
				_extra_var="\${_arg%=*}"
				_extra_arg="\${_arg#*=}"
				Func_assign_arg "\${_extra_var/---/}" "\${_extra_arg}"
			;;
			*)
				declare -ag "Arr_extra_input+=( \${_arg} )"
			;;
		esac
		let _arr_count++
	done
	unset _arr_count
}
Func_main(){
	_input=( "\$@" )
	if [ "\${#_input[@]}" != "0" ]; then
		Func_check_args "\${_input[@]}"
	fi
	case "\${Var_dec_parsing_save_output_yn}" in
		y|Y|yes|Yes)
			if ! [ -f "\${Var_dec_parsing_output_file}" ]; then
				touch "\${Var_dec_parsing_output_file}"
			fi
		;;
	esac
	case "\${Var_dec_parsing_disown_yn}" in
		Y|y|Yes|yes|YES)
			Func_dec_watch_file "\${Var_enc_parsing_output_file}" >"\${Var_dev_null}" 2>&1 &
			PID_Func_enc_pipe_parser_loop=\$!
			disown "\${PID_Func_enc_pipe_parser_loop}"
			Func_dec_watch_bulk_dir >"\${Var_dev_null}" 2>&1 &
			PID_Func_enc_pipe_parser_loop=\$!
			disown "\${PID_Func_enc_pipe_parser_loop}"
		;;
		*)
			Func_dec_watch_file "\${Var_enc_parsing_output_file}"
			Func_dec_watch_bulk_dir
		;;
	esac
}
Func_main "\${@}"
${Var_echo} "## \${Var_script_name} exited with \$? at \$(date)"

EOF

				Func_message "# Func_enc_write_script_copy running: ${Var_chown} \"${Var_enc_copy_save_ownership}\" \"${Var_dec_copy_save_path}\"" '2' '3'
				${Var_chown} "${Var_enc_copy_save_ownership}" "${Var_dec_copy_save_path}"
				Func_message "# Func_enc_write_script_copy running: ${Var_chmod} \"${Var_enc_copy_save_permissions}\" \"${Var_dec_copy_save_path}\"" '2' '3'
				${Var_chmod} "${Var_enc_copy_save_permissions}" "${Var_dec_copy_save_path}"
			fi
		;;
		*)
			Func_message "# Func_enc_write_script_copy skipping writing of: ${Var_dec_copy_save_path}" '2' '3'
		;;
	esac

}
## Call main function to get things started...
Func_message "# ${Var_script_name} running: Func_main \"\$@\"" '0' '1'
Func_main "$@"
Func_message "# ${Var_script_dir}/${Var_script_name} finished at: $(date)" '0' '1'
