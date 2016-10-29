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
