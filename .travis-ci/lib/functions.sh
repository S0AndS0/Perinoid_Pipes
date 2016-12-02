Func_source_file(){
	_file="${1}"
	if [ -f "${_file}" ]; then
		echo "# Running: source ${_file}"
		source "${_file}"
	else
		echo "# Could **not** Source: ${_file}"
		exit 1
	fi
}
Func_run_sanely(){
	_run_string="${1}"
	_permissions="${2:-0}"
	_uid="${UID}"
	case "${_permissions}" in
		0)
			if [ "${_uid}" = "0" ]; then
				echo "# ${Var_script_name} running as root: ${_run_string}"
				${_run_string}
			else
				echo "# ${Var_script_name} running as ${USER}: sudo ${_run_string}"
				sudo ${_run_string}
			fi
		;;
		*)
			echo "# ${Var_script_name} running as ${USER}: ${_run_string}"
			${_run_string}
		;;
	esac
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
}
Func_check_exit_status(){
	_status="$1"
	if [ "${_status}" != '0' ]; then
		echo "# ${Var_script_name} error: ${_status}"
		echo "# Failed running: ${_run_string}"
		exit "${_status}"
	fi
}
#Func_write_and_log_lines_to_pipe "<LOG>" "<PIPE>" "<LENGTH>"
Func_write_and_log_lines_to_pipe(){
	_log_file="${1}"
	_pipe_file="${2}"
	_line_length="${3:-32}"
	if ! [ -f "${_log_file}" ]; then
		touch "${_log_file}"
		chmod "${_log_file}"
	fi
	if [ -p "${_pipe_file}" ]; then
		_test_string="$(cat /dev/urandom | tr -cd '[:print:]' | head -c"${_line_length}")"
#		_test_string="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${_line_length}")"
		echo "${_test_string}" >> "${_log_file}"
		_current_string="$(tail -n1 ${_log_file})"
		echo "${_current_string}" > "${_pipe_file}"
	fi
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
}
