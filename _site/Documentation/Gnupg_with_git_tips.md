# Verifying signed commits and tags

## Import author's public GPG key

```
gpg --recv-keys 6E4C46DA15B22310
```

## Assign *trust* levels to quite `git`

```
gpg --edit-key 6E4C46DA15B22310
## Within interactive menu
#> trust
## Set number value of trust to key id
#> 5
## Confirm with 'y' then quit with new trust
#> quit
```

### Verify signed commits within `log` (option 1)

```
git log --show-signature --oneline
```

> The above will show the title of each commit as well as the results from
> GnuPG's verification of signatures on each commit. Quick and built in this
> is likely more superior to `(option 2)` bellow.

## Parse commit IDs into variable (option 2)

```
Var_commit_ids=$(git log --oneline | awk '{print $1}')
```

## Verify signed commits

### Example syntax

```
git --verify-commit <commit_id>
```

### Looping though commit IDs

```
for _id in ${Var_commit_ids}; do git --verify-commit ${_id}; done
```

### Looping with some logic

```
for _id in ${Var_commit_ids}; do
    if test "git verify-commit ${_id}"; then
        echo "# Commit ${_id} passed, checking another commit ID now."
    else
        echo "# Failed at commit ${_id}, showing verbose output now."
        ## Do something else such as 'exit 1' instead.
        git verify-commit -v ${_id}
    fi
done
```

## Verifying much the same for signed tags

### Looping through tags

```
Var_tag_ids=$(git tag --list | awk 'print $1')
for _name in ${Var_tag_ids}; do
    if test "git verify-tag ${_name}"; then
        echo "# Tag ${_name} passed, checking another commit ID now."
    else
        echo "# Failed at tag: ${_name}"
    fi
done
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
