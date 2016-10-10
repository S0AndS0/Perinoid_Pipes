# Verifing signed commits and tags

## Import author's public GPG key
```bash
gpg --recv-keys 6E4C46DA15B22310
```

## Parse commit IDs into variable
```bash
Var_commit_ids=$(git log --oneline | awk '{print $1}')
```

## Verify signed commits

### Example syntax
```bash
git --verify-commit <commit_id>
```

### Looping though commit IDs
```bash
for _id in ${Var_commit_ids}; do git --verify-commit ${_id}; done
```

### Looping with some logic
```bash
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

## Verfying much the same for signed tags

### Looping through tags
```bash
Var_tag_ids=$(git tag --list | awk 'print $1')
for _name in ${Var_tag_ids}; do
	if test "git verify-tag ${_name}"; then
		echo "# Tag ${_name} passed, checking another commit ID now."
	else
		echo "# Failed at tag: ${_name}"
	fi
done
```
