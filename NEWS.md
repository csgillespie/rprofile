# Dev
  * Change: Moving to `cli` from `clisymbols`
  * Change: Redo getting wifi name & strength.  Using `nmcli dev wifi` became very slow.
  
# 0.1.4
  * Tweak: Use double quotes for `download.file.extra`. A workaround to an RStudio bug

# 0.1.3
  * Add: `download.file.extra` to default options for RStudio package manager

# 0.1.2
  * Add: `warnPartialMatchArgs`, `scipen`, `HTTPUserAgent` to default options
  
# 0.1.1
  * Bug: No wifi signals no longer returns an error
  * Bug: width passed to options incorrectly
  * Bug: export `lsos()` on startup (not `llsos()`)
  * Tweak: In `cp()` pressing enter now exits the function
  * Tweak: Removing warning when creating a new directory via `op()`
  * Tweak: Normalise paths in `cp()`
  * Add: details on current RStudio project
  * Add: `menu.graphics = FALSE` to `set_options()`
 
# 0.1.0

  * Added a `NEWS.md` file to track changes to the package
  * First version
