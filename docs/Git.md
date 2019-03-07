# Remote Git Host/Server

**NOTE**: Access to remote repositories is managed via [[ authorized SSH keys | SSH Key Management ]] for the `git` user on the remote host.

## Setup

### Create the Remote Git User

```bash
$ sudo adduser git
```

### Create the Remote Storage Directory

```bash
$ sudo su git
$ cd ~/
$ mkdir repositories
```

### Initialize the Remote Repository

```bash
$ sudo su git
$ cd ~/repositories
$ mkdir project-name.git
$ cd project-name.git
$ git --bare init
$ git config core.sharedrepository 1
$ git config receive.denyNonFastforwards true
$ find objects -type d -exec chmod 02770 {} \;
$ exit
```

## Disable/Enable Shell Git Shell Access

```bash
$ sudo vi /etc/passwd
```
>Change the `git` user's shell from `/bin/bash` to `/usr/bin/git-shell` to disable, vice versa to enable.

# Local Git Client

## Global `.gitignore`

```bash
$ git config --global core.excludesfile '~/.gitignore_global'
```

### Example

```bash
# Vim buffers.
*.swp
*.swo
```

## Project Specific Email Addresses

### Create the Global Alias:

```bash
$ git config --global alias.workprofile 'config user.email "user@work-email.com"'
```

### Use the Alias in Appropriate Projects:

```bash
$ cd project-name
$ git workprofile
```

## Local Repository Management

### Create Local Repository

```bash
$ cd project-name
$ git init
$ git add *
$ git commit -m “initial commit"
```

### Push Local Repository to Remote Host/Server

```bash
$ cd project-name
$ git remote add origin ssh://git@your.domain.name/home/git/repositories/project-name.git
$ git push origin master
```

### Create Branch

```bash
$ cd project-name
$ git checkout -b branch-name
$ git push -u origin branch-name
$ git branch --set-upstream-to=origin/branch-name
```

### Sync Branch with `master`

#### Merging from `master`

```bash
$ cd project-name
$ git fetch --all # Sanity check.
$ git checkout master
$ git pull
$ git checkout branch-name
$ git pull
$ git merge master
$ git push origin branch-name
```

#### Rebasing on `master`

```bash
$ cd project-name
$ git fetch --all # Sanity check.
$ git checkout master
$ git pull
$ git checkout branch-name # The branch you care about.
$ git pull
$ git rebase master
$ git diff # Confirm expected changes, resolve conflicts, etc.
$ git push origin branch-name --force
```

##### A Note on `--force`

Typically, `rebase` is used to groom Git logs so those logs provide a more meainingful history of work on the project. This means that history is typically overwritten on a rebase, which means that a local working copy is going to diverge from the remote. In that case, `--force` is required to overwrite the history on the remote to match the local working copy. This introduces a smaller margin for error, so measure twice and cut once.

### Merging Branch to `master`

```bash
$ cd project-name
$ git fetch --all # Sanity check.
$ git checkout branch-name
$ git pull
$ git checkout master
$ git pull
$ git merge branch-name
$ git push origin master
```

### Branch Cleanup

#### Remove Remote Branch

```bash
$ cd project-name
$ git push --delete origin branch-name
```

#### Remove Local Branch

```bash
$ cd project-name
$ git branch -D branch-name
```

### Remove Files from Repo and History

#### Most Recent Commit

```
$ git rm --cached file_or_dir
$ git commit --amend -CHEAD
$ git push --force
```

#### All Commits

```
$ git filter-branch --tree-filter "rm -rf file_or_dir"
$ git push --force
```
