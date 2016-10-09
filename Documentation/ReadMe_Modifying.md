 > What follows are instructions on how to make modifications to the source
 code without making git refuse to download updates and how to incorperate
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

### Modify freely and update your branch accasonally via the following
```bash
cd ~/Downloads/Paranoid_Pipes
## Download availabe changes from remote
git fetch
## Merge downloaded changes into custom (current) branch
git merge master
```

 > See [ReadMe_Contributing](Documentation/ReadMe_Contributing.md) for how to
 resolve merge conflicts if errors arise from above and how to contribute your
 modifications back to the main project for consideration to include in main project.
