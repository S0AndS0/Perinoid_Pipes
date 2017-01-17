___
title: Setting up Jekyll gh-pages
___

## Install dependancies

```
sudo apt-get install ruby-full git nodejs libgemplugin-ruby
```

> Download a local copy of this project under a non-sudo account

```
## Add non-sudo user and login to it
adduser <user-name>
login <user-name>
## Make a directory for GitHub downloads
mkdir gh-clones
cd gh-clones
## Download project source code and switch to project root directory
git clone https://github.com/S0AndS0/Perinoid_Pipes
cd Perinoid_Pipes
## List all branches, including remote branches not currently tracked
git branch -a
## Download and beguin tracking available remote branches
git checkout --track origin/gh-pages
git checkout --track origin/testing
git checkout master
## List availabe project git branches
git branch --list
```

> Note the following function maybe used to setup local tracking of remote
> branches for nearly any git based project.

```
Func_git_track_remotes(){
	git branch -r | grep -v '\->'| awk '{print $1}' | while read _remote_branch; do
		git checkout --track ${_remote_branch}
	done
}
```

> Checkout the `gh-pages` branch

```
git checkout gh-pages
```

> Install Jekyll via one of the two following options

```
# Install jekyll and bundler with gem
gem install jekyll bundler
```

> Note for multi-user enviroments. As suggested on
> [Stackoverflow.com](https://stackoverflow.com/a/18294746)
> one can also install gems for spicific users via the following

```
gem install --user-install jekyll bundler
```

> `bundler` user only install tricks from: [Stackoverflow.com](https://stackoverflow.com/a/3171435)

```
bundle install --path $HOME/.gem
```

## Warning of above

> Using user installation will pop warnings that `${HOME}/.gem/ruby/<version>/bin`
> does **not** exsist within the `PATH` variable... below is a posible solution

```
Old_PATH="${PATH}"
PATH="${PATH}:${HOME}/.gem/ruby/2.3.0/bin"
```

> Note if you *f'up* your `PATH` variable then restore it with the `Old_PATH`
> variable set in first line of posible workaround.

> Provided the above works, one can save this to the current user's `.bashrc` file
> via the following command so that any future shell logins under this user has
> the path automaticly appended to.

echo 'export PATH="${PATH}:${HOME}/.gem/ruby/2.3.0/bin"' >> ~/.bashrc

## Install any repo specifide dependancies

```
bundle install
# Or
bundle install --path ${HOME}/.gem
```

> Note future builds usually will only need `bundle update` if installed for
> all users and future builds for user only install will have to continue using
> the `--path` command line option to update software dependancies.

## Make some changes

> In this example we'll add production enviroment variable detection following
> instructions found at [`https://desiredpersona.com/google-analytics-jekyll/`](https://desiredpersona.com/google-analytics-jekyll/),
> however with modifications. Instead of anaylitics selective build support
> authors have selectivly disabled download rendering on local builds to avoid
> pounding GitHub API servers with erronious connections.

```
        <section id="downloads">
          {% if jekyll_environment == 'production' %}
            {% if site.show_downloads %}
              <a href="{{ site.github.zip_url }}" class="btn">Download as .zip</a>
              <a href="{{ site.github.tar_url }}" class="btn">Download as .tar.gz</a>
            {% endif %}
          {% endif %}
          <a href="{{ site.github.repository_url }}" class="btn btn-github"><span class="icon"></span>View on GitHub</a>
        </section>
```

## Serving/building local builds of documentation site

- To build only, without serving

```
bundle exec jekyll build
```

- To serve localy run

```
bundle exec jekyll serve
```

- To serve localy with auto-rebuild on changes

```
bundle exec jekyll serve --watch
```

- To serve localy with auto-rebuild on only changed files

```
bundle exec jekyll serve --watch --incremental
```

## Commiting changes

- Run the following to commit changes to branch 

```
git commit --branch -S -am "<message>"
```

