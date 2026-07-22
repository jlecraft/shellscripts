# shellscripts

A collection of small, dependency-free bash scripts.

## Installation

Symlink whichever script(s) you want into a directory on your `$PATH`
(e.g. `~/.local/bin`), so this repo stays the single source of truth:

```
ln -s "$(pwd)/note" ~/.local/bin/note
```

`note`, `journal`, and `dpass` default to storing their data directly
under `$HOME`, so they work out of the box on any machine. To use
different directories on a given machine (without editing the scripts),
export the corresponding variable — e.g. in `~/.bashrc`:

```
export NOTES_DIR="$HOME/Documents/raven"
export JOURNAL_DIR="$HOME/Documents/raven/journal"
export DPASS_WORDLIST="$HOME/Documents/dicepass.txt"
```

## note

Quick numbered note-taking. Notes are stored as `note-NNNNNN.md` in
`NOTES_DIR` (defaults to `$HOME`; export `NOTES_DIR` to override, see
Installation above), with an ever-increasing counter that never resets.

```
note                  Open latest note (or create one) in $EDITOR
note some text        Append text to latest note (or create one)
note -n               Force a new note, open it in $EDITOR
note -n some text     Force a new note, write text into it
note -t some text     Add a timestamp heading, then the text
note -t               Add a timestamp heading, then open in $EDITOR
note -n -t text       Any combination of flags works, in any order
note -- -text         Use -- to write text that itself starts with "-"
note -l | --log       Print the contents of the latest note file
note -l N | --log N   Print the contents of note-NNNNNN.md (e.g. -l 7)
note -s PATTERN       Search all note files for lines matching PATTERN (case-insensitive)
note -h | --help      Show this help
```

## journal

Daily journal entries, one file per day, stored as
`journal-YYYY-MM-DD.md` in `JOURNAL_DIR` (defaults to `$HOME`; export
`JOURNAL_DIR` to override, see Installation above).

```
journal                Open today's journal entry (or create one) in $EDITOR
journal some text      Append "HH:MM: some text" to today's journal entry
journal -- -text       Use -- to write text that itself starts with "-"
journal -s PATTERN     Search all journal files for lines matching PATTERN (case-insensitive)
journal -h | --help    Show this help
```

## dpass

Diceware passphrase generator. Looks up dice-roll keys in a wordlist
(`$HOME/dicepass.txt` by default; export `DPASS_WORDLIST` to override,
see Installation above) and prints the matching words joined by hyphens.

Grab the standard EFF diceware wordlist and save it wherever
`DPASS_WORDLIST` points:

```
curl -o ~/dicepass.txt https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt
```

```
dpass <ARG1> <ARG2> ... <ARG-N>   Look up specific dice keys
dpass -r [N=1]                    Generate N random dice-roll words
dpass -R [N=1]                    Same as -r, plus print the numeric keys
```

## rename_sanitize

Renames files in a directory so that `ls` and other shell commands never
need to quote them. It does this by:

1. Replacing spaces with a separator character (default `_`).
2. Removing any other character that isn't a letter, digit, `.`, `_`, or `-`
   (the POSIX "portable filename character set").
3. Collapsing repeated separator characters into one.
4. Trimming a leading/trailing separator character, if left over.
5. Avoiding overwrites: if the sanitized name already exists, a numeric
   suffix (`_1`, `_2`, ...) is appended before the extension.

Only regular files directly inside the target directory are renamed;
subdirectories are not descended into.

### Usage

```
rename_sanitize [-n] [--space-char CHAR] [directory]
```

- `-n` — dry run: print `old -> new` for every planned rename without
  renaming anything.
- `--space-char CHAR` (or `--space-char=CHAR`) — character to use in place
  of spaces. Must be a single character. Defaults to `_`.
- `directory` — directory to operate on. Defaults to the current directory.

### Examples

Preview changes in the current directory:

```
./rename_sanitize -n
```

Rename files in `~/Music/remix`, using `_` as the separator:

```
./rename_sanitize ~/Music/remix
```

Use `-` instead of `_` as the separator:

```
./rename_sanitize --space-char '-' ~/Music/remix
```

Use `.` instead of `_` as the separator:

```
./rename_sanitize --space-char '.' ~/Music/remix
```

### Example transformation

```
Austin (Boots Stop Workin') (Distant Matter Remix).mp3
  -> Austin_Boots_Stop_Workin_Distant_Matter_Remix.mp3
```
