## Where to place scripts from this project?
export Var_install_path="/usr/local/sbin"
## What script to copy from project root dir to above directory?
export Var_install_name="Paranoid_Pipes.sh"
## What applications to install for above script?
export Var_dependency_list="gnupg,haveged"
## What email address to assign to GPG test keys & use for GnuPG operations?
export Var_gnupg_email="${USER}@hostname.local"
## How many charicters for passphrase
export Var_pass_length='32'
## What file paths to use when testing new GPG keys?
export Var_pass_location="${PWD}/gpg_test_keys.pass"
export Var_test_gpg_location="${PWD}/test_encrypt.gpg"
export Var_test_raw_location="${PWD}/test_raw.txt"
export Var_test_location="${PWD}/test_string_raw.txt"
## What key to try to import and the trust level to assign
export Var_import_key_id="strangerthanbland@gmail.com"
export Var_import_key_trust="1"
##  The following block of variables is used in 'script_encrypt.sh' file.
export Var_encrypt_pipe_location="${PWD}/encrypt_one.pipe"
export Var_encrypt_pipe_log="${PWD}/encrypt_one.log"
export Var_encrypted_location="${PWD}/encrypt_one.gpg"
export Var_encrypted_bulk_dir="${PWD}/bulk_encryption"
export Var_raw_test_location="${PWD}/raw_strings.txt"
export Var_decrypt_raw_location="${PWD}/decrypt_one.txt"
export Var_encrypt_dir_path="${PWD}/Documentation"
export Var_encrypt_file_path="${PWD}/ReadMe.md"
##  The following block of variables is used in 'script_decrypt.sh' file
##  Note that this script also re-uses the 'Var_raw_test_location' variable.
export Var_bulk_decryption_dir="${PWD}/bulk_decryption"
export Var_decrypt_pipe_location="${PWD}/decrypt.pipe"
export Var_decrypted_location="${Var_decrypt_pipe_location%.*}.txt"
## Found redirection trick at: https://possiblelossofprecision.net/?p=413
##  and from: unix.stackexchange.com/questions/18899/when-would-you-use-an-additional-file-descripter
export Var_gnupg_decrypt_opts="--always-trust --passphrase-fd 9 --decrypt"
export Var_script_copy_name_encrypt="${PWD}/encrypt_listener.sh"
export Var_script_copy_name_decrypt="${PWD}/decrypt_listener.sh"
## The following are used within '' file
export Var_search_out_location="${PWD}/decrypt_search.txt"
##  The following block of variables is used in 'script_encrypt_copy.sh' file.
##
export Var_encrypt_pipe_location_copy="${PWD}/encrypt_two.pipe"
export Var_encrypt_pipe_log_copy="${PWD}/encrypt_two.log"
export Var_encrypted_location_copy="${PWD}/encrypt_two.gpg"
export Var_encrypted_bulk_dir_copy="${PWD}/bulk_encryption_two"
export Var_raw_test_location_copy="${PWD}/raw_strings_two.txt"
export Var_decrypt_raw_location_copy="${PWD}/decrypt_two.txt"
export Var_encrypt_dir_path_copy="${PWD}/Script_Helpers"
export Var_encrypt_file_path_copy="${PWD}/Paranoid_Pipes.sh"
## Variables for verision two of main script copies
export Var_install_v2_name="version_two.sh"
export Var_encrypt_pipe_three_location="${PWD}/encrypt_three.pipe"
export Var_encrypt_pipe_three_log="${PWD}/encrypt_three.log"
export Var_encrypted_three_location="${PWD}/encrypt_three.gpg"
export Var_encrypted_three_bulk_dir="${PWD}/bulk_encryption_three"
export Var_raw_test_three_location="${PWD}/raw_strings_three.txt"
export Var_encrypt_file_three_path="${PWD}/ReadMe.md"
export Var_encrypt_dir_three_path="${PWD}/Documentation"
export Var_decrypt_raw_three_location="${PWD}/decrypt_three.txt"
export Var_decrypt_three_log="${PWD}/decrypt_three.log"
export Var_bulk_decryption_three_dir="${PWD}/bulk_decryption_three"
export Var_script_copy_three_name_encrypt="${PWD}/encryption_listener_three.sh"
export Var_script_copy_three_name_decrypt="${PWD}/decryption_listener_three.sh"
## Variables for testing internal features of version two
export Var_encrypt_pipe_four_location="${PWD}/encrypt_four.pipe"
export Var_encrypt_pipe_four_log="${PWD}/encrypt_four.log"
export Var_encrypted_four_bulk_dir="${PWD}/bulk_encryption_four"
export Var_raw_test_four_location="${PWD}/raw_strings_four.txt"
export Var_encrypt_file_four_path="${PWD}/ReadMe.md"
export Var_encrypt_dir_four_path="${PWD}/Documentation"
export Var_decrypt_raw_four_location="${PWD}/decrypt_four.txt"
export Var_decrypt_four_log="${PWD}/decrypt_four.log"
export Var_bulk_decryption_four_dir="${PWD}/bulk_decryption_four"
export Var_script_copy_four_name_encrypt="${PWD}/encryption_listener_four.sh"
export Var_enc_dec_shared_pipe="${PWD}/EncDec_shared.pipe"
## Variables for testing experomental features of version two
Var_raw_test_last_location="${PWD}/last_raw_tests.txt"
Var_encrypt_last_log="${PWD}/encrypt_last.log"
Var_encrypt_pipe_last_location="${PWD}/last_enc_tests.pipe"
Var_encrypted_last_location="${PWD}/last_enc_tests.gpg"
Var_encrypted_last_bulk_dir="${PWD}/last_enc_tests_bulk"
Var_encrypt_dir_last_path="${PWD}/Documentation"
Var_encrypt_file_last_path="${PWD}/ReadMe.md"
Var_decrypt_last_log="${PWD}/decrypt_last.log"
Var_decrypt_raw_last_location="${PWD}/last_dec_tests.txt"
Var_bulk_decryption_last_dir="${PWD}/last_dec_tests_bulk"

#${Var_import_key_id}
#${Var_import_key_trust}
