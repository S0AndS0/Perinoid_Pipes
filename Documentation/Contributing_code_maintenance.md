# Work flow steps that will repeat

 > Note the following instructions assume that your have already completed the
 steps outlined in
 [Contributing_code_initial_setup.md](Contributing_code_initial_setup.md)
 and are operating within the `Parinoid_Pipes/` directory.

## Make custom branch for tracking local changes

```bash
Var_custom_branch="$(git branch --list | awk '/\*/{print $2}')"
Var_local_branch_name=$(eval "date -u +%s")_${Var_custom_branch}
git checkout -b ${Var_local_branch_name}
```

 > The above uses the date (with formatting to show only seconds sense 1970)
 to prefix what ever you've chosen to assign to `Var_custom_branch` variable.
 While not required the authors will encourage the use of time stamp prefixing
 because it allows the *berth* of new branches to be easily tracked while also
 allowing for you to make custom branch names that make sense to your own
 organization preferences.

## Check that you are now on a local branch

```bash
git branch --list | awk '/\*/{print $2}'
```

 > The above should report whatever name you have assigned via
 `${Var_local_branch_name}` variable in previous command.

## Make changes to script or other files

```bash
vim Documentation/ReadMe_Paranoid_Pipes.md
# Or nano
nano Paranoid_Pipes.sh
```

 > Note examples include `vim` & `nano` but whatever text editor that you prefer
 that also doesn't mangle end of line or other special characters should be fine.

## Sign committed changes, including branch command line option is optional

```bash
git commit --branch -S -am "Added feature or fixed bug" -m "Summery of changes"
```

 > Hint: `git status` will show changed files and added files and preforming a
 `git diff <file_name>` (replacing `<file_name>` with a reported modified file)
 will show the recent changes that are not currently tracked by `git`. This can
 be really helpful when making lots of small changes to many files.

## Test changes then prep for submitting a pull request

```bash
## Update local repo master branch code among other remote branches.
git fetch --all
## Merge master branch into current working branch
##  note if any conflicts arise be sure to resolve
##  and commit them prior to proceeding.
git merge --verify-signatures -S master
```

 > Note if above caused conflicts then use `Resolving Merge Conflicts` section
 within this document for further instructions.

## After testing and committing share fixes or features via pull request

```bash
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

```bash
git checkout master
git merge --verify-signatures -S ${Var_local_branch_name}\
 -am "Merged local testing branch ${Var_branch_name} into master branch"\
 -m "This fixes issue <issue-id> or adds feature <feature-name>"\
 -m "<any further details>"
```

 > Note if above generates merge conflicts then attempt `git mergetool` if you
 have already setup a git merge tool default.

 > Hint: use `git diff ${Var_local_branch_name}..master` to refresh your
 memory as to what changes where made between branches.

When and if merge conflicts happen see [Contributing_code_merge_conflicts.md](Contributing_code_merge_conflicts.md)
 file within the `Documentation/` directory of this project for detailed
 information on how to resolve using `vimdiff` command line text text editor.

