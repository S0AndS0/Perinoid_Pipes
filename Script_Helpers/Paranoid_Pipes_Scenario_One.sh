#!/usr/bin/env bash
#Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## The following variable should be your encrypted file that has been appended to.
Var_input_file="/tmp/out.gpg"
## The following variable should be your named pipe for decrypting
Var_output_file="/tmp/out.log"
Var_pass="123456... Luggage"
## You may assign the above at run-time using the following example call to
##  this script: script_name.sh "/path/to/input" "/path/to/output"
Var_search_output=""
Var_gpg_opts="--always-trust --passphrase-fd 9 --decrypt"
Func_help(){
	echo "# ${Var_script_name} knows the following command line options"
	echo "#  --input-file 		Var_input_file=${Var_input_file}"
	echo "#  --output-file		Var_output_file=${Var_output_file}"
	echo "#  --pass			Var_pass=${Var_pass}"
	echo "#  --search-output	Var_search_output=${Var_search_output}"
	echo "#  --gpg-opts		Var_gpg_opts=${Var_gpg_opts}"
}
Func_assign_arg(){
	_variable="${1}"
	_value="${2}"
	declare -g "${_variable}=${_value}"
}
Func_check_args(){
	_arr_input=( "${@}" )
	let _arr_count=0
	until [ "${#_arr_input[@]}" = "${_arr_count}" ]; do
		_arg="${_arr_input[${_arr_count}]}"
		case "${_arg%=*}" in
			--input-file|Var_input_file)
				Func_assign_arg "Var_input_file" "${_arg#*=}"
			;;
			--output-file|Var_output_file)
				Func_assign_arg "Var_output_file" "${_arg#*=}"
			;;
			--pass|Var_pass)
				Func_assign_arg "Var_pass" "${_arg#*=}"
			;;
			--search-output|Var_search_output)
				Func_assign_arg "Var_search_output" "${_arg#*=}"
			;;
			--gpg-opts|Var_gpg_opts)
				Func_assign_arg "Var_gpg_opts" "${_arg#*=}"
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
Func_spoon_feed_pipe_decryption(){
	_input=( "${@}" )
	_end_of_line='-----END PGP MESSAGE-----'
	_beginning_of_line='-----BEGIN PGP MESSAGE-----'
	## If input is a file then use standard redirection to mapfile command.
	##  Else use variable as file redirection trick to get mapfile to build an array from input.
	if [ -f "${_input[@]}" ]; then
		mapfile -t _arr_input < "${_input[@]}"
	else
		mapfile -t _arr_input <<<"${_input[@]}"
	fi
	## Initialize internal count that is either reset or added to in the following loop.
	let _count=0
	until [ "${_count}" = "${#_arr_input[@]}" ]; do
		## If currently indexed line matches end of line string, then
		##  append to array and push all values through parsing function
		##  chain. If else currently indexed line matches beginning of
		##  line variable, then re-make array with current line indexed
		##  to '0' and in each case add one to internal count. If else
		##  currently indexed line does not match either, then append
		##  current line to array and add one to index.
		if [ "${_end_of_line}" = "${_arr_input[${_count}]}" ]; then
			_arr_to_parse+=( "${_arr_input[${_count}]}" )
			let _count++
			Do_stuff_with_lines "${_arr_to_parse[@]}"
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
Expand_array_to_block(){
	_input=( "$@" )
	let _count=0
	until [ "${_count}" = "${#_input[@]}" ]; do
		echo "${_input[${_count}]}"
		let _count++
	done
	unset _count
	unset -v _input[@]
}
Do_stuff_with_lines(){
	_enc_block=( "$@" )
	_enc_input=$(Expand_array_to_block "${_enc_block[@]}" )
	## If using a named pipe to preform decryption then push encrypted array
	##  through named pipe's input for use, if output is a file then use
	##  above decrypting command and append to the file. Else output
	##  decryption to terminal.
	## Push passphrase into a file descriptor
	Pass_the_passphrase "${Var_pass}"
	if [ -p "${Var_output_file}" ]; then
		## TO-DO -- Remove following output line after remote tests
		echo "## Sending the following data..."
		echo "${_enc_input}"
		echo "## ... to named pipe: ${Var_output_file}"
		cat <<<"${_enc_input}" > "${Var_output_file}"
	elif [ -f "${Var_output_file}" ]; then
		if [ "${#Var_search_output}" = "0" ]; then
			cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} >> "${Var_output_file}"
		else
			cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} | grep -E "${Var_search_output}" >> "${Var_output_file}"
		fi
	else
		if [ "${#Var_search_output}" = "0" ]; then
			cat <<<"${_enc_input}" | gpg ${Var_gpg_opts}
		else
			cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} | grep -E "${Var_search_output}"
		fi
	fi
	unset -v _enc_block[@]
	unset _enc_input
	## Close file descriptor containing passphrase
	##  just to be safer while preforming less then
	##  secure operations.
	exec 9>&-
}
Pass_the_passphrase(){
	_pass="$@"
	if [ -f "${_pass}" ]; then
		exec 9<"${_pass}"
	else
		exec 9<(echo "${_pass}")
	fi
}
Main_func(){
	Func_check_args "${@:---help}"
	## Start cascade of function redirection
	Func_spoon_feed_pipe_decryption "${Var_input_file}"
}
Main_func
