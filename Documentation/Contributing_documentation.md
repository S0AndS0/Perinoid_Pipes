# Contributing to documentation

> This file assumes that you've already followed directions found within
> the [Contributing_code_initial_setup.md](Contributing_code_initial_setup.md)
> file. This file contains information specific to how these docs are formatted
> and how new documents should be formatted prior to using `pull-request` or
> `request-pull` commands with `git`. These guidelines are set in place to
> insure that all new and current documents for this project are formatted
> similarly.

## General formatting

> All files within the [`../Documentation/`](../Documentation/) directory
> should have no line other than code blocks that exceed 80 to 90 characters
> or columns. The easiest way to ensure that your additions are within this
> range try `echo "${COLUMNS}"` within your terminal window to check what it's
> current size is set at. Using `vim` and/or `nano` is encouraged when editing
> these documents but so long as your text editor does not mangle new-lines
> and your additions attempt to adhere to the following guidelines then
> singed pull requests are most welcomed.

## Formatting code examples

> Code examples generally should be placed in new-line separated *blocks* of
> text, bellow is an example.

```
# This block of text is easy to select
# and new lines are preserved when
# rendered in client browsers.
```

> The above uses three backticks (```x3) directly before and after a block of
> code. Bellow is above with the backticks exposed and added hashes to insure
> that the markdown rendering does not get confused.

```
#```
## This block of text is easy to select
## and new lines are preserved when
## rendered in client browsers.
#```
```

> Note within blocks of text that reference a line within a code block should
> use single backticks (````) to encapsulate the word or string referenced.
> For example if one where to reference the third line above for some
> informational reason it would look like; `# rendered in client browsers.`
> within a text block.

## Formatting text blocks

> Aside from rare occasions this project uses `>` to prefix the first line of
> a block of text that readers should read and uses blank new-lines to separate
> paragraphs.

For text that should pop-out to readers but not be **bold** then excluding the
 `>` (greater-than) symbol is fine.

> Text blocks that span more that 80 characters/columns in length  should be
> split onto separate lines with the space between words appearing on the next
> line.

Example of above in `raw` format

```
> Text blocks that span more that 80 characters/columns in length  should be
> split onto separate lines with the space between words appearing on the next
> line.
```

## Formatting headings

### Formatting for title of document

First heading should use a single `#` at the beginning of lines

```
# Uses a single `#` at the beginning of lines
```

### Formatting sub-sections

Sub headings should use double `##` at the beginning of lines

```
## Uses double `##` at the beginning of lines
```

And sub-sub headings should use `###` at the beginning of lines

### Uses triple `###` at the beginning of lines

```
### Uses triple `###` at the beginning of lines
```

This pattern should continue to ensure that readers of both `raw` formatted
 text and the markdown formatted text can visually see where in the document
 they are.

## Formatting lists

> There are two options with markdown formatted text, one is to use symbols
> **not** prefixed by two spaces (`  `) such as `  -` or `  +` to prefix
> *bulleted* listed lines, and two is to use numbers `1.`, `2.`, ...
> However, note that to use both simultaneously we'll have to instead use
> spaces prefixing `-` bullets in order to have markdown correctly render.
> Bellow are some examples along with their `raw` formated versions bellow
> each.

### Formatting bulleted lists

- First line
- Second line
- Third line

```
- First line
- Second line
- Third line
```

### Formatting numbered lists (example one)

1. Number one
1. Number two
1. Number three

```
1. Number one
1. Number two
1. Number three
```

### Formatting numbered lists (example two)

2. Number one
3. Number two
1. Number three

```
2. Number one
3. Number two
1. Number three
```

> Markdown rendering should handle *quick'n'dirty* re-ordering of numbered
> lists, but the `raw` formatting exposes that the original order was changed.

### Formatting numbered lists (example three)

1. Number one
  - First line
  - Second line
  - Third line
1. Number two
  - First line
  - Second line
  - Third line
1. Number three
  - First line
  - Second line
  - Third line

> Hint: use two spaces to indent the sublisted items to keep Code Climate
> from generating bug reports on markdown formating.

```
1. Number one
  - First line
  - Second line
  - Third line
1. Number two
  - First line
  - Second line
  - Third line
1. Number three
  - First line
  - Second line
  - Third line
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
