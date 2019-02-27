# General Information on PKI and MFA

  * [Public Key Infrastructure](http://en.wikipedia.org/wiki/Public-key_infrastructure)
  * [Multi-Factor Authentication](http://en.wikipedia.org/wiki/Multi-factor_authentication)

## PKI Do's and Don'ts

  * **DO NOT** write your passphrase in a publicly-readable place.
  * **DO NOT** share your passphrase with anyone.
  * **DO NOT** use a blank passphrase.
  * **DO NOT** write your private key in a publicly-readable place.
  * **DO NOT** share your private key with anyone.
  * **DO** share your _public_ key.

# Local Keys

## Generate a Keypair

```bash
      $ cd ~/.ssh
      $ ssh-keygen -b 4096 -C "your.email.address@domain.tld" -f ./firstname-lastname
```

## Use Private Keys with Non-Default Names

```bash
      $ echo "IdentityFile ~/.ssh/firstname-lastnme" >> ~/.ssh/config
```

## Configure Client for Multiple Keys

### `~/.ssh/config`

```
Host foo.companyname.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/firstname-lastname_companyname

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/default-keyname
  IdentitiesOnly yes
```

## Configure Local SSH Agent

**NOTE**: Be sure that the key is added/configured in the `~/.ssh/config` file!

### Start the SSH Agent

```
$ eval "$(ssh-agent -s)"
```

### Add Key to SSH Agent

```
$ ssh-add -K ~/.ssh/whatever-key-you-want
```

# Remote Keys

## Create List of Authorized Keys

```bash
    $ touch ~/.ssh/authorized_keys
```

## Append New Key to List of Authorized Keys

```bash
    # After scp'ing key and changing key file permissions.
    $ cat ~/key.pub >> ~/.ssh/authorized_keys
    $ rm -f ~/key.pub
```
