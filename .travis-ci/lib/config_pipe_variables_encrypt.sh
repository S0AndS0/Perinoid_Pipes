Arr_encrypt_opts+=( ---Var_debugging="2" )
#export Var_debugging="2"
Arr_encrypt_opts+=( ---Var_script_copy_save="yes" )
#export Var_script_copy_save="yes"
Arr_encrypt_opts+=( ---Var_pipe_quit_string="quit" )
#export Var_pipe_quit_string="quit"
Arr_encrypt_opts+=( ---Var_script_copy_name="/tmp/Paranoid_Pipes/encrypt.sh" )
#export Var_script_copy_name="/tmp/Paranoid_Pipes/encrypt.sh"
Arr_encrypt_opts+=( ---Var_log_file_name="/tmp/Paranoid_Pipes/encrypt.log" )
#export Var_log_file_name="/tmp/Paranoid_Pipes/encrypt.log"
Arr_encrypt_opts+=( ---Var_pipe_file_name="/tmp/Paranoid_Pipes/encrypt.pipe" )
#export Var_pipe_file_name="/tmp/Paranoid_Pipes/encrypt.pipe"
Arr_encrypt_opts+=( ---Var_parsing_output_file="/tmp/Paranoid_Pipes/encrypt.gpg" )
#export Var_parsing_output_file="/tmp/Paranoid_Pipes/encrypt.gpg"
Arr_encrypt_opts+=( ---Var_gpg_recipient="${Var_gnupg_email}" )
#export Var_gpg_recipient="${Var_gnupg_email}"
Arr_encrypt_opts+=( ---Var_log_rotate_recipient="${Var_gnupg_email}" )
#export Var_log_rotate_recipient="${Var_gnupg_email}"
Arr_encrypt_opts+=( ---Var_parsing_bulk_out_dir="/tmp/Paranoid_Pipes" )
#export Var_parsing_bulk_out_dir="/tmp/Paranoid_Pipes"
