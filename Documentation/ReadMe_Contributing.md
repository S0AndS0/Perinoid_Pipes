# Initial `git` setup, skip any that have been completed for other code contributions.

## Setup GPG public key with GitHub
```bash
Var_gpg_email='email@host.domain'
Var_git_signing_fingerprint=$(gpg --list-keys ${Var_gpg_email} | awk '/fingerprint/{print $10""$11""$12""$13}')
## Above variables are for grabbing the last 16 bits of your fingerprint.
git config --global user.signingkey ${Var_git_signing_fingerprint}
```
The associated public key should be uploaded to GitHub under your user profile
 which is very well documented by [GitHub's guide - adding a new gpg key](https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/)

## Export GPG public key command example
```bash
## To terminal
gpg --armor --export ${Var_gpg_email}
## or to file
gpg --armor --export ${Var_gpg_email} --output ~/${Var_gpg_email%@*}.gpg
```
In either of above options for exporting your key you will want to copy & paste it
 into the required text input field on GitHub and save the account changes.

### Git commits may now be signed via the following method
```bash
git commit -S -m "Message title/synopsis" -m "Detailed message" modified/file/path
```
Note it is the `-S` command line option that tells git sign commits, the
 above should request your GPG private key's passphrase for unlocking
 that key prior to signing your commit.

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
The `-C` (ssh key comment) should match the same email account as used by GitHub
 account name defined by `-f` (file name) to keep things organized and avoid errors.
 Additional note, the above will request a passphrase be made, if you set one up, this
 passphrase will be the one required to authenticate via ssh to git and not the account
 password setup via their web site.

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
Note if you wish to setup specific keys for projects then [jexchan has written a fantastic gist](https://gist.github.com/jexchan/2351996)
 on the subject of multi-key management. Additional note the only setting from above
 that needs editing for normal ssh git operations is the `IdentityFile` location.
 When `git` commands interact with remote servers you will be prompted for the
 passphrase setup to protect your ssh keys and not the GitHub web password.

## Downloading source via ssh link
```bash
git clone git@github.com:S0AndS0/Perinoid_Pipes.git
cd Perinoid_Pipes
```
Note from here on the following commands will be from
 the prospective of the above code repository directory.

## Adding GitHub username and email to git config
```bash
Var_git_user='S0AndS0'
Var_git_email='email@host.domain'
## Above variable should be changed to reflect
##  your own GitHub user and related email.
git config --add user.name ${Var_git_user}
git config --add user.email ${Var_git_email}
```
Note the above maybe set global for the currently logged in
 local user by adding `--global`, in which case configurations
 will be save in `~/.git/config` instead of `.git/config`

## Adding issues, pull & merge requests to local checkout of git repo
```bash
git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
git config --add remote.origin.fetch '+refs/pull/*/merge:refs/remotes/origin/pr/*/merge'
```
Note the above maybe set globally by adding `--global` prior to `--add` option for making
 git able to grab any code repository's 

## Fetch everything not currently downloaded
```bash
git fetch --all
```
Note new remote branches maybe checked out via `remote/branch` if any
 are available. List available branches with `git branch --list -vv`

## Add contact info, changes info, and if so desired "tips" info
```bash
Var_gpg_fingerprint=$(gpg --fingerprint --keyid-format long ${Var_gpg_email} | awk '/pub/{print $2}')
cat >> Contribution_Credits.md <<EOF
${Var_git_user} - ${Var_gpg_fingerprint#*/}
        By signing changes made to this document with private key related to above
        public key fingerprint the user name above signs acceptance that pull requests
        and change submitting made under the above user name will become licensed
        under the licencing agreements found in the Documentation directory of this
        project that most closely matches the changes made; ie code under code licencing
        and documentation under doc-centric licencing.
    Summery: <Working on feature/Fixing bug or issue>
    Support code contribution link(s): <your_BTC_address>
EOF
```
Note you will want to edit fields between `<` and `>` to reflect your information.
 Additional note, if you add your info and sign commits with the related GPG
 key then authors of this project will treat this as an acceptance to including
 your code within the main/master code branch under the same licence as it operates
 under currently. In short this acts as a "waiver" of your legal claim/obligation
 to contributed code such that authors and future users may make use of your code
 contributions without fear of violating licencing agreements outlined in this project's
 `Licences/` directory.

## Example of author's contact info writing steps.
```bash
cat >> Contribution_Credits.md <<EOF
S0AndS0 - 6E4C46DA15B22310
        By signing changes made to this document with private key related to above
        public key fingerprint the user name above signs acceptance that pull requests
        and change submitting made under the above user name will become licensed
        under the licencing agreements found in the Documentation directory of this
        project that most closely matches the changes made; ie code under code licencing
        and documentation under doc-centric licencing.
    Summery: Working on features & fixing any bugs that can be fixed.
    Support code contribution link(s):
        Found in "Title page" section of Documentation/ReadMe_Perinoid_Pipes.md
        file, thus not repeated here to avoid having to many files to keep updated.
EOF
```

## Sign commit of changes to `Contribution_Credits.md` file
```bash
git commit -S -m "Signed changes to Contribution_Credits.md" Contribution_Credits.md
```

# Work flow steps that will repeat

## Make custom branch for tracking local changes
```bash
Var_local_branch_name="${USER}_$(git branch --list | awk '/\*/{print $2}')"
git checkout -b ${Var_local_branch_name}
```
Note the above uses the current user and branch name as
 the new local branch name, but you may use whatever makes
 the most since for your organization style.

## Check that you are now on a local branch
```bash
git branch --list | awk '/\*/{print $2}'
```
Note the above should report whatever name you have assigned
 via `${Var_local_branch_name}` variable in previous command.

## Make changes to script or other files
```bash
vim Documentation/ReadMe_Perinoid_Pipes.md
# Or nano
nano Perinoid_Pipes.sh
```
Note examples include `vim` & `nano` but whatever text editor
 that you prefer that also doesn't mangle end of line or other
 special characters should be fine

## Sign committed changes, including branch command line option is optional
```bash
git commit --branch -S -am "Added feature or fixed bug" -m "Summery of changes"
```

## Test changes then prep for submitting a pull request
```bash
## Update local repo master branch code among other remote branches.
git fetch --all
## Merge master branch into current working branch
##  note if any conflicts arise be sure to resolve
##  and commit them prior to proceeding.
git merge master
```
Note if above caused conflicts then use `Resolving Merge Conflicts` section
 within this document for further instructions.

## After testing and committing share fixes or features via pull request
```bash
Var_branch_name=$(git branch --list | awk '/\*/{print $2}')
Var_git_url='git@github.com:S0AndS0/Perinoid_Pipes.git'
git request-pull -p ${Var_branch_name} ${Var_git_url} master
```
Note the above should submit a patch (via `-p` option used above)
 and pull request to authors/maintainers, who if available, will
 review changes and merge when able. If you wish to share changes
 swiftly then consider forking via GitHub's web interface or via
 `hub` python command line wrapper, and then submitting pull requests
 to your own fork.

## When finished merge changes back to original/master branch
```bash
git checkout master
git merge ${Var_local_branch_name}
```
Note if above generates merge conflicts then attempt `git mergetool`
 if you have already setup a git merge tool default.

## Signoff on merged commit
```bash
git -S -am "Merged local testing branch into master branch"\
 -m "This fixes issue <issue-id> or adds feature <feature-name>"\
 -m "any further details"
```

# Resolving merge conflicts

## Install vimdiff or other diff tools
```bash
## Debian based distributions
sudo apt-get install vim
```

## Setting up `vimdiff` as git mergetool
```bash
git config --add merge.tool vimdiff
git config --add merge.conflictstyle diff3
git config --add mergetool.promp false
```

## Using `vimdiff` as git mergetool
```bash
git mergetool
```

## Layout of `vimdiff`
```
+----------------------------+
| LOCAL  |   BASE   | REMOTE |
+----------------------------+
|           MERGED           |
+----------------------------+
```

## Keyboard navigation short-cuts for `vim`/`vimdiff`
```
Ctrl^w + k 	# Move to upper split
Ctrl^w + h 	# Move to upper left split
Ctrl^w + l 	# Move to upper right split
Ctrl^w + j 	# Move to botom (MERGED) split
Ctrl^w + w 	# Move to next split column (clockwise)
```

## Navigation keyboard short-cuts for `vim`/`vimdiff`
```
]c 		# Jump to next change.
[c 		# Jump to previous change.
```

## Merging short-cuts for `vim`/`vimdiff`
```
:diffg BA 	# Merge BASE into MERGED
:diffg LO 	# Merge LOCAL into MERGED
:diffg RE 	# Merge REMOTE into MERGED
:diffupdate 	# re-scan the files for differences
```

## Copy/paste lines with Vimdiff
```
<shift>+Y 	# Copy line from curser on to buffer
<shift>+P 	# Place/paste line from buffer to curser position
<shift>+D 	# Cut line from curser on to buffer
```

## Diff viewing and copying short-cuts for `vim`/`vimdiff`
```
do 			# diff obtain
dp 			# diff put
zo 			# open folded text
zc 			# close folded text
:set diffopt+=iwhite 	# Turn off whitespace comparison
:set wrap 		# Turn on line wrapping
:syn off 		# Turn off syntax highlighting
zR 			# Unfold ALL lines to see complete files while comparing.
```

## Saving changes
```
:wqa 		# Write All changes and quit
```

## Quiting without changes
```
:cq 		# Cancel and quit
```

## Committing changes
```
## Commit all changes with the same message text.
git commit -S -am "Merge commit text"
```

[General GitHub guide for contributing code](https://guides.github.com/activities/contributing-to-open-source/)

[Source for `hub` command line tool for `git` with GitHub](https://github.com/github/hub)

[Beautiful `git` with `vimdiff` tutorial in markdown format](https://gist.github.com/karenyyng/f19ff75c60f18b4b8149)

[Cheat sheet for `vimdiff` with some good comments](https://gist.github.com/mattratleph/4026987)

[Mergetool `vimdiff` cheat sheat](http://devmartin.com/blog/2014/06/basic-vimdiff-commands-for-git-mergetool/)
