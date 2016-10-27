#!/usr/bin/env bash
export Var_script_dir="${0%/*}"
export Var_script_name="${0##*/}"
Func_help(){
	echo "# ${Var_script_name} knows the following command line options"
	echo '# --subject="<Code Tests>"'
	echo '# --status="<Passing|Failing>"'
	echo '# --color="<red|blue>"'
	echo '# --link="<https://...>"'
	echo "#"
}
Func_assign_arg(){
	_filter="${1}"
	_variable="${2}"
	_value="${3}"
	case "${_filter}" in
		y|Y|yes|Yes|YES|filter)
			if [ -n "${_variable}" ] && [ -n "${_value}" ]; then
				## Double dash
				_value="${_value//-/--}"
				## Double underscores
				_value="${_value//_/__}"
				## Replace spaces
				_value="${_value// /_}"
#				echo "# declare -g \"${_variable}=${_value}\""
			else
				echo '# No input!'
			fi
		;;
	esac
	declare -g "${_variable}=${_value}"
}
Func_check_args(){
	_arr_input=( "${@}" )
	let _arr_count=0
	until [ "${#_arr_input[@]}" = "${_arr_count}" ]; do
		_arg="${_arr_input[${_arr_count}]}"
		case "${_arg%=*}" in
			--subject)
				Func_assign_arg 'filter' "Var_subject" "${_arg#*=}"
			;;
			--status)
				Func_assign_arg 'filter' "Var_status" "${_arg#*=}"
			;;
			--color)
				Func_assign_arg 'filter' "Var_color" "${_arg#*=}"
			;;
			--link)
				Func_assign_arg 'no' "Var_link" "${_arg#*=}"
			;;
			--help|help|*)
				echo "# ${Var_script_name} variable read: ${_arg%=*}"
				echo "# ${Var_script_name} value read: ${_arg#*=}"
				Func_help
			;;
		esac
		let _arr_count++
	done
}
Func_show_formated_output(){
	if [ -z "${Var_link}" ]; then
		echo "[![${Var_subject}](https://img.shields.io/badge/${Var_subject}-${Var_status}-${Var_color}.svg)]"
#		echo "https://img.shields.io/badge/${Var_subject}-${Var_status}-${Var_color}.svg"
	else
		echo "[![${Var_subject}](https://img.shields.io/badge/${Var_subject}-${Var_status}-${Var_color}.svg)](${Var_link})"
#		echo "https://img.shields.io/badge/${Var_subject}-${Var_status}-${Var_color}.svg?link=${Var_link}"
	fi
}
if [ "${#@}" -gt '2' ]; then
	Func_check_args "${@}"
	Func_show_formated_output
else
	Func_help
fi
