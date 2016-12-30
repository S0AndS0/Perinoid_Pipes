---
title: Select GnuPG command line options
---

# GnuPG commands: key management

## Generate new key pair

```
gpg --gen-key
```

> The above will open an interactive session within the terminal and request
> information from the user (you) as to what type of keys are being generated,
> generally an `RSA` pair of `2048` bit length keys is sufficient but many now
> advise upgrading to `4048` bit length keys in the near future.

## Generate revocation cert for new private key

```
gpg --gen-revoke <key_ID> --armor --output <path_to_revoke_cert>
```

> The above will output a file that should be kept **very safe** (print it out
> over a non-networked printer if really paranoid) because if you ever forget
> your passphrase, loose your private key, or have your system compromised and
> keys stolen; this one file allows you to update the key servers around the
> world to the fact that this private and public key can no longer be trusted.

## Generate private key backup

```
gpg --export-secret-keys --armor --output <path_to_secret_keys>
```

> The above command should run during the same procedures as generating a
> revoke cert and treated with as much care. Because anyone with access to this
> key file and your passphrase may assume your identity; keep it **safe**!

## Signing public keys

### Signing a public key locally

```
gpg --lsign-key <key_ID>
```

> Note for above command, you will have to send the updates to the public key
> owner through other networks if using the above instead of the following
> command.

### Signing a public key & publish to key mirroring servers

```
gpg --sign-key <key_ID>
```

> Note for the above command, the public key owner will have to run a key
> update on their own devices to make use of and see your signature added to
> their web of trust.

### Signing a public key via menu interaction

```
gpg --edit-key <key_ID>
```

> Note for the above command, this method allows for either of the above
> options to be used and thus the method of updating the owner's keys will vary.

## Sending signed public keys

### Publish signed pubic key

```
gpg --send-keys <key_ID>
```

> Note for the above command, the above uses key server mirrors to accomplish
> updating another's public key

### Or share signed public key via exported file

```
gpg --armor --export <key_ID> --output <signed_key_file_path>
```

> Note for the above command, this allows for the public key's owner to be
> sent the changes privately over other channels and gives the key owner the
> option to; publish the changes, request a different trust level, or other
> options be changed before allowing the changes to be published.

## Updating local private keys

> Updating your own private/public keys allows for other GnuPG user's
> signatures of trust levels to become present on your system. Additionally
> updating your key chain allows for your system to recognize when someone has
> revoked or updated their own keys. Not updating your key chain can cause all
> sorts of issues, most common is having to resend a message because the
> recipient has lost their keys, or worst case scenario, you end up communicating
> to a stranger that now owns the previously lost private key... bad days have
> been had on those types of issues so update your keys regularly.

### Refresh existing keys in key ring

```
gpg --refresh-keys
```

> The above command should be run every week or two to ensure that revocation
> notices are applied to any missing or stolen keys within your key ring and to
> ensure that new signatures are applied to your own keys.

## Update trust data base

```
gpg --check-trustdb
```

> Once a week to once a month depending upon social activities the above should
> be run to ensure that the GnuPG application is using up to date trust levels.
> Note this is non-interactive, use the next command if you wish to have menus
> and options.

### Or interactively update trust data base

```
gpg --update-trustdb
```

> The above command will open interactive command line menus as request user
> interaction for updating the trust data base.

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
