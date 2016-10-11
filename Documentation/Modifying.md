 > What follows are instructions on how to make modifications to the source
 code without making git refuse to download updates and how to incorporate
 update into your modified branch.

## Change directories to the downloaded project source code root directory

```bash
cd ~/Downloads/Paranoid_Pipes
```

### Pick a name to call your testing branch

```bash
Var_branch_name="${USER}_mod"
git checkout -b ${Var_branch_name}
```

 > Changes can now be made within this custom branch without effecting the
 original master branch.

### Delete custom branch if modifications are not wanted

```bash
git checkout master
git branch -D ${Var_branch_name}
```

 > Be very certain that you no longer want the above branches changes before
 deleting your custom branch.

### Modify freely and update your branch occasionally via the following

```bash
cd ~/Downloads/Paranoid_Pipes
## Download available changes from remote
git fetch
## Merge downloaded changes into custom (current) branch
git merge master
```

 > See [Contributing_merge_conflicts.md](Documentation/Contributing_merge_conflicts.md)
 for how to resolve merge conflicts if errors arise from above and for how to
 contribute your modifications back to the main project for consideration to
 include in main project see [Contributing.md](Documentation/Contributing.md)
 file for `git` setup required.

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
