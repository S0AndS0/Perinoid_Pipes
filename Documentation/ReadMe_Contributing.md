# Initial `git` setup, skip any that have been completed for other code contributions.

## Setup GPG public key with GitHub
```bash
Var_gpg_email='email@host.domain'
Var_signing_fingerprint=$(gpg --list-keys ${Var_gpg_email} | awk '/fingerprint/{print $10""$11""$12""$13}')
## Above variables are for grabbing the last 16 bits of your fingerprint.
git config --global user.signingkey ${Var_signing_fingerprint}
```
Note, the public key should be uploaded to GitHub under your user profile
 which is very well documented by [GitHub's guide - adding a new gpg key](https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/)

### Export GPG public key.
```bash
## To terminal
gpg --armor --export ${Var_gpg_email}
## or to file
gpg --armor --export ${Var_gpg_email} --output ~/${Var_gpg_email%@*}.gpg
```
Note in either option for exporting your key you will want to copy & paste it
 into the required text input feild on GitHub and save the account changes.

### Commits may now be signed via the following method
```bash
git commit -S -m "Message title/synopsis" -m "Detailed message"
```
Note it is the `-S` command line option that tells git sign commits, the
 above should request your GPG private key's passphrase for unlocking
 that key.

## Adding SSH public key to GitHub
```bash
mkdir -p ~/.ssh
cd ~/.ssh
## Generate new key pair
ssh-keygen -t rsa -b 4096 -C "email@host.domain" -f "GithubUser"
```
Note the `-C` (ssh key comment) should match the same email account as used by GitHub
 account name defined by `-f` (file name) to keep things organized and avoid errors.
 Additional note, the above will request a passphrase be made, if you set one up, this
 passphrase will be the one required to authenticate via ssh to git and not the account
 password setup via their web site.

### Add configuration block to `ssh_config` settings
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
 on the subject of multi-key management. Additional note the only setting from
 above that needs editing for normal ssh git operations is the `IdentityFile`
 location.

## Download source via ssh link
```bash
git clone git@github.com:S0AndS0/Perinoid_Pipes.git
cd Perinoid_Pipes
```
Note from here on the following commands will be from
 the prospective of the above code repository directory.

## Add contact info, changes info, and if so desired "tips" info
```bash
cat >> Contribution_Credits.md <<EOF
[<GitHub_Username>] - <GPG_Fingerprint>
    Summery: <Added feature/Fixed bug or issue>
    Support code contribution link: <your_BTC_address>
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

## Sign changes to `Contribution_Credits.md` file
```bash
git commit -S -m "Signed changes to Contribution_Credits.md" Contribution_Credits.md
```

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
vim ReadMe_Perinoid_Pipes.md
# Or nano
nano Perinoid_Pipes.sh
```
Note examples include `vim` & `nano` but whatever text editor
 that you prefer that also doesn't mangle end of line or other
 special characters should be fine

## Sign committed changes, including branch name is optional
```bash
git commit --branch -S -am "Added feature or fixed bug" -m "Summery of changes"
```

## After testing and committing share fixes or features via pull request
```bash
Var_branch_name=$(git branch --list | awk '/\*/{print $2}')
git request-pull -p ${Var_branch_name} <fork-url> master
```

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

# Sources of further information

[General GitHub guide for contributing code](https://guides.github.com/activities/contributing-to-open-source/)

[Source for `hub` command line tool for `git` with GitHub](https://github.com/github/hub)
