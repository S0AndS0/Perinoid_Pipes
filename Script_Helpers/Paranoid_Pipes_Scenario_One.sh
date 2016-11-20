#!/usr/bin/env bash
#Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## The following variable should be your encrypted file that has been appended
##  to via the main ecryption script abetrarary input parsing output file.
Var_input_file="/tmp/out.gpg"
## The following variable should be your named pipe for decrypting
Var_output_file="/tmp/out.log"
## The passphrase to unlock private GnuPG key, any Space Balls fans
##  wishing for 'A search for more money' out there?
Var_pass="123456... Luggage"
## Optional string to search for, uses grep to silence non-matching lines when
##  not outputing to a named pipe.
Var_search_output=""
## GnuPG decryption options. Note changing this to '--verify' may enable bulk
##  signature checking
Var_gpg_opts="--quiet --no-tty --always-trust --passphrase-fd 9 --decrypt"
## Optional workarounds based off 'gpg-zip' encryption/decryption. The following
##  two variables if set to directory paths will result in decrypting compressed
##  directories or read file paths from the main script... well that is once
##  fully tested by Travic-CI, otherwise see auto-build scripts for steps in
##  recovering bulk encryption paths instead of appended logs.
Var_bulk_input_dir=""
Var_bulk_output_dir=""
### Dangerious / Special usage case variables
Var_padding_yn='no'
Var_padding_length='adaptive'
Var_padding_placement='above'
#Var_padding_placement='above,bellow,append,prepend'
## Internal script variables that can also be set by users
Var_debug_level="0"
Var_log_level="0"
Var_script_log_path="${PWD}/${Var_script_name%.sh*}.log"
Var_columns="${COLUMNS:-80}"
## The following function is used internally for silencing or verbosly logging
##  or printing scripted actions to terminal. Under normal operations this function
##  should silently absorb messages.
Func_message(){
	_message="${1}"
	_debug_level="${2:-${Var_debug_level}}"
	_log_level="${3:-${Var_log_level}}"
	## Check that there is a message to process and if it should be shown
	##  to user.
	if [ "${#_message}" != "0" ]; then
		if [ "${_debug_level}" = "${Var_debug_level}" ] || [ "${Var_debug_level}" -gt "${_debug_level}" ]; then
			_folded_message="$(fold -sw $((${Var_columns}-6)) <<<"${_message}" | sed -e "s/^.*$/$(echo -n "#DBL-${_debug_level}") &/g")"
			cat <<<"${_folded_message}"
		fi
	fi
	## Do much the same for logging as was done above for output to terminal
	if [ "${#_message}" != "0" ]; then
		if [ "${_log_level}" -gt "${Var_log_level}" ]; then
			cat <<<"${_message}" >> "${Var_script_log_path}"
		fi
	fi
}
Func_help(){
	echo "# ${Var_script_name} knows the following command line options"
	echo "#  --input-file 		Var_input_file=${Var_input_file}"
	echo "#  --output-file		Var_output_file=${Var_output_file}"
	echo "#  --pass			Var_pass=${Var_pass}"
	echo "#  --search-output	Var_search_output=${Var_search_output}"
	echo "#  --gpg-opts		Var_gpg_opts=${Var_gpg_opts}"
	echo "## ${Var_script_name} is designed to decrypt 'arrmor' encrypted files"
	echo "#  that contain more than one arrmored message in an automated fashion."
	echo "## Note: '--search-output' will not be active if outputing to named pipe."
	echo "## Special use case options"
	echo "# --padding-yn		Var_padding_yn=${Var_padding_yn}"
	echo "# --padding-length	Var_padding_length=${Var_padding_length}"
	echo "# --padding-placement	Var_padding_placement=${Var_padding_placement}"
	echo "## The above options are intended to aid users in removing"
	echo "#  automaticly added lines via another scripts padding add"
	echo "#  option. By default this option is disabled and users must"
	echo "#  spicifficly enable padding if desired because of risk of"
	echo "#  coruption to data when used. Warning, the three above are not completly finished!"
	echo "## New/experomental options"
	echo "# --bulk-input-dir	Var_bulk_input_dir=${Var_bulk_input_dir}"
	echo "# --bulk-output-dir	Var_bulk_output_dir=${Var_bulk_output_dir}"
	echo "## The above two are required if bulk files or directories where"
	echo "#  processed by main script."
	echo "## The bellow three options are optional for making this script"
	echo "#  log more or be more verbose during opterations"
	echo "# --debug-level		Var_debug_level=${Var_debug_level}"
	echo "# --log-level		Var_log_level=${Var_log_level}"
	echo "# --script-log-level	Var_script_log_path=${Var_script_log_path}"
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
			--bulk-input-dir|Var_bulk_input_dir)
				Func_assign_arg "Var_bulk_input_dir" "${_arg#*=}"
			;;
			--bulk-output-dir|Var_bulk_output_dir)
				Func_assign_arg "Var_bulk_output_dir" "${_arg#*=}"
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
			--padding-yn|Var_padding_yn)
				Func_assign_arg "Var_padding_yn" "${_arg#*=}"
			;;
			--padding-length|Var_padding_length)
				Func_assign_arg "Var_padding_length" "${_arg#*=}"
			;;
			--padding-placement|Var_padding_placement)
				Func_assign_arg "Var_padding_placement" "${_arg#*=}"
			;;
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
			--help|help|*)
				echo "# ${Var_script_name} variable read: ${_arg%=*}"
				echo "# ${Var_script_name} value read: ${_arg#*=}"
				Func_help
			;;
		esac
		let _arr_count++
	done
}
## The following function is called within 'Do_stuff_with_lines' to set the
##  passphrase to a file descriptor prior to attempting to process encrypted
##  blocks.
Pass_the_passphrase(){
	_pass=( "$@" )
	if [ -f "${_pass[@]}" ]; then
		exec 9<"${_pass[@]}"
	else
		exec 9<(echo "${_pass[@]}")
	fi
}
## The following mess of checks within this fucntion are only enabled if users
##  select to do so, else this function is not used.
Remove_padding_from_output(){
	_input=( "$@" )
	let _count=0
	let _padding_count=0
	until [ "${_count}" = "${#_input[@]}" ]; do
#		_line=( "${_input[${_count}]}" )
		## Do some funky checks to see if trimming the tail or head of
		##  read strings. looks way worce than it really is and once use
		##  to it, then next checks will make more sence...
		if grep -qE "append|prepend" <<<"${Var_padding_placement//,/ }"; then
			if grep -qE "append"  <<<"${Var_padding_placement//,/ }" && grep -qE "prepend"  <<<"${Var_padding_placement//,/ }"; then
				case "${Var_padding_length}" in
					adaptive)
						_padding_length="$((${#_input[${_count}]}/3))"
					;;
					*)
						_padding_length="${Var_padding_length}"
					;;
				esac
				_line[${_count}]=( "${_input[${_count}]::-${_padding_length}}" )
				## Trim first third of line bellow, trim last
				##  third above
				_line[${_count}]=( "${_input[${_count}]:${_padding_length}}" )
			elif grep -qE "append"  <<<"${Var_padding_placement//,/ }"; then
				case "${Var_padding_length}" in
					adaptive)
						_padding_length="$((${#_input[${_count}]}/2))"
					;;
					*)
						_padding_length="${Var_padding_length}"
					;;
				esac
				## Trim last half or padding lengths value from
				##  line
				_line[${_count}]=( "${_input[${_count}]::-${_padding_length}}" )
			else
				case "${Var_padding_length}" in
					adaptive)
						_padding_length="$((${#_input[${_count}]}/2))"
					;;
					*)
						_padding_length="${Var_padding_length}"
					;;
				esac
				## Trim padding value from beguining of line
				##  or first half
				_line[${_count}]=( "${_input[${_count}]:${_padding_length}}" )
			fi
		fi
		## TO-DO : finish below for now echo out line
		echo "${_line[@]}"
		## Do the same kind of funkyness to drop lines above or bellow
		##  desired line of data.
