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
      $ ssh-keygen -C "your.email.address@domain.tld" -f ./firstname-lastname
```

## Use Private Keys with Non-Default Names

```bash
      $ echo "IdentityFile ~/.ssh/firstname-lastnme" >> ~/.ssh/config
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
