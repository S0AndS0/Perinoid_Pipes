# Work flow steps that will repeat (code maintenance)

 > Note the following instructions assume that your have already completed the
 steps outlined in
 [Contributing_code_initial_setup.md](Contributing_code_initial_setup.md)
 and are operating within the `Parinoid_Pipes/` directory.

## Write custom function for line wrapping commit messages

```
Fold_Message(){
    _message="$@"
    _column_width='80'
    _folded_message=$(fold -sw ${_column_width} <<<"${_message}")
    $(which echo) -e "${_folded_message}"
}
```

 > The above function maybe written into your terminal or saved to a file, so
 long as it is `source`d into your current terminal's shell environment the above
 function can then be used to format git commits.

### Example of formatted commit with above function

```
git commit --branch -S -m "Title of changes"\
 -m "$(Fold_Message 'any length string within these single quotes' or even outside 'will be formatted to lines of no more than 80 columns')"\
 Documentation/Contributing_code_maintenance.md
```

 > Important bit from above example is the ` -m "$(Fold_Message 'commit text')"
 part as the `$()` opens a sub-shell to push message text through the previously
 assigned function. While this is **not** required it does help with readability.

## Make custom branch for tracking local changes

```
Var_custom_branch="$(git branch --list | awk '/\*/{print $2}')"
Var_local_branch_name=$(date -u +%s)_${Var_custom_branch}
git checkout -b ${Var_local_branch_name}
```

 > The above uses the date (with formatting to show only seconds sense 1970)
 to prefix what ever you've chosen to assign to `Var_custom_branch` variable.
 While not required the authors will encourage the use of time stamp prefixing
 because it allows the *berth* of new branches to be easily tracked while also
 allowing for you to make custom branch names that make sense to your own
 organization preferences.

## Check that you are now on a local branch

```
git branch --list | awk '/\*/{print $2}'
```

 > The above should report whatever name you have assigned via
 `${Var_local_branch_name}` variable in previous command.

## Make changes to script or other files

```
vim Documentation/ReadMe_Paranoid_Pipes.md
# Or nano
nano Paranoid_Pipes.sh
```

 > Note examples include `vim` & `nano` but whatever text editor that you prefer
 that also doesn't mangle end of line or other special characters should be fine.

## Sign committed changes, including branch command line option is optional

```
git commit --branch -S -am "Added feature or fixed bug"\
 -m "Summery of changes"\
 -m "Any further details"
```

 > Hint: `git status` will show changed files and added files and preforming a
 `git diff <file_name>` (replacing `<file_name>` with a reported modified file)
 will show the recent changes that are not currently tracked by `git`. This can
 be really helpful when making lots of small changes to many files or when coming
 back to this project's code after a long rest.

## Test changes then prep for submitting a pull request

```
## Update local repo master branch code among other remote branches.
git fetch --all
## Merge master branch into current working branch
##  note if any conflicts arise be sure to resolve
##  and commit them prior to proceeding.
git merge --verify-signatures -S master
```

## After testing and committing, share fixes or features via pull request

```
Var_branch_name=$(git branch --list | awk '/\*/{print $2}')
Var_git_url='git@github.com:S0AndS0/Paranoid_Pipes.git'
git request-pull -p ${Var_branch_name} ${Var_git_url} master
```

 > Note the above should submit a patch (via `-p` option used above) and pull
 request to authors/maintainers, who if available, will review changes and
 merge when able. If you wish to share changes swiftly then consider forking
 via GitHub's web interface or via `hub` python command line wrapper, and then
 submitting pull requests to your own fork.

## When finished merge changes back to original/master branch with a message.

```
git checkout master
git merge --verify-signatures -S ${Var_local_branch_name}\
 -am "Merged local testing branch ${Var_branch_name} into master branch"\
 -m "This fixes issue <issue-id> or adds feature <feature-name>"\
 -m "<any further details>"
```

 > Edit text between `<` & `>` to reflect changes made. Note if above generates
 merge conflicts then attempt `git mergetool` if you have already setup a git
 merge tool default.

 > Hint: use `git diff ${Var_local_branch_name}..master` to refresh your memory
 as to what changes where made between branches.

When and if merge conflicts happen see [Contributing_code_merge_conflicts.md](Contributing_code_merge_conflicts.md)
 file within the `Documentation/` directory of this project for detailed
 information on how to resolve using `vimdiff` command line text text editor.

# Licensing notice for this file

```
    Copyright (C) 2016 S0AndS0.
    Permission is granted to copy, distribute and/or modify this document under
    the terms of the GNU Free Documentation License, Version 1.3 published by
    the Free Software Foundation; with the Invariant Sections being
    "Title page". A copy of the license is included in the directory entitled
    "License".
```

[Link to title page](Contributing_Financially.md)

[Link to related license](../Licenses/GNU_FDLv1.3_Documentation.md)
