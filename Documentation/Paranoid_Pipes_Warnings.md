## Warnings

0. This project, it's scripts and those contained within this document and this document itself are all without warranty nor will the authors be held liable for damages sustained to users, their hardware or the hardware of others while using this project's scripts, guides, or examples.

 - - Scripts and code are released under `GNU AGPLv3` licence found under the `Licenses` directory.

 - - Documentation and guides are released under `GNU FDLv1.3` licence found under the `Licenses` directory.

 - - allowed use, user agreement, reproduction and modification are further explained in the `` section within this document.

1. Do not send **all** logging daemon output through this script's (or the script copy's) named pipe(s); be selective.

 - - first because this script likely generates system logs so sending all `rsyslog`'s data into one of these named pipes would be analogous to force feeding a snake it's own tail & the rest of the kitchen along with,

 - - second because even with filtering this script from your logging daemon's output, logging everything else through an encrypting pipe will likely slow down if not crash your system.

 - - Be very specific as to what data you send through!

2. Do not send untrusted input into decrypting or encrypting pipes without understanding what this tool is doing!

 - -  much care has been taken to provide options towards preventing data passing through named pipes from expansion into shell commands

 - - still it is possible that a devoted attacker could embed malicious code within that is either expanded upon while writing or reading.

3. Do not read decrypted content on an insecure or default configured document reader.

 - - Same reasoning as `Warning 2` above and,

 - - default configured document readers often save caches and/or backups in clear text at some obscure location; kinda defeats the porous of keeping secrets if your reader tattles on you.

4. Only enable `--output-pre-parse-yn` and/or `--padding-enable-yn` options when you are certain as to what those options do. Default values for each are `no` so do not worry about manually disabling them.

 - - the `--output-pre-parse-yn` option if enabled will cause the listening loop to perpend `#` to read lines that do not have them at the start of the line already

 - - the `--padding-enable-yn` option if enabled will cause lines read to also include random alpha and numeric characters the be added to read lines.

 - - See `CLO Manual and documentation` section within this document for all command line options of this project explained in greater detail.

 - - The authors of this project will not aid users in recovering corrupted files if either of these options where in use on user's target systems.

5. `--padding-enable-yn` and related options can *rob* the host OS of entropy,

 - - consider using `haveged`, ie `apt-get install haveged && /etc/init.d/haveged restart` let your system chill then check your entropy available `cat /proc/sys/kernel/random/entropy_avail`

 - - or buy a secure random number generator to seed `/dev/urandom` when entropy is low.

 - - or build an entropy seeder.

6. ` --output-parse-recipient` and `--output-rotate-recipient` options are **required** if `--help` option is excluded from script command line options.

 - - these email addresses maybe the same or different, but must be passed via command line or edited in manually. See section `` within `` for automation examples.

7. Script examples contained within this document **are** under the same licensing and terms agreement as the main script of this project, **however**, note that the script examples within this document are not as well tested as the main script and they're meant as general guidance of problem solving with Bash.