#		if grep -qE "above|bellow" <<<"${Var_padding_placement//,/ }"; then
#			if grep -qE "above" <<<"${Var_padding_placement//,/ }" && grep -qE "bellow" <<<"${Var_padding_placement//,/ }"; then
#				_line[${_count}]=( "" )
#				
#			elif grep -qE "above" <<<"${Var_padding_placement//,/ }"; then
#				_line[${_count}]=( "" )
#				
#			else
#				_line[${_count}]=( "" )
#				
#			fi
#		elif grep -qE "above" <<<"${Var_padding_placement//,/ }"; then
#			
#		else
#			
#		fi
	done
	let _padding_count++
	let _count++
}
## The following function is called within 'Do_stuff_with_lines'
##  function as variable '_enc_input' to re-introduce new lines
##  that 'mapfile' trimed durring processing.
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
## The following function is called within 'Func_spoon_feed_pipe_decryption'
##  functions until loop and preforms the encrypted block redirection to
##  a decrypted file or if a named pipe is designated then it is written
##  to that instead.
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
		Func_message "# ${Var_script_name} running: cat <<<\"\${_enc_input}\" > \"${Var_output_file}\"" '1' '2'
		cat <<<"${_enc_input}" > "${Var_output_file}"
	## The case checks used below are checking if user wishes to remove
	## padding data that was added by the bulk decryption script. By
	## default these options are disabled for both scripts so users
	## normally will never have to deal with the 'yes' like checks.
	elif [ -f "${Var_output_file}" ]; then
		case "${Var_padding_yn}" in
			Y|y|Yes|yes|YES)
				## Check if we are searching for something before outputing
				if [ "${#Var_search_output}" = "0" ]; then
					Func_message "# ${Var_script_name} running: Remove_padding_from_output \"\$(cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts})\" >> \"${Var_output_file}\"" '1' '2'
					Remove_padding_from_output "$(cat <<<"${_enc_input}" | gpg ${Var_gpg_opts})" >> "${Var_output_file}"
				else
					Func_message "# ${Var_script_name} running: Remove_padding_from_output \"\$(cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts} | grep -E \"${Var_search_output}\")\" >> \"${Var_output_file}\"" '1' '2'
					Remove_padding_from_output "$(cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} | grep -E "${Var_search_output}")" >> "${Var_output_file}"
				fi
			;;
			*)
				## Check if we are searching for something before outputing
				if [ "${#Var_search_output}" = "0" ]; then
					Func_message "# ${Var_script_name} running: cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts} >> \"${Var_output_file}\"" '1' '2'
					cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} >> "${Var_output_file}"
				else
					Func_message "# ${Var_script_name} running: cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts} | grep -E \"${Var_search_output}\" >> \"${Var_output_file}\"" '1' '2'
					cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} | grep -E "${Var_search_output}" >> "${Var_output_file}"
				fi
			;;
		esac
	else
		case "${Var_padding_yn}" in
			Y|y|Yes|yes|YES)
				## Check if we are searching for something before outputing
				if [ "${#Var_search_output}" = "0" ]; then
					Func_message "# ${Var_script_name} running: Remove_padding_from_output \"\$(cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts})\"" '1' '2'
					Remove_padding_from_output "$(cat <<<"${_enc_input}" | gpg ${Var_gpg_opts})"
				else
					Func_message "# ${Var_script_name} running: Remove_padding_from_output \"\$(cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts} | grep -E \"${Var_search_output}\")\"" '1' '2'
					Remove_padding_from_output "$(cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} | grep -E "${Var_search_output}")"
				fi
			;;
			*)
				## Check if we are searching for something before outputing
				if [ "${#Var_search_output}" = "0" ]; then
					Func_message "# ${Var_script_name} running: cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts}" '1' '2'
					cat <<<"${_enc_input}" | gpg ${Var_gpg_opts}
				else
					Func_message "# ${Var_script_name} running: cat <<<\"\${_enc_input}\" | gpg ${Var_gpg_opts} | grep -E \"${Var_search_output}\"" '1' '2'
					cat <<<"${_enc_input}" | gpg ${Var_gpg_opts} | grep -E "${Var_search_output}"
				fi
			;;
		esac
	fi
	unset -v _enc_block[@]
	unset _enc_input
	## Close file descriptor containing passphrase just to be safer while
	##  preforming less then secure operations.
	exec 9>&-
}
Func_spoon_feed_pipe_decryption(){
	_input=( "${@}" )
	## Note we use the begin to start the internal array
	_beginning_of_line='-----BEGIN PGP MESSAGE-----'
	## Then we use the end to finish the array and pass control to
	##  decryption functions before returning to parant loop for more.
	_end_of_line='-----END PGP MESSAGE-----'
	## If input is a file then use standard redirection to mapfile command.
	##  Else use variable as file redirection trick to get mapfile to build an array from input.
	if [ -f "${_input[@]}" ]; then
		mapfile -t _arr_input < "${_input[@]}"
	else
		mapfile -t _arr_input <<<"${_input[@]}"
	fi
	## Initialize internal count that added to in the following loop for
	##  array indexing.
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
			Func_message "# ${Var_script_name} running: Do_stuff_with_lines \"\${_arr_to_parse[@]}\"" '1' '2'
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
## New two functions are to handle bulk file/directory encryption, note
##  the following will be fragile until finished.
## The following function is "fead" by 'Func_do_stuff_with_bulk_dirs' function
##  which should be called by the 'Main_func' function
Func_decrypt_file_or_dir(){
#Func_message "# ${Var_script_name} running: " '1' '2'
	_encrypted_path="${1}"
	Pass_the_passphrase "${Var_pass}"
	case "${_encrypted_path}" in
		*.tar.gpg)
			_old_pwd="${PWD}"
			## Make a directory path under bulk output dir based on
			##  inputed compressed path name; Bash short-hand tricks
			_output_dir="${Var_bulk_output_dir}/${_encrypted_path##*/}"
			_output_dir="${_output_dir%.tar.gpg*}"
			## If bulk output directory for compressed & encrypted
			## directories do not exsist, then mkdir it
			if ! [ -d "${_output_dir}" ]; then
				Func_message "# ${Var_script_name} running: mkdir -p \"${_output_dir}\"" '1' '2'
				mkdir -p "${_output_dir}"
			fi
			Func_message "# ${Var_script_name} running: cd \"${_output_dir}\"" '1' '2'
			cd "${_output_dir}"
			## Note the trailing dash ('-') with 'tar'
			Func_message "# ${Var_script_name} running: cat \"${_encrypted_path}\" | gpg ${Var_gpg_opts} | tar ${_tar_opts} -" '1' '2'
			cat "${_encrypted_path}" | gpg ${Var_gpg_opts} | tar -xfv -
			Func_message "# ${Var_script_name} running: cd \"${_old_pwd}\"" '1' '2'
			cd "${_old_pwd}"
			unset _old_pwd
		;;
		## TO-DO - write other double sufix reconitions above for dirs
		*gpg)
			## If bulk output directory does not exsist, then mkdir
			if ! [ -d "${Var_bulk_output_dir}" ]; then
				Func_message "# ${Var_script_name} running: mkdir -p \"${Var_bulk_output_dir}\"" '1' '2'
				mkdir -p "${Var_bulk_output_dir}"
			fi
			_output_file="${Var_bulk_output_dir}/${_encrypted_path##*/}"
			_output_file="${_output_file%.gpg*}"
			Func_message "# ${Var_script_name} running: cat \"${_encrypted_path}\" | gpg ${Var_gpg_opts} > \"${_output_file}\"" '1' '2'
			cat "${_encrypted_path}" | gpg ${Var_gpg_opts} > "${_output_file}"
			unset _output_file
		;;
	esac
	## Close file descriptor containing passphrase just to be safer while
	##  preforming less then secure operations. Note this process should be
	##  repeated for other operations involving passphrases.
	exec 9>&-
	unset _encrypted_path
}
## The following function feeds the 'Func_decrypt_file_or_dir' function and is
##  called by the 'Main_func' function, however, is only activated by using two
##  optional command line options for this helper script.
Func_do_stuff_with_bulk_dirs(){
	## If both input and output bulk directory variables are set, then
	##  assume that further checks and decryption steps should be run.
	if [ "${#Var_bulk_input_dir}" != "0" ] && [ "${#Var_bulk_output_dir}" != "0" ]; then
		## If bulk input directory exsists, then push 'ls' through loop
		##  for checking what type of decryption steps should be used.
		if [ -d "${Var_bulk_input_dir}" ]; then
			Func_message "# ${Var_script_name} parsing: ${Var_bulk_input_dir}" '1' '2'
			_list_of_gpg_files="$(ls "${Var_bulk_input_dir}")"
			for _posible_file in ${_list_of_gpg_files}; do
				## If posible file is a file, then parse for
				##  type of decryption steps that are regonized.
				if [ -f "${Var_bulk_input_dir}/${_posible_file}" ]; then
					Func_message "# ${Var_script_name} running: Func_decrypt_file_or_dir \"${Var_bulk_input_dir}/${_posible_file}\"" '1' '2'
					Func_decrypt_file_or_dir "${Var_bulk_input_dir}/${_posible_file}"
				else
					Func_message "# ${Var_script_name} skipping: Func_decrypt_file_or_dir \"${Var_bulk_input_dir}/${_posible_file}\"" '1' '2'
				fi
			done
		fi
	else
		Func_message "# ${Var_script_name} skipping: Func_do_stuff_with_bulk_dirs function" '1' '2'
	fi
}
Main_func(){
	_input=( "$@" )
	if [ "${#_input[@]}" = '0' ]; then
		Func_message "# ${Var_script_name} running: Func_check_args \"--help\"" '1' '2'
		Func_check_args "--help"
	else
		Func_message "# ${Var_script_name} running: Func_check_args \"${_input[*]}\"" '1' '2'
		Func_check_args "${_input[@]}"
	fi
	## Start cascade of function redirection
	Func_message "# ${Var_script_name} running: Func_spoon_feed_pipe_decryption \"${Var_input_file}\"" '1' '2'
	Func_spoon_feed_pipe_decryption "${Var_input_file}"
	## Check with following function before unseting any internal variables
	Func_message "# ${Var_script_name} running: Func_do_stuff_with_bulk_dirs" '1' '2'
	Func_do_stuff_with_bulk_dirs
	Func_message "# ${Var_script_name} running: Unset on variables prior to finishing." '1' '2'
	unset Var_input_file
	unset Var_output_file
	unset Var_pass
	unset Var_search_output
	unset Var_gpg_opts
}
Main_func "${@}"
Func_message "# ${Var_script_name} finished at: $(date -u)" '1' '2'
