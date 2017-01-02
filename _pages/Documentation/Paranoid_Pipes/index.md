---
title: Paranoid Pipes
navigation_weight: 2
---

{% include nav_gen.html preview_count=20 preview_dir="_pages/Documentation/Paranoid_Pipes" %}

# Paranoid_Pipes.sh spicific documentation

[Paranoid_Pipes_Quick_Start.md](Paranoid_Pipes_Quick_Start.md)
 Documentation on getting this project's main script up and running with test
 data. Note the steps documented are only for testing the features available,
 see `Paranoid_Pipes_CLO.md` for a full list of all known command line options.

[Paranoid_Pipes_CLO.md](Paranoid_Pipes_CLO.md)
 Documentation for all recognized command line options (`CLO`) available to the
 `Paranoid_Pipes.sh` script.

[Paranoid_Pipes_Scenario_One.md](Paranoid_Pipes_Scenario_One.md)
 Documentation for setting up web server logging operations to write to one of
 this project's named pipes for encryption.

[Paranoid_Pipes_Scenario_Two.md](Paranoid_Pipes_Scenario_Two.md)
 Documentation for setting up named pipes for both encryption and decryption on
 the same host but on segregated file systems. Much like `Scenario One` but with
 the requirements that an IDS/IPS system is monitoring plain-text logs for the
 brief time that they're allowed to live on that host.

[Paranoid_Pipes_Scenario_Three.md](Paranoid_Pipes_Scenario_Three.md)
 Documentation for how to setup multiple remote servers with customized script
 copies over `ssh`.

[Paranoid_Pipes_Scenario_Four.md](Paranoid_Pipes_Scenario_Four.md)
 Documentation for how to use Paranoid_Pipes_Scenario_Two.md over `sshfs` mounts.

[Paranoid_Pipes_Warnings.md](Paranoid_Pipes_Warnings.md)
 Contains documentation on all know issues that new and current users of this
 project should be aware of.

[Paranoid_Pipes_Bash_Logics.md](Paranoid_Pipes_Bash_Logics.md)
 Documentation for the internal logics (generalized) of this project's main
 script operations.

[Paranoid_Pipes_External_Applications.md](Paranoid_Pipes_External_Applications.md)
 Documentation for programs that the main script of this project makes use of
 and how they are used.
