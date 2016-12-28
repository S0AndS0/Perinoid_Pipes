# Resolving merge conflicts

## Install vimdiff or other diff tools

```
## Debian based distributions
sudo apt-get install vim
```

## Setting up `vimdiff` as git mergetool

```
git config --add merge.tool vimdiff
git config --add merge.conflictstyle diff3
git config --add mergetool.promp false
```

## Using `vimdiff` as git mergetool

```
git mergetool
```

## Layout of `vimdiff`

```
+----------------------------+
| LOCAL  |   BASE   | REMOTE |
+----------------------------+
|           MERGED           |
+----------------------------+
```

## Keyboard navigation short-cuts for `vim`/`vimdiff`

```
Ctrl^w + k        # Move to upper split
Ctrl^w + h        # Move to upper left split
Ctrl^w + l        # Move to upper right split
Ctrl^w + j        # Move to bottom (MERGED) split
Ctrl^w + w        # Move to next split column (clockwise)
```

## Navigation keyboard short-cuts for `vim`/`vimdiff`

```
]c                # Jump to next change.
[c                # Jump to previous change.
```

## Merging short-cuts for `vim`/`vimdiff`

```
:diffg BA                # Merge BASE into MERGED
:diffg LO                # Merge LOCAL into MERGED
:diffg RE                # Merge REMOTE into MERGED
:diffupdate              # re-scan the files for differences
```

## Copy/paste lines with Vimdiff

```
<shift>+Y                # Copy line from cursor on to buffer
<shift>+P                # Place/paste line from buffer to cursor position
<shift>+D                # Cut line from cursor on to buffer
```

## Diff viewing and copying short-cuts for `vim`/`vimdiff`

```
do                       # diff obtain
dp                       # diff put
zo                       # open folded text
zc                       # close folded text
:set diffopt+=iwhite     # Turn off whitespace comparison
:set wrap                # Turn on line wrapping
:syn off                 # Turn off syntax highlighting
zR                       # Unfold ALL lines to see complete files while comparing.
```

## Searching within file, hint `/` is our friend in `vim`

```
/search_string
```

> Note: entering `/` and then pressing `[up]` arrow key on your keyboard will
> show the last search string input, pressing `[up]` arrow key will continue
> scrolling through the history of previously entered search strings.

## Interactive editing

```
i                        # Insert mode
```

## Exiting interactive editing mode

```
[Esc]                    # Exit insert mode
```

> Note above `[Esc]` literally means pressing your keyboard's escape key.

## Spell checking

- Option 1; spell checking for US region English for all documents

```
echo 'set spell spelllang=en_us' | tee -a ~/.vimrc
```

- Option 2; spell checking from within vim edit session

```
:setlocal spell spelllang=en_us
```

> Note `Option 1` writes to your current user's `.vimrc` file which unless
> edited becomes a *permanent* `vim` setting for enabling spell checking on any
> document opened by `vim` at a latter time. Where as `Option 2` is a temporary
> setting; only applies within current `vim` session. To turn off spell checking
> temporally within a document editing session use `:set nospell`

## Navigating spell checking short cuts

```
[s                       # Move to previous miss-spelled word.
]s                       # Move to next miss-spelled word.
```

## Selecting auto spell check suggestions

```
z=                       # Open vim menu of numbered suggestions
```

> Above opens an interactive menu, press `[Enter]` to exit the menu without
> changes, or select a number prior to pressing `[Enter]` to select a suggestion
> and replace the miss-spelled word.

## Adding words to `vim` dictionary & marking words as miss-spelled

```
zg                       # Saves selected word as correct for local dictionary.
zw                       # Mark selected word as miss-spelled.
```

## Turn off spell corrections within current `vim` session

```
:set nospell
```

## Saving changes

```
:wqa                     # Write All changes and quit
```

## Quiting without changes

```
:cq                      # Cancel and quit
```

## Committing changes

```
## Commit all changes with the same message text.
git commit -S -am "Merge commit text"
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
