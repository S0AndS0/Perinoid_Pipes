### Documentation for named pipe encryption scripted logics

#### External application usage

 External program | License type | Usage within script
------------------|:------------:|--------------------
 `gpg` or `gpg2`  | [GNU GPL v3](https://www.gnu.org/copyleft/gpl.html) | Encryption, decryption and signature verification of data parsed by this project's custom scripts and named pipes.
 `mkdir`          | [GNU GPL v3](https://www.gnu.org/copyleft/gpl.html) | Makes directories if not already present for output files (bulk or otherwise) and log files.
 `cp`             |  | Copies files or directories recursively at times.
 `mutt`           | [GNU GPL v2 or greater](https://dev.mutt.org/hg/mutt/file/084fb086a0e7/COPYRIGHT#l20) | Email client used by this script for log rotation actions involving emailing admins.
 `rm`             |  | Removes files, pipes and old logs.
 `cat`            |  | Concatenates files or strings passed as files to terminal or parsing pipe input commands.
 `echo`           |  | Prints messages to scripts users and used for redirecting messages to script log files.
 `tar`            |  | Compresses parsing log files during log rotation actions if enabled.
 `chown`          |  | Change ownership `<user>:<group>` of files and/or directories.
 `mkfifo`         |  | Make *first-in-first-out* named pipe file. This is one of the *magic* commands used in this script.
 `date`           |  | Print date to script log files or in user messages.
 `bash`           | [GNU GPL v3 or greater](https://www.gnu.org/software/bash/) | Interprets *human readable* source code (this project's scripts) into compatible machine instructions, often used as the command line interpreter for user logins and scripting, rarely used or seen as a programing language.

#### Documentation specific to each command above can be found with `<command> --help` or `man <command>`

 Bash commands | Usage within script
---------------|--------------------
 `touch`       | Make or remake files, such as when rotating logs just prior to restarting permissions and ownership again.
 `trap`        | Remove pipes on exiting reader and logs on exiting main script if above `--log-auto-delete-yn=<y/n>` option is set to a `yes` value.
 `read`        | Read input from users, such as prompts to continue if main script's above `--debug-level=<n>` option is set high enough.
 `mapfile`     | Read multiple lines of input from a named pipe into an array such that the data maybe reinserted into parsing commands.
 `set`         | Turn on and off Bash history logging to prevent commands such as `echo "supper secret string" | gpg -r myself@host.domain >> mysuppersecrits.gpg` from appearing in in `~/.bash_history` file.
 `let`         | Set numerical values to internal variables used to keep arrays' indexes ordered in looped Bash logic.
 `disown`      | Disown the PID of last function (or script) called allows for backgrounding the processes used to listen to named pipes and output to log files and bulk directory.
 `break`       | Breaks out of looped Bash logics such that the parent process can either exit or restart listening again.

#### Documentation specific to each command above can be found with `help <command>` and/or `man <command>`

 Bash switch, loops, & operators  | Help command   | Usage within script
----------------------------------|----------------|--------------------
 `&&` and `||`                    | `man operator` | Are *short-handed* tests for success or failure, known as "and"s & "or"s, ie `first command && second command` vs `first command || second command` will operate differently based upon `first command`'s exit status.
 `case`...`in`...`esac`           | `help case`    | Are used to test a variable's value against many possible outcomes, ie `case "$(date +%u)" in 1) echo "Ug, mondays";; 3) echo "hump day keep it up!";; 7) echo "get some sun";; *) echo "$(date +%u)";; esac`
 `for`...`do`...`done`            | `help for`     | Used until looping through command line options of main script finishes resetting any script variables over written at the command line.
 `if`...`then`...`fi`             | `help if`      | Are used for if *something* equals another *something*, ie numerical values and file's existence or string equivalence with another string, ie `if [ "1" = "0" ]; then echo "Mathematical believes shattered" else echo "Math still works"; fi`
 `until`...`do`...`done`          | `help until`   | Preform actions until test statements return true, ie `until [ "0" = "1" ]; do echo "# Mathematical believes assured; 0 does not equal 1... yet..." && sleep 1; done`
 `while`...`do`...`done`          | `help while`   | Preform actions while test statements do not return false, ie `while ! [ "0" = "1" ]; do echo "# Mathematical believes assured; 0 does not equal 1... yet..." && sleep 1; done`
 `[ "`...`" =`or`!= "`...`" ]`    | `man operator` | Often seen in use with `-gt` in place of `=` or `-f` or `-p` preceding a variable, this is used in combination with `if`, `until` and others to quickly test equivalency or if a file or pipe is present.
 `first_command | second_command` | `man pipe`    | for anonymous piping output of `first_command` into input of `second_command`


 Bash variable & array syntax                   | Usage within script
------------------------------------------------|--------------------
 `var=value`                                    | Assign `value` to variable named `var`. Often seen assigning directory or file paths or other values to descriptive variable names.
 `echo "${var//,/ }"`                           | Expand variable named `var` replacing every comma `,` with a space ` `. Usually found in debugging messages and within loops such as `for _word in ${var//,/ }; do echo "# Read word ${_word} in ${var} list"; done` to separate words in a `,` separate list.
 `arr=( "value1" "value two" "3" )`             | Assign `value1` and `value two` to array named `arr`. Arrays are a whole'nuther can'o'worms but are one of the *magic* things that makes this script tick. Note above tricks of replacing a target character with another also work with arrays.
 `echo "${arr[@]}"`                             | Expand all indexes in array named `arr`. More often you'll find this written as `until [ "${#arr[@]}" = "${_count}" ] || [ "${arr[${_count}]}" = "${_quit_line}" ]; do echo "# Doing stuff to ${arr[${_count}]}" && let _count++; done` to loop through an indexed array much like a `for` loop would loop over a list.
 `echo "${arr[@]:1}"`                           | Expand all indexes in array `arr` after index `1`. This can be used similarly to the looping example above but we can get fancy. Here's is a tip on how to *dump* everything in above array after `${_count}`+`1`
 `_arr_remiander=( ${arr[$((${_count}+1))]}  )` | When you see how above loop has evolved (hint, check `Senerio one` within this document) ya might just chuckle at the work-around.
 `command <<<${var}`                            | for one-way redirection of `${var}`'s value into `command`'s input

 Bash internal variables | Usage within script
-------------------------|--------------------
 `$?`                    | Saves exit of previous command to a variable, ie `touch fire; _exit_var=$?; echo "Exit status [${_exit_var}] for last command"`
 `var=${PIPESTATUS[@]}`  | to capture exit statuses of multi piped or redirected commands
 `$!`                    | Saves PID of last command to a variable for use with `unset` command when backgrounding processes or script.

#### Bash function assignment and calling syntax:

 - assign a function named `func`

```bash
func(){
  var="${1:-value}"
  echo "${var}"
}
```

 - call above function named `func`

```bash
func "yo"
```

 - manipulating via assigning function `func` with argument `yo` to variable `func_var`

```bash
func_var=$(func "yo")
```

#### Bash write file method: 

 - Write to `/dir/file.name` text until `EOF` is found on it's own line.

```bash
cat > "/dir/file.name" <<EOF
some text with "EOF" on a new line to end statement
some variables with "\" and some without depending
upon if they should be expanded on write or on re-read/execution
EOF
```

# Licensing notice for this file

 > ```
    Copyright (C) 2016 S0AndS0.
    Permission is granted to copy, distribute and/or modify this document under
    the terms of the GNU Free Documentation License, Version 1.3 published by
    the Free Software Foundation; with the Invariant Sections being
    "Title page". A copy of the license is included in the directory entitled
    "License".
```

[Link to title page](Contributing_Financially.md)

[Link to related license](../Licenses/GNU_FDLv1.3_Documentation.md)
