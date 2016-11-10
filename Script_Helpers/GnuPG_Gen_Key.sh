#!/usr/bin/env bash
#Var_script_dir="${0%/*}"
Var_script_name="${0##*/}"
Var_current_working_dir="${PWD}"
Var_save_pass_yn="no"
Var_save_pass_location="${Var_current_working_dir}/GnuPG_${USER}.pass"
## How many characters for passphrase as well as length of test strings?
Var_auto_pass_length='64'
Var_auto_pass_phrase="$(base64 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c"${Var_auto_pass_length}")"
Var_prompt_for_pass_yn="yes"
Var_gnupg_revoke_cert_yn="yes"
Var_gnupg_conf_save_yn="no"
Var_gnupg_conf_location="${HOME}/.gnupg/gpg.conf"
Var_gnupg_comment="Test_${USER}_Keys"
Var_gnupg_email="${USER}@${HOSTNAME}"
Var_gnupg_expire_date="0"
Var_gnupg_key_type="RSA"
Var_gnupg_key_length="4096"
Var_gnupg_key_server="hkp://keys.gnupg.net"
Var_gnupg_name="${USER}"
Var_gnupg_sub_key_type="RSA"
Var_gnupg_sub_key_length="4096"
Var_gnupg_revoke_location="${Var_current_working_dir}/GnuPG_${USER}_revoke.asc"
Var_gnupg_export_public_key_yn="yes"
Var_gnupg_export_public_key_location="${Var_current_working_dir}/GnuPG_${USER}_public.gpg"
Var_gnupg_export_private_key_yn="no"
Var_gnupg_export_private_key_location="${Var_current_working_dir}/GnuPG_${USER}_private.asc"
Var_gnupg_revoke_reason="Auto-generated revoke cert at $(date -u +%s)"
Var_gnupg_upload_key_yn="no"
Arr_options=( "$@" )
echo "# ${Var_script_name} started at: $(date -u +%s)"
Func_help(){
	echo "## ${Var_script_name} knows the following command line options"
	echo "# --save-pass-yn		Var_save_pass_yn=${Var_save_pass_yn}"
	echo "# --save-pass-location	Var_save_pass_location=${Var_save_pass_location}"
	echo "# --auto-pass-length	Var_auto_pass_length=${Var_auto_pass_length}"
	echo "## Example of auto pass: ${Var_auto_pass_phrase}"
	echo "# --gnupg-revoke-cert-yn	Var_gnupg_revoke_cert_yn=${Var_gnupg_revoke_cert_yn}"
	echo "# --gnupg-conf-save-yn	Var_gnupg_conf_save_yn=${Var_gnupg_conf_save_yn}"
	echo "# --gnupg-conf-location	Var_gnupg_conf_location=${Var_gnupg_conf_location}"
	echo "# --gnupg-revoke-location	Var_gnupg_revoke_location=${Var_gnupg_revoke_location}"
	echo "# --gnupg-revoke-reason	Var_gnupg_revoke_reason=${Var_gnupg_revoke_reason}"
	echo "# --gnupg-upload-key-yn	Var_gnupg_upload_key_yn=${Var_gnupg_upload_key_yn}"
	echo "# --gnupg-comment		Var_gnupg_comment=${Var_gnupg_comment}"
	echo "# --gnupg-email		Var_gnupg_email=${Var_gnupg_email}"
	echo "# --gnupg-expire-date	Var_gnupg_expire_date=${Var_gnupg_expire_date}"
	echo "# --gnupg-export-public-key-yn		Var_gnupg_export_public_key_yn=${Var_gnupg_export_public_key_yn}"
	echo "# --gnupg-export-public-key-location	Var_gnupg_export_public_key_location=${Var_gnupg_export_public_key_location}"
	echo "# --gnupg-export-private-key-yn		Var_gnupg_export_private_key_yn=${Var_gnupg_export_private_key_yn}"
	echo "# --gnupg-export-private-key-location	Var_gnupg_export_private_key_location=${Var_gnupg_export_private_key_location}"
	echo "# --gnupg-key-type	Var_gnupg_key_type=${Var_gnupg_key_type}"
	echo "# --gnupg-key-length	Var_gnupg_key_length=${Var_gnupg_key_length}"
	echo "# --gnupg-key-server	Var_gnupg_key_server=${Var_gnupg_key_server}"
	echo "# --gnupt-sub-key-type	Var_gnupg_sub_key_type=${Var_gnupg_sub_key_type}"
	echo "# --gnupg-sub-key-length	Var_gnupg_sub_key_length=${Var_gnupg_sub_key_length}"
	echo "# --gnupg-name		Var_gnupg_name=${Var_gnupg_name}"
	echo "# --prompt-for-pass-yn	Var_prompt_for_pass_yn=${Var_prompt_for_pass_yn}"
	exit 0
}
Func_assign_arg(){
	_option="${1}"
	_variable="${2}"
	_value="${3}"
	echo "# ${Var_script_name} read option: ${_option}"
	echo "# ${Var_script_name} assigning: ${_variable}=${_value}"
	declare -g "${_variable}=${_value}"
}
Func_check_args(){
	_arr_input=( "${@}" )
	let _arr_count=0
	until [ "${#_arr_input[@]}" = "${_arr_count}" ]; do
		_arg="${_arr_input[${_arr_count}]}"
		case "${_arg%=*}" in
			--save-pass-yn|Var_save_pass_yn)
				Func_assign_arg '--save-pass-yn' "Var_save_pass_yn" "${_arg#*=}"
			;;
			--save-pass-location|Var_save_pass_location)
				Func_assign_arg '--save-pass-location' "Var_save_pass_location" "${_arg#*=}"
			;;
			--auto-pass-length|Var_auto_pass_length)
				Func_assign_arg '--auto-pass-length' "Var_auto_pass_length" "${_arg#*=}"
			;;
			--gnupg-revoke-cert-yn|Var_gnupg_revoke_cert_yn)
				Func_assign_arg '--gnupg-revoke-cert-yn' "Var_gnupg_revoke_cert_yn" "${_arg#*=}"
			;;
			--gnupg-conf-save-yn|Var_gnupg_conf_save_yn)
				Func_assign_arg '--gnupg-conf-save-yn' "Var_gnupg_conf_save_yn" "${_arg#*=}"
			;;
			--gnupg-conf-location|Var_gnupg_conf_location)
				Func_assign_arg '--gnupg-conf-location' "Var_gnupg_conf_location" "${_arg#*=}"
			;;
			--gnupg-revoke-location|Var_gnupg_revoke_location)
				Func_assign_arg '--gnupg-revoke-location' "Var_gnupg_revoke_location" "${_arg#*=}"
			;;
			--gnupg-revoke-reason|Var_gnupg_revoke_reason)
				Func_assign_arg '--gnupg-revoke-reason' "Var_gnupg_revoke_reason" "${_arg#*=}"
			;;
			--gnupg-upload-key-yn|Var_gnupg_upload_key_yn)
				Func_assign_arg '--gnupg-upload-key-yn' "Var_gnupg_upload_key_yn" "${_arg#*=}"
			;;
			--gnupg-comment|Var_gnupg_comment)
				Func_assign_arg '--gnupg-comment' "Var_gnupg_comment" "${_arg#*=}"
			;;
			--gnupg-email|Var_gnupg_email)
				Func_assign_arg '--gnupg-email' "Var_gnupg_email" "${_arg#*=}"
			;;
			--gnupg-expire-date|Var_gnupg_expire_date)
				Func_assign_arg '--gnupg-expire-date' "Var_gnupg_expire_date" "${_arg#*=}"
			;;
			--gnupg-export-public-key-yn|Var_gnupg_export_public_key_yn)
				Func_assign_arg '--gnupg-export-public-key-yn' "Var_gnupg_export_public_key_yn" "${_arg#*=}"
			;;
			--gnupg-export-public-key-location|Var_gnupg_export_public_key_location)
				Func_assign_arg '--gnupg-export-public-key-location' "Var_gnupg_export_public_key_location" "${_arg#*=}"
			;;
			--gnupg-export-private-key-yn|Var_gnupg_export_private_key_yn)
				Func_assign_arg '--gnupg-export-private-key-yn' "Var_gnupg_export_private_key_yn" "${_arg#*=}"
			;;
			--gnupg-export-private-key-location|Var_gnupg_export_private_key_location)
				Func_assign_arg '--gnupg-export-private-key-location' "Var_gnupg_export_private_key_location" "${_arg#*=}"
			;;
			--gnupg-key-type|Var_gnupg_key_type)
				Func_assign_arg '--gnupg-key-type' "Var_gnupg_key_type" "${_arg#*=}"
			;;
			--gnupg-key-length|Var_gnupg_key_length)
				Func_assign_arg '--gnupg-key-length' "Var_gnupg_key_length" "${_arg#*=}"
			;;
			--gnupg-key-server|Var_gnupg_key_server)
				Func_assign_arg '--gnupg-key-server' "Var_gnupg_key_server" "${_arg#*=}"
			;;
			--gnupg-sub-key-type|Var_gnupg_sub_key_type)
				Func_assign_arg '--gnupg-sub-key-type' "Var_gnupg_sub_key_type" "${_arg#*=}"
			;;
			--gnupg-sub-key-length|Var_gnupg_sub_key_length)
				Func_assign_arg '--gnupg-sub-key-length' "Var_gnupg_sub_key_length" "${_arg#*=}"
			;;
			--gnupg-name|Var_gnupg_name)
				Func_assign_arg '--gnupg-name' "Var_gnupg_name" "${_arg#*=}"
			;;
			--prompt-for-pass-yn|Var_prompt_for_pass_yn)
				Func_assign_arg '--prompt-for-pass-yn' "Var_prompt_for_pass_yn" "${_arg#*=}"
			;;
			--help|help|*)
				Func_help
			;;
		esac
		let _arr_count++
	done
}
Func_gen_gnupg_keys(){
	_pass_phrase=( "$@" )
	gpg --batch --gen-key <<EOF
Key-Type: ${Var_gnupg_key_type}
Key-Length: ${Var_gnupg_key_length}
Subkey-Type: ${Var_gnupg_sub_key_type}
Subkey-Length: ${Var_gnupg_sub_key_length}
Name-Real: ${Var_gnupg_name}
Name-Comment: ${Var_gnupg_comment}
name-Email: ${Var_gnupg_email}
Expire-Date: ${Var_gnupg_expire_date}
Passphrase: ${_pass_phrase[*]}
## Uncomment the next line to not generate keys
#%dry-run
%commit
%echo finished
EOF
	unset _pass_phrase
}
Func_gnupg_configuration(){
	_gnupg_conf_save_yn="${1}"
	_gnupg_conf_location="${2}"
	case "${_gnupg_conf_save_yn}" in
		y|Y|yes|Yes|YES)
			if [ -f "${_gnupg_conf_location}" ]; then
				echo "# ${Var_script_name} backing-up configuration to: ${_gnupg_conf_location}.bak"
				cp -v "${_gnupg_conf_location}" "${_gnupg_conf_location}.bak"
			fi
			if ! [ -d "${_gnupg_conf_location%/*}" ]; then
				mkdir -vp "${_gnupg_conf_location%/*}"
			fi
			echo "# ${Var_script_name} writing new configurations: ${_gnupg_conf_location}"
