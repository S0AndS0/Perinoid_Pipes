# Useful GnuPG command line commands list

> There are plenty of advanced command line tricks that can be done with
> GnuPG, the following list of common commands are ordered by least to more
> advanced commands.

## GnuPG commands (daily use)

### Search for a key by email

> note if found GnuPG will prompt you on if you wish to import the key

```
gpg --search-keys <email_or_pub_finger_print>
```

### Import a key from file instead

> note if importing a private key then the public key is automatically
> regenerated.

```
gpg --import <pub_or_private_key_file>
```

### Encrypt a file to one or more recipients

```
gpg --armor --encrypt <unencrypted_input_file> --recipient <email_or_pubKeyID> --output <encrypted_output_file>
```

> Replace `<email_or_pubKeyID>` with the email address or key ID to whom that
> the `<unencrypted_input_file>` will be encrypted to, note multiple
> `--recipient` arguments maybe passed at this time and this is useful if you
> have multiple people to encrypt a file to. The `<encrypted_output_file>`
> should be a new file path/name to save GnuPG's output to. Once saved the
> output file maybe sent over any network to the recipients, ie over email,
> without having to trust the network or it's servers.

### Encrypt a file to one or more recipients & embed a signature

> This allows the message to be tracked back to your key ID

```
gpg --armor --encrypt <unencrypted_input_file> --recipient <email_or_pubKeyID> --clearsign --output <encrypted_output_file>
```

> The `--clearsign` option above will allow any recipient to mathematically
> link the file's contents with your key ID. This is very useful if the network
> that the file is transmitted over is untrustworthy because any changes to the
> file will cause GnuPG to through errors and warnings that the file was
> tampered with.

### Verify a signed file

```
gpg --verify <encrypted_output_file>
```

> Errors about the trustworthiness of the signing key is common output from
> above if you've not signed the sender's public key, really you should be
> looking for if the signature check succeeded or failed. If it failed then the
> file has been tampered with during transit, if the signature check did not
> fail then the file maybe trusted to have been unmodified since signing.

### Decrypt a file

```
gpg --decrypt <encrypted_input_file> --output <decrypted_output_file>
```

> The `<encrypted_input_file>` above will only provide usable output at
> `<decrypted_output_file>` if you are the owner of a private key associated
> with a public key used to encrypt the original file. Passphrase prompts are
> expected when this command is run against a private key that is passphrase
> protected, in other words a private key that is set up properly will need it's
> passphrase to decrypt files.

### Make a detached signature for a file without modifying it

```
gpg --armor --detach-sign <some_legal_file>
```

> The output should be saved to a file with the same name but with an
> additional `.asc` suffix at the end, note if the `--armor` option is removed
> the above will still work but the signature will be in non-ASCII format which
> limits what servers will allow for transit or upload. Send the detached
> signature along with the `<some_legal_file>`, now any recipient can use the
> following example command to verify that the file came from you un-modified
> during transit.

### Verify detached signature

```
gpg --verify <signature_file> <some_legal_file>
```

> The above maybe used by anyone who has access to the public key related to
> the private key used to signed the file. This is very useful when the file
> being transferred cannot be clear signed without corrupting it's data. Note
> the order of files is important in the above command, the signature file must
> come **before** the file to be verified.

## GnuPG example output

### `Good` or passing signature check output from GPG.

```
gpg: Signature made Wed Sep  7 20:06:29 2016 UTC
gpg:                using RSA key 0x2E25E52010AD0E1F
gpg: Good signature from "Michael NA <strangerthanbland@gmail.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: D915 790F 273E 2E8E 786F  0470 6E4C 46DA 15B2 2310
     Subkey fingerprint: 12D6 7DEC 7572 68B6 A30C  C948 2E25 E520 10AD 0E1F
```

### `Bad` or failing signature check output from GPG.

```
gpg: Signature made Wed Sep  7 20:06:29 2016 UTC
gpg:                using RSA key 0x2E25E52010AD0E1F
gpg: BAD signature from "Michael NA <strangerthanbland@gmail.com>" [unknown]
```

> Note on Linux the above exit statuses are `0` for `Good` and `1` for `Bad`,
> ie run `echo "$?"` to view the exit status of the last command or use an
> `if [[ "$?" == "0" ]]; then echo "Good"; else echo "Bad"; fi` statement in
> Bash scripts to trap on bad exit status.

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
