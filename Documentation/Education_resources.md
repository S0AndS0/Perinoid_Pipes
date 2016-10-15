# External links to documentation used within this project

 > Note the bellow links are **not** directly related to the project and serve
 as the author of this project crediting the following authors for having solved
 or documented techniques prior to the publication of this project. In other
 words **do not** bother them because of bugs within this project; instead
 communicate with this project's authors to resolve this project's bugs.

## Security encryption notes

[DSA is broken](https://en.wikipedia.org/wiki/Digital_Signature_Algorithm#Sensitivity) use [RSA](https://en.wikipedia.org/wiki/RSA_(algorithm)) instead.

## Encryption types

There are three main categories of encryption;

[Symmetric or `shared key`](https://en.wikipedia.org/wiki/Symmetric-key_algorithm)
 uses one key (or password) to both encrypt and decrypt data, most commonly
 found on personal computers or web servers for authentication for a given user
 identity. Example use; logging into an Unix like system that has encrypted
 home folders for each user.

[Asymmetric or `public key cryptography`](https://en.wikipedia.org/wiki/Public-key_cryptography)
 uses two (or more keys) that *usually* can only decrypt what their related key
 partner has encrypted; in special use cases there's ways of making keys with
 specific permissions but that's usually only required for very specific threat
 modals or usage scenerios.

[Hybrid or `sharing symmetric key via public key`](https://en.wikipedia.org/wiki/Hybrid_cryptosystem)
 *usually* uses asymmetric encryption to relay a one time (or limited time)
 symmetric key. The symmetric key is then used for the bulk of encryption to
 save time and processing power. This is one of the most common types of
 encryption now deploied readers should at least make an attempt at understanding
 the finer points of this encryption option in order to make the best use of this
 project.

## Links to definitions

 - Wikipedia - [Public key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography)
 - Wikipedia - [Hashing algorithms](https://en.wikipedia.org/wiki/Hash_function)
 - Wikipedia - [Cryptography](https://en.wikipedia.org/wiki/Cryptography)
 - Wikipedia - [Algoririthm](https://en.wikipedia.org/wiki/Algorithm)

[Wiki - Derivative works defined](https://en.wikipedia.org/wiki/Derivative_work)

## Others seeking tools similar to this

 > The authors have now preposed this project as a posible solution or at the very
 least a *band-aid* while the following question posters look for something
 better suited.

 - Security Stack Exchange - [Write only one way encrypted directory](http://security.stackexchange.com/questions/6218/is-there-any-asymmetrically-encrypted-file-system)
 Currently only one tool offered seems to fit their requirements but accepted
 answer doesn't provide solution; just reasons as to why there's no solution.
 - Serverfault - [Asymmetric encrypt server logs that end up with sensitive data written to them](http://serverfault.com/questions/89126/asymmetrically-encrypted-filesystem)
 No solutions posted!
 - Stack Overflow - [Android asymmetric encryption line by line](http://stackoverflow.com/questions/29131427/efficient-asymmetric-log-encryption-in-android/29134101)
 No solutions posted!

## Similar tools & guides

 - Devco - [Guide to asymmetric encryption with OpenSSL](https://www.devco.net/archives/2006/02/13/public_-_private_key_encryption_using_openssl.php)
 Seems pretty snazzy but authors of this script have not tested it yet.

## GnuPG encryption related links

### Links to GnuPG video guides

 - YouTube - [Elliptic curve encryption algorithm overview, by F5 DevCentral 11:29](https://youtu.be/dCvB-mhkT0w)
 - YouTube - [Overview of public/privet key encryption, by Computerphile 6:20](https://youtu.be/GSIDS_lvRv4)
 - YouTube - [Quick explanation of PGP/GPG signing processes, by O Miller 3:54](https://youtu.be/HubAvQg6SPM)
 - YouTube - [In depth series on data encryption and security (part 9 of 12) 28:15](https://youtu.be/IyafQPFxgjU)

### Links to GnuPG written resources

 - RiseUp - [List of **best practices** for GPG/PGP key security and setup](https://riseup.net/en/security/message-security/openpgp/best-practices)
 - Ekaia - [Quick guide on making new or renewing privet PGP/GPG keys](https://ekaia.org/blog/2009/05/10/creating-new-gpgkey/)
 - GnuPG - [GnuGP commonly used command line commands](https://www.gnupg.org/documentation/manuals/gnupg/Operational-GPG-Commands.html)

## Guides for `git`

 > Note to readers; if interested only in the project's code and not how the
 authors maintain it, then skip this section.

 - GitHub - [General GitHub guide for contributing code](https://guides.github.com/activities/contributing-to-open-source/)
 - Git-scm - [Git guide - Signing your work](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
 - GitHub - [Source for `hub` command line tool for `git` with GitHub](https://github.com/github/hub)
 - GitHub - [Beautiful `git` with `vimdiff` tutorial in markdown format](https://gist.github.com/karenyyng/f19ff75c60f18b4b8149)
 - CodeClimate - [Getting started with automated repository checks](https://docs.codeclimate.com/docs/getting-started-configuration)

## Guides for command line text editers `vim`, `vimdiff`, `nano`,...

 - GitHub - [Cheat sheet for `vimdiff` with some good comments](https://gist.github.com/mattratleph/4026987)

[Mergetool `vimdiff` cheat sheat](http://devmartin.com/blog/2014/06/basic-vimdiff-commands-for-git-mergetool/)

- Linux - [Spell checking `vim` tutorial](https://www.linux.com/learn/using-spell-checking-vim)

## Guides for `bash` shell intrupriter

 - Stack Overflow - [Grab last command used on Bash](http://stackoverflow.com/a/9502698)

 - GitHub - [Methods of generating random strings of specified length](https://gist.github.com/earthgecko/3089509)

## Guides for web servers

 - Nginx - [log rotation documentation](https://www.nginx.com/resources/wiki/start/topics/examples/logrotation/)
 - Apache - [log rotation documentation](https://httpd.apache.org/docs/2.4/programs/rotatelogs.html)

## Guides for logging daemons

 - Stack Exchange - [Rsyslog to fifo answered](http://unix.stackexchange.com/questions/134896/how-to-redirect-logs-to-a-fifo-device)

## Guides for remote adminastration

 - Server Fault - [Run local script over SSH to remote](http://serverfault.com/a/595256)

# Licensing notice for this file

 > ```
    Copyright (C) 2016 S0AndS0.
    Permission is granted to copy, distribute and/or modify this document under
    the terms of the GNU Free Documentation License, Version 1.3 published by
    the Free Software Foundation; with the Invariant Sections being
    "Title page". A copy of the license is included in the directory entitled
    "License".
```

[Link to title page](Contributing_Financially.md)

[Link to related license](../Licenses/GNU_FDLv1.3_Documentation.md)