cat > "${_gnupg_conf_location}" <<EOF
## Custom settings from the following link
##  https://raw.githubusercontent.com/ioerror/duraconf/master/configs/gnupg/gpg.conf
#----------
# Behavior
#----------
no-emit-version
no-comments
keyid-format 0xlong
with-fingerprint
list-options show-uid-validity
verify-options show-uid-validity
use-agent
#-----------
# Keyserver
#-----------
keyserver ${Var_gnupg_key_server}
#keyserver hkps://hkps.pool.sks-keyservers.net
#keyserver-options ca-cert=/path/to/downloaded.pem
keyserver-options no-try-dns-srv
keyserver-options include-revoked
#-----------------------
# Algorithm and ciphers
#-----------------------
personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
cert-digest-algo SHA512
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
EOF
		;;
		*)
			echo "# ${Var_script_name} will not be modifying: ${Var_gnupg_conf_location}"
		;;
	esac
}
Func_gen_revoke_cert(){
	_pass_phrase=( "$@" )
	case "${Var_gnupg_revoke_cert_yn}" in
		y|Y|yes|Yes|YES)
			echo "# ${Var_script_name} generating revoke cert: ${Var_gnupg_revoke_location}"
			## Note the order is, y='Yes generate a revoke cert'
			## 1='The revoke cert code'
			## Var_gnupg_revoke_reason='General reason for revoke'
			## Blank line to progress things in menus
			## y='Yes do it already'
			## _pass_phrase at the point expected
			## Note the reason will be displayed publicly if ever used.
			gpg --no-tty --command-fd 0 --status-fd 2 --armor --output ${Var_gnupg_revoke_location} --gen-revoke ${Var_gnupg_email} <<EOF
