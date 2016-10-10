# Initial `git` setup

 > skip any that have been completed for other code contributions.

## Setup GPG public key with GitHub
```bash
Var_gpg_email='email@host.domain'
Var_git_signing_fingerprint=$(gpg --list-keys ${Var_gpg_email} | awk '/fingerprint/{print $10""$11""$12""$13}')
## Above variables are for grabbing the last 16 bits of your fingerprint.
git config --global user.signingkey ${Var_git_signing_fingerprint}
```
 > The associated public key should be uploaded to GitHub under your user
 profile which is very well documented by [GitHub's guide - adding a new gpg key](https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/)

## Export GPG public key command example
```bash
## To terminal
gpg --armor --export ${Var_gpg_email}
## or to file
gpg --armor --export ${Var_gpg_email} --output ~/${Var_gpg_email%@*}.gpg
```
 > In either of above options for exporting your key you will want to copy &
 paste it into the required text input field on GitHub and save the account
 changes.

### Git commits may now be signed via the following method
```bash
git commit -S -m "Message title/synopsis" -m "Detailed message" modified/file/path
```
Note it is the `-S` command line option that tells git sign commits, the above
 should request your GPG private key's passphrase for unlocking that key prior
 to signing your commit.

## Adding SSH public key to GitHub
```bash
Var_git_user='S0AndS0'
Var_git_email='email@host.domain'
mkdir -p ~/.ssh
cd ~/.ssh
## Generate new key pair
ssh-keygen -t rsa -b 4096 -C "${Var_git_email}" -f "${Var_git_user}"
## Print public key to terminal
##  copy the public key to GitHub
##  within the required text field
cat ${Var_git_user}.pub
```
 > The `-C` (ssh key comment) should match the same email account as used by
 your GitHub account name defined by `-f` (file name) to keep things organized
 and avoid errors. Additional note, the above will request a passphrase be made
 if you set one up, this passphrase will be the one required to authenticate
 via ssh to git and not the account password setup via their web site.

### Add git client `ssh_config` settings configuration block
```bash
cat >> /etc/ssh/ssh_config <<EOF
host github.com
    HostName github.com
    User git
    IdentitiesOnly yes
    IdentityFile ~/.ssh/GithubUser
EOF
```
 > Note if you wish to setup specific keys for projects then
 [jexchan has written a fantastic gist](https://gist.github.com/jexchan/2351996)
 on the subject of multi-key management. Additional note the only setting from
 above that needs editing for normal ssh git operations is the `IdentityFile`
 location. When `git` commands interact with remote servers you will be
 prompted for the passphrase setup to protect your ssh keys and not the GitHub
 web password.

## Downloading source via ssh link
```bash
git clone git@github.com:S0AndS0/Perinoid_Pipes.git
cd Perinoid_Pipes
```
 > Note from here on the following commands will be from the prospective of
 the above code repository directory.

## Adding GitHub username and email to git config
```bash
Var_git_user='S0AndS0'
Var_git_email='email@host.domain'
## Above variable should be changed to reflect
##  your own GitHub user and related email.
git config --add user.name ${Var_git_user}
git config --add user.email ${Var_git_email}
```
 > Note the above maybe set global for the currently logged in local user by
 adding `--global`, in which case configurations will be save in
 `~/.gitconfig` file instead of `.git/config` within the project's path.

## Adding issues, pull & merge requests to local checkout of git repo
```bash
git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
git config --add remote.origin.fetch '+refs/pull/*/merge:refs/remotes/origin/pr/*/merge'
```
 > Note the above maybe set globally by adding `--global` prior to `--add`
 option for making git able to grab any code repository's 

## Fetch everything not currently downloaded
```bash
git fetch --all
```
 > Note new remote branches maybe checked out via `remote/branch` if any are
 available. List available branches with `git branch --list -vv`

## Add contact info, changes info, and if so desired "tips" info
```bash
Var_gpg_fingerprint=$(gpg --fingerprint --keyid-format long ${Var_gpg_email} | awk '/pub/{print $2}')
cat >> Contribution_Credits.md <<EOF
${Var_git_user} - ${Var_gpg_fingerprint#*/}
        By signing changes made to this document with private key related to
        above public key fingerprint the user name above signs acceptance that
        pull requests and change submitting made under the above user name will
        become licensed under the licensing agreements found in the
        Documentation directory of this project that most closely matches the
        changes made; ie code under code licensing and documentation under
        doc-centric licensing.
    Summery: <Working on feature/Fixing bug or issue>
    Support code contribution link(s): <your_BTC_address>
EOF
```
 > Note you will want to edit fields between `<` and `>` to reflect your
 information. Additional note, if you add your info and sign commits with the
 related GPG key then authors of this project will treat this as an acceptance
 to including your code within the main/master code branch under the same
 license as it operates under currently. In short this acts as a "waiver" of
 your legal claim/obligation to contributed code at the same levels as original
 authors such that authors and future users may make use of your code
 contributions without fear of violating licensing agreements already outlined
 in this project's `Licenses/` directory. In future pull requests and mergers
 you may excluded repeating the waver and instead just focus on being concise
 with updating `Summery:` & `Support code contribution link(s):` fields.

## Example of author's contact info writing steps.
```bash
cat >> Contribution_Credits.md <<EOF
S0AndS0 - 6E4C46DA15B22310
        By signing changes made to this document with private key related to
        above public key fingerprint the user name above signs acceptance that
        pull requests and change submitting made under the above user name will
        become licensed under the licensing agreements found in the
        Documentation directory of this project that most closely matches the
        changes made; ie code under code licensing and documentation under
        doc-centric licensing.
    Summery: Working on features & fixing any bugs that can be fixed.
    Support code contribution link(s):
        Found in "Title page" section of Documentation/ReadMe_Paranoid_Pipes.md
        file, thus not repeated here to avoid having to many files to keep updated.
EOF
```

## Sign commit of changes to `Contribution_Credits.md` file
```bash
git commit -S -m "Signed changes to Contribution_Credits.md" Contribution_Credits.md
```

## Import project author's public key
```bash
Var_author_keyid='6E4C46DA15B22310'
gpg --search-keys ${Var_author_keyid}
```

 > The above should result in presenting you with the author's key to import
 this public key can also be found at [Keybase.io](https://keybase.io/s0ands0)
 for verification that your `gpg` key servers are presenting you with the correct
 key.

### Assign a *trust* level for this new key
```bash
gpg --edit-keys ${Var_author_keyid}
```
 > The above will open an interactive menu for editing the above key ID, use
 `trust` to open the options for assigning a trust level, then `quit` to exit
 and save changes.

# Work flow steps that will repeat

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

When and if merge conflicts happen see [Contributing_merge_conflicts.md](Documentation/Contributing_merge_conflicts.md)
 file within the `Documentation/` directory of this project for detailed
 information on how to resolve using `vimdiff` command line text text editor.

