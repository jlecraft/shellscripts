# shellscripts

A collection of small, dependency-free bash scripts.

## rename_sanitize.sh

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
rename_sanitize.sh [-n] [--space-char CHAR] [directory]
```

- `-n` — dry run: print `old -> new` for every planned rename without
  renaming anything.
- `--space-char CHAR` (or `--space-char=CHAR`) — character to use in place
  of spaces. Must be a single character. Defaults to `_`.
- `directory` — directory to operate on. Defaults to the current directory.

### Examples

Preview changes in the current directory:

```
./rename_sanitize.sh -n
```

Rename files in `~/Music/remix`, using `_` as the separator:

```
./rename_sanitize.sh ~/Music/remix
```

Use `-` instead of `_` as the separator:

```
./rename_sanitize.sh --space-char '-' ~/Music/remix
```

Use `.` instead of `_` as the separator:

```
./rename_sanitize.sh --space-char '.' ~/Music/remix
```

### Example transformation

```
Austin (Boots Stop Workin') (Distant Matter Remix).mp3
  -> Austin_Boots_Stop_Workin_Distant_Matter_Remix.mp3
```