y
0
${Var_gnupg_revoke_reason}

y
${_pass_phrase[*]}
EOF
			## Note The above are a combination of:
			##  https://github.com/stef/gpk/blob/master/genkey
			##  and: https://github.com/baird/GPG/blob/master/GPGen/gpgen
			##  plus testing by the authors of this script & Travis-CI.
		;;
		*)
			echo "# ${Var_script_name} skipping function: Func_gen_revoke_cert"
		;;
	esac
	unset _pass_phrase
}
Func_export_keys(){
	_pass_phrase=( "$@" )
	case "${Var_gnupg_export_public_key_yn}" in
		y|Y|yes|Yes|YES)
			echo "# ${Var_script_name} running: gpg --yes --armor --output ${Var_gnupg_export_public_key_location} --export ${Var_gnupg_email}"
			gpg --yes --armor --output ${Var_gnupg_export_public_key_location} --export ${Var_gnupg_email}
		;;
		*)
			echo "# ${Var_script_name} skipping exporting public key for: ${Var_gnupg_email}"
		;;
	esac
	case "${Var_gnupg_export_private_key_yn}" in
		y|Y|yes|Yes|YES)
			echo "# ${Var_script_name} running: echo \"\${_pass_phrase[*]}\" | gpg --yes --armor --passphrase-fd 0 --output ${Var_gnupg_export_private_key_location} --export-secret-keys ${Var_gnupg_email}"
			echo "${_pass_phrase[*]}" | gpg --yes --armor --passphrase-fd 0 --output ${Var_gnupg_export_private_key_location} --export-secret-keys ${Var_gnupg_email}
		;;
		*)
			echo "# ${Var_script_name} skipping exporting secret keys for: ${Var_gnupg_email}"
		;;
	esac
	unset _pass_phrase
}
Func_report_on_exports(){
	if [ -f "${Var_gnupg_revoke_location}" ]; then
		echo "# ${Var_script_name} reports that the following should be backup: ${Var_gnupg_revoke_location}"
		ls -hal ${Var_gnupg_revoke_location}
	else
		echo "# ${Var_script_name} reports that there is no revoke cert to backup."
	fi
	if [ -f "${Var_gnupg_export_public_key_location}" ]; then
		echo "# ${Var_script_name} reports to share public key file: ${Var_gnupg_export_public_key_location}"
		ls -hal ${Var_gnupg_export_public_key_location}
	else
		echo "# ${Var_script_name} reports no public key has been exported"
	fi
	if [ -f "${Var_gnupg_export_private_key_location}" ]; then
		echo "# ${Var_script_name} reports to backup private key file: ${Var_gnupg_export_private_key_location}"
		ls -hal ${Var_gnupg_export_private_key_location}
	else
		echo "# ${Var_script_name} reports no private key has been exported"
	fi
	if [ -f "${Var_save_pass_location}" ]; then
		echo "# ${Var_script_name} reports to backup passphrase file: ${Var_save_pass_location}"
		ls -hal ${Var_save_pass_location}
	else
		echo "# ${Var_script_name} reports no passphrase file to backup."
	fi
}
Func_check_collision(){
	_key_fingerprint="$(gpg --fingerprint ${Var_gnupg_email} | awk -F "/" '/pub /{print $2}' | awk '{print $1}')"
	_grep_string='not found on keyserver'
	gpg --dry-run --batch --search-keys ${_key_fingerprint} --keyserver ${Var_gnupg_key_server} | grep -qE "${_grep_string}"
	_exit_status=$?
	if [ "${_exit_status}" != "0" ]; then
		echo "# ${Var_script_name} reports unique key fingerprint: ${_key_fingerprint}"
		Func_upload_pub_key
	else
		echo "# ${Var_script_name} WARNING key fingerprint collision: ${_key_fingerprint}"
		echo "# Script cannont knowingly upload conflicting keys!"
	fi
}
Func_upload_pub_key(){
	case "${Var_gnupg_upload_key_yn}" in
		y|Y|yes|Yes|YES)
			echo "# ${Var_script_name} uploading new public key for: ${Var_gnupg_email}"
			gpg --keyserver ${Var_gnupg_key_server} --send-keys ${Var_gnupg_email}
		;;
		*)
			echo "# ${Var_script_name} skipping uploading key for: ${Var_gnupg_email}"
		;;
	esac
}
Func_main(){
	case "${Var_save_pass_yn}" in
		y|Y|yes|Yes|YES)
			case "${Var_prompt_for_pass_yn}" in
				n|N|no|No|NO)
					echo "${Var_auto_pass_phrase}" > "${Var_save_pass_location}"
					_current_pass_phrase="$(cat "${Var_save_pass_location}")"
				;;
				*)
					echo -n "# ${Var_script_name} needs a passphrase: "
					read -a _response
					echo "${_response[*]}" > "${Var_save_pass_location}"
					unset _response
					_current_pass_phrase="$(cat "${Var_save_pass_location}")"
				;;
			esac
		;;
		*)
			case "${Var_prompt_for_pass_yn}" in
				n|N|no|No|NO)
					_current_pass_phrase="${Var_auto_pass_phrase}"
					echo "# ${Var_script_name} please take note of your passphrase"
					echo "#	${_current_pass_phrase}"
				;;
				*)
					echo -n "# ${Var_script_name} needs a passphrase: "
					read -a _response
					_current_pass_phrase="${_response[*]}"
					unset _response
				;;
			esac
		;;
	esac
	Func_gnupg_configuration "${Var_gnupg_conf_save_yn}" "${Var_gnupg_conf_location}"
	Func_gen_gnupg_keys "${_current_pass_phrase}"
	Func_gen_revoke_cert "${_current_pass_phrase}"
	Func_export_keys "${_current_pass_phrase}"
	unset _current_pass_phrase
	Func_check_collision
	Func_report_on_exports
}
if [ "${#Arr_options[@]}" = "0" ]; then
	Func_check_args '--help'
else
	Func_check_args "${Arr_options[@]}"
	Func_main
fi
echo "# ${Var_script_name} finished at: $(date -u +%s)"
