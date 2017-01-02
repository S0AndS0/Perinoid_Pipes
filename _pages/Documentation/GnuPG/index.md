---
title: GnuPG
navigation_weight: 5
---

{% include nav_gen.html preview_count=20 preview_dir="_pages/Documentation/GnuPG" %}

### GnuPG installation and configuration

[Gnupg_installation_options.md](Gnupg_installation_options.md)
 Documentation of various options available to non-Linux & Linux based operating
 systems. Note the only platform that this project is known to work on are Linux
 based OSs and the only platform that this project is likely not able to work on
 are IOS based devices.

[Gnupg_configuration.md](Gnupg_configuration.md)
 Documentation of *best practices* configuration of GnuPG, the attached configs
 are very similar to what contributers and authors of this project make use of
 or should make use of. The observent will also find these configs used within
 the [../Script_Helpers/GnuPG_Gen_Key.sh](../Script_Helpers/GnuPG_Gen_Key.sh)
 script which is then used within the build script
 [../.travis-ci/before_script_gen_key.sh](../.travis-ci/before_script_gen_key.sh)
 to enable unattended GnuPG key for this project's auto test builds.

[Gnupg_usefull_commands.md](Gnupg_usefull_commands.md)
 Documentation of daily use command line command for GnuPG; in other words a
 "cheet sheet" for GnuPG.

[Gnupg_key_management.md](Gnupg_key_management.md)
 Documentation of key management command line commands to use with GnuPG. Topics
 covered include; generating new private keys, revocation certificates, signing
 other GnuPG user's public keys, and editing *`trust`* settings for keys.

