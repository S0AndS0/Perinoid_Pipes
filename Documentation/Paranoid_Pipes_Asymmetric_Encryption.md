# Linux Asymmetric Log Encryption

 > The core ideals held within this script's design are; your data should be
 yours and only those you have authorized to access it should be allowed access,
 your data should be unreadable to those that gain unauthorized access. The
 authors of this project believe that though customized usage of this script,
 users that share these ideals may achieve great control over their data access
 rights. Currently this is achieved using some Bash magics with `mkfifo`, and
 via GnuPG's public/private key pare encryption methods; though with a little
 modification it appears this project maybe capable of sending data through
 other encryption software such as OpenSSL. In short while much has been
 finished and now works, there is still much more that could be done to improve
 and/or increase this project's capabilities.

 > Encryption of arbitrary data or files is a common enough request that this
 tool was developed. This is not a partition encryption solution (often LUKS
 partitions are the *goto* for such Kernel level supported encryption where a
 file system can be mounted, read, and written to) instead this is a method of
 file by file and/or line by line asymmetric encryption at the host OS's
 software layer.

 > Because of the differences in kernel vs software implementation of
 encryption, the authors of this project feel it is worth warning users that
 there is some risk for leakage of data destined for encryption. Often this
 data can be found in the form of system logs or shell history files showing
 the interactions between a program or user and another program, ie
 `tail -n4 ~/.bash_history`

## Bash's history file output example

```
cd /some/file/path
gpg -r emailuser@host.domain -e some_file -o /tmp/some_file.gpg
echo 'Email body about attached file' | mutt -s 'Subject of encrypted files attached' -a /tmp/some_file.gpg
clear
```

 > Known as metadata this amount of information leakage may, or may not, be
 acceptable depending upon your own perceived threat modal, your system
 permission, and physical access levels on the target server. Some logging of
 interactions may not be preventable.

 > For this script's process ID both running in the background or foreground
 the authors have selected to turn off Bash history but have not gone any
 further to protect users from system logging services. User may mitigate
 logging metadata further by setting up custom templates or filters for their
 logging daemon's configuration, however, this topic is better suited for other
 documentation; hint `man <logging-daemon>` may yield exceptional information
 on how to selectively not log this script's actions... Though that maybe a
 very bad idea, instead consider turning down the verbosity of your logging
 service for this script's tasks until assured that you're not leaking data
 destined for encryption.

 > Hint: for both log daemon auditing (and auditing of the script) see section
 'CLO Manual and documentation' within this document for listing of every Bash
 built-in command & external program called listed without repeats.

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
