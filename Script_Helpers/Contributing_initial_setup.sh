#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Customizable variables
Var_git_user="username"
Var_git_email="user@host.domain"
Var_git_dl_dir="${PWD}"
Var_git_merge_tool="vimdiff"
Var_git_conflictstyle="diff3"
Var_git_link="https://github.com/S0AndS0/Perinoid_Pipes"
## Auto set variables
Var_git_dir="${Var_git_dl_dir}/${Var_git_link##*/}"
Var_git_key_id="$(gpg --list-keys ${Var_git_email} | awk '/fingerprint/{print $10$11$12$13}')"
Func_help(){
	echo "# ${Var_script_name} knows the following command line options"
	echo "# --git-user		Var_git_user=${Var_git_user}"
	echo "# --git-email		Var_git_email=${Var_git_email}"
	echo "# --git-dl-dir		Var_git_dl_dir=${Var_git_dl_dir}"
	echo "# --git-link		Var_git_link=${Var_git_link}"
	echo "# --git-key-id		Var_git_key_id=${Var_git_key_id}"
	echo "# --git-merge-tool	Var_git_merge_tool=${Var_git_merge_tool}"
	echo "#	--git-conflictstyle	Var_git_conflictstyle=${Var_git_conflictstyle}"
}
Func_assign_arg(){
	_option="${1}"
	_variable="${2}"
	_value="${3}"
	echo "# ${Var_script_name} understood: ${_option}=${_value}"
	echo "# ${Var_script_name} declaring: ${_variable}=${_value}"
	declare -g "${_variable}=${_value}"
}
Func_check_args(){
	_arr_input=( "${@}" )
	let _arr_count=0
	until [ "${#_arr_input[@]}" = "${_arr_count}" ]; do
		_arg="${_arr_input[${_arr_count}]}"
		case "${_arg%=*}" in
			--git-user|Var_git_user)
				Func_assign_arg '--git-user' "Var_git_user" "${_arg#*=}"
			;;
			--git-merge-tool|Var_git_merge_tool)
				Func_assign_arg '--git-merge-tool' "Var_git_merge_tool" "${_arg#*=}"
			;;
			--git-merge-tool|Var_git_conflictstyle)
				Func_assign_arg '--git-conflictstyle-' "Var_git_conflictstyle" "${_arg#*=}"
			;;
			--git-email|Var_git_email)
				Func_assign_arg '--git-email' "Var_git_email" "${_arg#*=}"
				Func_assign_arg "--git-key-id" "Var_git_key_id" "$(gpg --list-keys ${_arg#*=} | awk '/fingerprint/{print $10$11$12$13}')"
			;;
			--git-key-id|Var_git_key_id)
				Func_assign_arg '--git-key-id' "Var_git_key_id" "${_arg#*=}"
			;;
			--git-dl-dir|Var_git_dl_dir)
				Func_assign_arg '--git-dl-dir' "Var_git_dl_dir" "${_arg#*=}"
				Func_assign_arg '--' "Var_git_dir" "${_arg#*=}"
			;;
			--git-link|Var_git_link)
				Func_assign_arg '--git-link' "Var_git_link" "${_arg#*=}"
				Func_assign_arg '--' "Var_git_dir" "${_arg#*=}"
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
Func_download_update(){
	_dl_dir="${1}"
	_link="${2}"
	_dir="${_dl_dir}/${_link##*/}"
	if ! [ -d "${_dir}" ]; then
		echo "# ${Var_script_name} cloning new repo to: ${_dl_dir}"
		cd "${_dl_dir}"
		git clone ${_link}
		cd "${_dir}"
	else
		echo "# ${Var_script_name} pulling updates from: ${_link}"
		cd "${_dir}"
		git pull
	fi
}
Func_git_check_config(){
	_option="${1}"
	_value="${2}"
	git config --get ${_option} | grep -qE "${_value}"
	if [ "$?" = "0" ]; then
		echo "# ${Var_script_name} detected option: ${_option}"
		echo "#  is already assigned value: ${_value}"
	else
		echo "# ${Var_script_name} setting git option: ${_option}"
		echo "# with value: ${_value}"
		git config --add ${_option} ${_value}
	fi
}
Func_git_config(){
	_dir="${1}"
	_git_user="${2}"
	_git_email="${3}"
	_git_key_id="${4}"
	_git_merge_tool="${5}"
	_git_conflictstyle="${6}"
	if [ -d "${_dir}" ]; then
		echo "# ${Var_script_name} setting-up git directory: ${_dir}"
		cd "${_dir}"
		Func_git_check_config "user.name" "${_git_user}"
		Func_git_check_config "user.email" "${_git_email}"
		Func_git_check_config "user.signingkey" "${_git_key_id}"
		Func_git_check_config "merge.tool" "${_git_merge_tool}"
		Func_git_check_config "merge.conflictstyle" "${_git_conflictstyle}"
		Func_git_check_config "remote.origin.fetch" '+refs/pull/*/head:refs/remotes/origin/pr/*'
		Func_git_check_config "remote.origin.fetch" '+refs/pull/*/merge:refs/remotes/origin/pr/*/merge'
	else
		echo "# ${Var_script_name} could not find directory: ${_dir}"
	fi
}
if [ "${#@}" -gt '2' ]; then
	Func_check_args "${@}"
	Func_download_update "${Var_git_dl_dir}" "${Var_git_link}"
	Func_git_config "${Var_git_dir}" "${Var_git_user}" "${Var_git_email}" "${Var_git_key_id}" "${Var_git_merge_tool}" "${Var_git_conflictstyle}"
else
	Func_help
	exit 0
fi
