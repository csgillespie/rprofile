# rprofile 0.1.8 _2021-05-24_
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
