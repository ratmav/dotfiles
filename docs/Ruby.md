**TODO**: Convert from Ubuntu to Fedora.

# Install

## Install [rbenv](https://github.com/sstephenson/rbenv)

```bash
$ sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
$ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
$ source ~/.bashrc
```

## Install Ruby and Bundler

```bash
$ rbenv install ruby.version-patch
# NOTE: Only use "global" to set the default Ruby version when a ".ruby-version" file is not present.
$ rbenv global ruby.version-patch
# NOTE: Bundler has to be installed for each new Ruby version.
$ gem install bundler --no-ri --no-rdoc
# NOTE: Every time new gems, etc. are installed, "rehash" MUST be called.
$ rbenv rehash
```

## Notes

### Removing All Gems for the Current Ruby Version

```bash
$ for i in `gem list --no-versions`; do gem uninstall -aIx $i; done && gem install bundler
```

### `rbenv` and Binstubs:

Some gems include executable binaries, such as rails, rake, rspec, and pry. If the local environment has multiple versions of gems with executable binaries, Bundler will run the most recent version by default. To use the project-specific version of these gems, call `bundle exec <command>`. As a general rule, call gems using `bundle exec <command>` for all gems **except** for `rails`.

### Changing Ruby Versions:

* `rbenv shell ruby.version.patch` sets the Ruby version for the current terminal session.
* `rbenv local ruby.version.patch` sets the Ruby the Ruby version for the current directory by writing a `.ruby-version` file.
* `rbenv global ruby.version.patch` sets the default Ruby version, which is used when something like the `.ruby-version` file is not present.
* A file named `.ruby_version` stored at project root can be used to automatically set the ruby version. The contents of that file should only be the version number, such as `2.3.0`.
