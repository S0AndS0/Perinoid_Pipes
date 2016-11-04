#!/usr/bin/env bash
Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
## Source shared variables and functions into this script.
source "${Var_script_dir}/lib/functions.sh"
Func_source_file "${Var_script_dir}/lib/variables.sh"
_test_string=$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_pass_length}")
_test_encryption_opts="--recipient ${Var_gnupg_email} --encrypt"
exec 3<${Var_pass_location}
_test_decryption_opts="--always-trust --passphrase-fd 3 --decrypt ${Var_test_gpg_location}"
#_test_decryption_opts="--always-trust --passphrase-fd 0 --decrypt ${Var_test_gpg_location}"
echo "# ${Var_script_name} started at: $(date -u +%s)"
## Try encrypting text to new key
cat <<<"${_test_string}" | gpg ${_test_encryption_opts} >> ${Var_test_gpg_location}
_exit_status=$?
Func_check_exit_status "${_exit_status}"
if [ -f "${Var_test_gpg_location}" ]; then
	gpg ${_test_decryption_opts} >> ${Var_test_raw_location}
#	cat  ${Var_pass_location} | gpg ${_test_decryption_opts} >> ${Var_test_raw_location}
	_exit_status=$?
	Func_check_exit_status "${_exit_status}"
else
	echo "# ${Var_script_name} cannot find: ${Var_test_gpg_location}"
fi
_test_string_decrypted=$(cat ${Var_test_raw_location})
if [[ "${_test_string}" == "${_test_string_decrypted}" ]]; then
	echo "# ${Var_script_name} reports all checks: OK"
	echo "# ${Var_script_name}: [${_test_string}] = [${_test_string_decrypted}]"
else
	echo "# ${Var_script_name} reports all checks: Not ok"
	echo "# ${Var_script_name} could not finde equivalance between: [${_test_string}] & [${_test_string_decrypted}]"
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
