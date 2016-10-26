# Initial `git` setup

> skip any steps that have been completed for other code contributions and
> set as a global setting within your user's `~/.gitconfig` file. Note you may
> also try [../Script_Helpers/Contributing_initial_setup.sh](../Script_Helpers/Contributing_initial_setup.sh)
> script for setting up GnuPG & Git settings.

## Setup GPG public key with GitHub

```
Var_gpg_email='email@host.domain'
Var_git_signing_fingerprint=$(gpg --list-keys ${Var_gpg_email})
Var_trim_gpg_fingerprint=$(awk '/fingerprint/{print $10""$11""$12""$13}' <<<"${Var_git_signing_fingerprint}")
## Above variables are for grabbing the last 16 bits of your fingerprint.
git config --global user.signingkey ${Var_git_signing_fingerprint}
```

> The associated public key should be uploaded to GitHub under your own user
> profile which is very well documented by
> [GitHub's guide - adding a new gpg key](https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/)

## Export GPG public key command example

```
## To terminal
gpg --armor --export ${Var_gpg_email}
## or to file
gpg --armor --export ${Var_gpg_email} --output ~/${Var_gpg_email%@*}.gpg
```

> In either of above options for exporting your key you will want to copy &
> paste it into the required text input field on GitHub and save the account
> changes.

### Git commits may now be signed via the following method

```
git commit -S -m "Message title/synopsis"\
 -m "Detailed message" modified/file/path
```

Note it is the `-S` command line option that tells git to sign commits, the above
 should request your GPG private key's passphrase for unlocking that key prior
 to signing your commit. This will be much the same for other signing procedures
 for this project, however, note that for signing tages `-s` (lower-case) should
 be used instead; everything else seems to use an uper-case `S` for signing.

## Adding SSH public key to GitHub

```
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
> your GitHub account name defined by `-f` (file name) to keep things organized
> and avoid errors. Additional note, the above will request a passphrase be made,
> if you set one up, this passphrase will be the one required to authenticate
> via ssh to git and not the account password setup via their web site.

### Add git client `ssh_config` settings configuration block

```
cat >> /etc/ssh/ssh_config <<EOF
host github.com
    HostName github.com
    User git
    IdentitiesOnly yes
    IdentityFile ~/.ssh/GithubUser
EOF
```

> Note if you wish to setup specific keys for projects then
> [jexchan has written a fantastic gist](https://gist.github.com/jexchan/2351996)
> on the subject of multi-key management. Additional note the only setting from
> above that needs editing for normal ssh git operations is the `IdentityFile`
> location. When `git` commands interact with remote servers you will be
> prompted for the passphrase setup to protect your ssh keys and not the GitHub
> web password.

## Downloading source via ssh link

```
git clone git@github.com:S0AndS0/Perinoid_Pipes.git
cd Perinoid_Pipes
```

> Note from here on the following commands will be from the prospective of
> the above code repository directory.

## Adding GitHub username and email to git config

```
git config --add user.name ${Var_git_user}
git config --add user.email ${Var_git_email}
```

> Note the above maybe set global for the currently logged in local user by
> adding `--global`, in which case configurations will be save in the
> `~/.gitconfig` file instead of `.git/config` within the project's path.

## Adding issues, pull & merge requests to local checkout of git repo

```
git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
git config --add remote.origin.fetch '+refs/pull/*/merge:refs/remotes/origin/pr/*/merge'
```

> Note the above maybe set globally by adding `--global` prior to `--add`
> option for making git able to grab any code repository's

## Fetch everything not currently downloaded

```
git fetch --all
```

> Note new remote branches maybe checked out via `remote/branch` if any are
> available. List available branches with `git branch --list -vv`

## Add contact info, changes info, and if so desired "tips" info

```
Var_gpg_fingerprint=$(gpg --fingerprint --keyid-format long ${Var_gpg_email} | awk '/pub/{print $2}')
cat >> Documentation/Contributing_code_credits.md <<EOF
${Var_git_user} - ${Var_gpg_fingerprint#*/}
        By signing changes made to this document with private key related to
        above public key fingerprint the user name above signs acceptance that
        pull requests and change submitting made under the above user name to
        this project will become licensed under the licensing agreements found
        in the Documentation directory of this project that most closely
        matches the changes made; ie code under code licensing and
        documentation under doc-centric licensing.
    Summery: <Working on feature/Fixing bug or issue>
    Support code contribution link(s): <your_BTC_address>
EOF
```

> Note you will want to edit fields between `<` and `>` to reflect your
> information. Additional note, if you add your info and sign commits with the
> related GPG key then authors of this project will treat this as an acceptance
> to including your code within the main/master code branch under the same
> license as it operates under currently. In short this acts as a "waiver" of
> your legal claim/obligation to contributed work at the same levels as original
> authors such that this project's authors and future users may make use of your
> contributions without fear of violating licensing agreements already outlined
> in this project's `Licenses/` directory.
> In future pull requests and mergers you may excluded repeating the waver and
> instead just focus on being concise with updating `Summery:` & `Support code
> contribution link(s):` fields if they need updating. Otherwise sign commits
> and other `git` activities with reasonably descriptive messages.

## Example of author's contact info writing steps

```
cat >> Documentation/Contributing_code_credits.md <<EOF
S0AndS0 - 6E4C46DA15B22310
        By signing changes made to this document with private key related to
        above public key fingerprint the user name above signs acceptance that
        pull requests and change submitting made under the above user name to
        this project will become licensed under the licensing agreements found
        in the Documentation directory of this project that most closely
        matches the changes made; ie code under code licensing and
        documentation under doc-centric licensing.
    Summery: Working on features & fixing any bugs that can be fixed.
    Support code contribution link(s):
        Found in "Title page" section of Documentation/ReadMe_Paranoid_Pipes.md
        file, thus not repeated here to avoid having to many files to keep updated.
EOF
```

## Sign commit of changes to `Documentation/Contributing_code_credits.md` file

```
git commit -S -m "Signed changes to Contributing_code_credits.md" Documentation/Contributing_code_credits.md
```

## Import project author's public key

```
Var_author_keyid='6E4C46DA15B22310'
gpg --search-keys ${Var_author_keyid}
```

> The above should result in presenting you with the author's key to import
> this public key can also be found at [Keybase.io](https://keybase.io/s0ands0)
> for verification that your `gpg` key servers are presenting you with the
> correct key.

### Assign a *trust* level for this new key

```
gpg --edit-keys ${Var_author_keyid}
```

> The above will open an interactive menu for editing the above key ID, use
> `trust` to open the options for assigning a trust level, then `quit` to exit
> and save changes.

Next read up on [Contributing_code_maintenance.md](Contributing_code_maintenance.md)
 documentation for the development steps that will be repeated per pull request.
 Then glance at [Contributing_code_merge_conflicts.md](Contributing_code_merge_conflicts.md)
 documentation for instructions on how to resolve local merge conflicts on the
 off chance that those arise.

## Licensing notice for this file

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
