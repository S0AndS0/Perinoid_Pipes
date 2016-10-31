## Where to place scripts from this project?
export Var_install_path="/usr/local/sbin"
## What script to copy from project root dir to above directory?
export Var_install_name="Paranoid_Pipes.sh"
## What applications to install for above script?
export Var_dependency_list="gnupg,haveged"
## What email address to assign to GPG test keys & use for GnuPG operations?
export Var_gnupg_email="${USER}@hostname.local"
## How many charicters for passphrase as well as length of test strings?
export Var_pass_length='32'
## What file paths to use when testing new GPG keys?
##  The following block of variables is used in '' file.
export Var_pass_location="${PWD}/gpg_test_keys.pass"
export Var_test_gpg_location="${PWD}/test_encrypt.gpg"
export Var_test_raw_location="${PWD}/test_raw.txt"
export Var_test_location="${PWD}/test_string_raw.txt"
## What directories to use with script tests?
##  The following block of variables is used in 'script_encrypt.sh' file.
export Var_encrypt_pipe_location="${PWD}/encrypt_one.pipe"
export Var_encrypt_pipe_log="${PWD}/encrypt_one.log"
export Var_encrypted_location="${PWD}/encrypt_one.gpg"
export Var_encrypted_bulk_dir="${PWD}/bulk_out"
export Var_raw_test_location="${PWD}/string_one.txt"
export Var_decrypt_raw_location="${PWD}/decrypt_one.txt"
##  The following block of variables is used in 'script_decrypt.sh' file
export Var_decrypt_pipe_location="${PWD}/decrypt.pipe"
export Var_decrypted_location="${Var_decrypt_pipe_location%.*}.txt"
export Var_gnupg_decrypt_opts="--always-trust --yes --bulk --passphrase-file ${Var_pass_location} --decrypt"
