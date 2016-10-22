Arr_decrypt_opts+=( "---Var_debugging=2" )
#export Var_debugging="2"
Arr_decrypt_opts+=( "---Var_script_copy_save=yes" )
#export Var_script_copy_save="yes"
Arr_decrypt_opts+=( "---Var_pipe_quit_string=quit" )
#export Var_pipe_quit_string="quit"
Arr_decrypt_opts+=( "---Var_script_copy_name=/tmp/Paranoid_Pipes/decrypt.sh" )
#export Var_script_copy_name="/tmp/Paranoid_Pipes/decrypt.sh"
Arr_decrypt_opts+=( "---Var_log_file_name=/tmp/Peranoid_Pipes/decrypt.log" )
#export Var_log_file_name="/tmp/Peranoid_Pipes/decrypt.log"
Arr_decrypt_opts+=( "---Var_pipe_file_name=/tmp/Peranoid_Pipes/decrypt.pipe" )
#export Var_pipe_file_name="/tmp/Peranoid_Pipes/decrypt.pipe"
Arr_decrypt_opts+=( "---Var_parsing_output_file=/tmp/Peranoid_Pipes/decrypt.txt" )
#export Var_parsing_output_file="/tmp/Peranoid_Pipes/decrypt.txt"
Arr_decrypt_opts+=( "---Var_gpg_recipient=${Var_gnupg_email}" )
#export Var_gpg_recipient="${Var_gnupg_email}"
Arr_decrypt_opts+=( "---Var_log_rotate_recipient=${Var_gnupg_email}" )
#export Var_log_rotate_recipient="${Var_gnupg_email}"
Arr_decrypt_opts+=( "---Var_parsing_bulk_out_dir=/tmp/Peranoid_Pipes" )
#export Var_parsing_bulk_out_dir="/tmp/Peranoid_Pipes"
Arr_decrypt_opts+=( "---Var_gpg_decrypter_options='--batch --decrypt --passphrase-file ${Var_pass_location}'" )
#export Var_gpg_decrypter_options="--batch --decrypt --passphrase-file ${Var_pass_location}"
Arr_decrypt_opts+=( "---Var_parsing_command='${Var_gpg_exec_path} ${Var_gpg_decrypter_options}'" )
#export Var_parsing_command="${Var_gpg_exec_path} ${Var_gpg_decrypter_options}"
