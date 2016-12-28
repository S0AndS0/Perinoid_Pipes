# Configuring GnuPG

> Regardless of how GnuPG is installed the following configuration lines should
> be placed within your `gpg.conf` file to conform to *best practices* when
> using PGP encryption tools. Note, email and chat clients will *usually* have
> their own separate `gpg.conf` file under their own related directories; the
> following settings are for GnuPG's main executable and thus any separate
> applications will also require the following edits in addition to their own
> specific customizations.

## Locations of GnuPG configuration files

> Note line with `?` (question marks) surrounding it is indeed questionable.

 Operating System | Location
------------------|-------------
 Linux (`user`)   | `/home/<user>/.gnupg/gpg.conf`
 Mac OSx (`user`) | ? `/home/<user>/.gnupg/gpg.conf` ?
 Windows (`user`) | `C:\Documents and settings\<user>\Application data\gnupg\gpg.rc`

> Note in above table, any Operating System entries that contain `user` should
> have the `<user>` entry modified to your system's user name, and any Operating
> System entries that contain `global` are **system wide** configuration file
> locations. In general it's *safer* to set `user` specific settings because
> updating the executables *usually* includes overwriting `global` settings.

## Best practices (with enhancements) GnuPG config example

```
## Custom settings from the following link
# https://raw.githubusercontent.com/ioerror/duraconf/master/configs/gnupg/gpg.conf
#----------
# Behavior
#----------
## Disable inclusion of the version string in ASCII armored output
no-emit-version
## Disable comment string in clear text signatures and ASCII armored messages
no-comments
## Display long key IDs
keyid-format 0xlong
## List all keys (or the specified ones) along with their fingerprinting
with-fingerprint
## Display the calculate validity of user IDs during key listings
list-options show-uid-validity
verify-options show-uid-validity
## Try to use the GnuPG-Agent. With this option, GnuPG first tries to connect
##  to the agent before it asks for a passphrase
use-agent
#-----------
# Keyserver
#-----------
## Server that --recv-keys, --send-keys, and --search-keys will communicate
##  with to receive keys from, send keys to, and search for keys
keyserver hkp://keys.gnupg.net
## Comment above and uncomment bellow keyserver and keyserver-options for better
##  privacy when updating or searching keys.
#keyserver hkps://hkps.pool.sks-keyservers.net
## Provide a certificate store to override the system default
## Get this from https://sks-keyservers.net/sks-keyservers.netCA.pem
#keyserver-options ca-cert=/path/to/downloaded.pem
## Do not leak DNS, see https://trac.torproject.org/projects/tor/ticket/2846
keyserver-options no-try-dns-srv
## When searching for a key with --search-keys, include keys that are marked on
##  the keyserver as revoked
keyserver-options include-revoked
#-----------------------
# Algorithm and ciphers
#-----------------------
## List of personal digest preferences. When multiple digests are supported
##  by all recipients, choose the strongest one
personal-cipher-preferences AES256 AES192 AES CAST5
## List of personal digest preferences. When multiple ciphers are supported by
##  all recipients, choose the strongest one
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
## Message digest algorithm used when signing a key
cert-digest-algo SHA512
## This preference list is used for new keys and becomes the default for
##  'setpref' in the edit menu
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
```

> Note the above config file may be substantially shorten on `bash` enabled
> devices via the following command which *strips* out the comments added by
> this document's authors.

```
Var_gpg_config_location="${HOME}/.gnupg/gpg.conf"
grep -vE '##' ${Var_gpg_config_location} | tee ${Var_gpg_config_location}
```

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
