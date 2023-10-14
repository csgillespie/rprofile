# rprofile.setup 0.2.0 _2023-07-19_
  * feat: Rename package as there is now an {rprofile} package on CRAN
  * refactor: `get_r_sessions()` remove `greps` using `str_detect()`
  * refactor: `stripspace()` only update if the file has changed

# rprofile 0.1.14 _2023-07-19_
  * refactor: Remove importFrom where possible
  * feat: Use tibbles for lsos

# rprofile 0.1.13 _2023-06-05_
  * fix: Use prompts from {prompt} to avoid odd terminal resizing.

# rprofile 0.1.12 _2022-11-08_
  * Add `stripspace()` function for cleaning files
  * Remove `check.bounds` option - too noisy

# rprofile 0.1.11 _2022-11-07_
  * Set `setWidthOnResize=TRUE` in options
  * Truncate long branch names
  * Set `check.bounds` in options
  * Set `warnPartialMatchAttr` in options

# rprofile 0.1.10 _2021-06-13_
  * Use `suppressMessages()` to silence `prettycode::prettycode()` - fixes #10

# rprofile 0.1.9 _2021-05-24_
  * Add: MacOS startup messages (taken from @emraher's fork)

# rprofile 0.1.8 _2021-05-11_
  * Calculate the optimal terminal width using `cli::console_width()`.
  * Add a line break when on an R Linux terminal. This (sort of) fixes the
  issues with counting Unicode characters.
  * Allow prompts to be passed in `set_terminal()`. Fixes #6

# rprofile 0.1.7 _2020-09-17_
  * Update: New R projs path (fixes #4)
  * Tweak: Improved feedback from `library()` function

# rprofile 0.1.5 _2020-09-01_
  * Add: Detect Windows wifi (taken from @blakcjack's fork)
  * Change: Moving to `cli` from `clisymbols`
  * Change: Redo getting wifi name & strength.  Using `nmcli dev wifi` became very slow.

# rprofile 0.1.4
  * Tweak: Use double quotes for `download.file.extra`. A workaround to an RStudio bug

# rprofile 0.1.3
  * Add: `download.file.extra` to default options for RStudio package manager

# rprofile 0.1.2
  * Add: `warnPartialMatchArgs`, `scipen`, `HTTPUserAgent` to default options

# rprofile 0.1.1
  * Bug: No wifi signals no longer returns an error
  * Bug: width passed to options incorrectly
  * Bug: export `lsos()` on startup (not `llsos()`)
  * Tweak: In `cp()` pressing enter now exits the function
  * Tweak: Removing warning when creating a new directory via `op()`
  * Tweak: Normalise paths in `cp()`
  * Add: details on current RStudio project
  * Add: `menu.graphics = FALSE` to `set_options()`

# rprofile 0.1.0
  * Added a `NEWS.md` file to track changes to the package
  * First version
