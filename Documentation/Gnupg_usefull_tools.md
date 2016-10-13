# GnuPG tools

 > There are many interesting tools available for GPG, the more note worthy will
 be spotlighted bellow but their usefulness will depend upon you personal usage
 requirements. These following external projects should **not** be bothered by
 bugs found within this project and are only included to present you (the reader)
 with alternative projects making use of GnuPG's libraries.

 1. [Mnfst.io](https://mnfst.io/)

 > Above is Open Source and hosted on [GitHub](https://github.com/mnfst) with
 three tools available for GPG users. The first
 [mnfst](https://github.com/mnfst/mnfst) is the server's source code which maybe
 used under their licensing terms for hosting your own versions, second tool
 available [mnfstfwd](https://github.com/mnfst/mnfstfwd) allows for posting to
 a server via signed emails, and the third tool available
 [mkmnfst](https://github.com/mnfst/mkmnfst) is the basic client application for
 posting signed messages to a server.

 > The third tool is the one most clients will wish to setup so here's the
 instructions for Linux based operating systems.

```bash
cd ~/Downloads
git clone https://github.com/mnfst/mkmnfst
cd mkmnfst
./autogen.sh
./configure
make
```

 2. [Simple Secure](https://wordpress.org/plugins/simplesecure/screenshots/)

 > Wordpress plugin contact form, uses domain's public key to encrypt messages
 to the site's maintainers. If you're running a Wordpress server and want
 clients or customers to *feel* more secure about sending you messages then
 consider this plugin's incorporation within your site's code. Check the plugin
 author's video [Install guide](https://youtu.be/FFxFevczuRg) which also covers
 installing GnuPG on Mac. Note do **not** store the primary private key on the
 same devices as the Wordpress server! If your Wordpress server is ever
 compromised there should only be a public key on that host. Aside from the
 previous warning, this plugin is a secure way to allow visitors of a Wordpress
 server to communicate securely with the administrator or sales teams.

 3. [OpenPGP-PHP](https://github.com/singpolyma/openpgp-php)

 > For general web server integration the above has been developed and is useful
 for allowing servers to communicate back with customers or clients over GPG
 encrypted messages or emails. The above tool has been incorporated within
 [Drupal - OpenPGP]( https://www.drupal.org/project/openpgp) and
 [Wordpress - WP-PGP-Encrypted-Emails](https://wordpress.org/plugins/wp-pgp-encrypted-emails/)
 plugins which server as solid examples of how your web server developers may
 incorporated the OpenPGP-PHP tool within your existing hosting software. Note
 though that your dev-team will want to ensure that input and output is
 sanitized whenever using PHP scripts on a web server!

 4. [GnuPG for Java](https://github.com/guardianproject/gnupg-for-java)

 > For general embedded applications the above is available from the same
 developers as GnuPG for Android that maybe used as a back-end/library for
 browser or mobile applications.

 5. [BouncyCastle](http://www.bouncycastle.org/documentation.html)

 > An alternative to GnuPG for Java is implementation who also maintains a C#
 back-end for GnuPG. A clear guid for this implementation of GnuPG for Java
 back-end can be found on [Stackoverflow](http://stackoverflow.com/a/16962723)
 if truly interested in how to make an application that incorporates the above
 tool. Note this is the back-end that is used for the Openkeychain Android
 application and seems to work very well; well as far as the authors of this
 document have tested it.

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
