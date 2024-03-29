## This function is taken from
## https://github.com/jimhester/autoinst/ #nolintr
## The reason for not using the package, is that I had to
## tweak autoinst
## It has now been adapted

available_packages = memoise::memoise(utils::available.packages)

gh_pkg = memoise::memoise(function(pkg) {
  res = jsonlite::fromJSON(paste0("http://rpkg-api.gepuro.net/rpkg?q=", pkg))
  if (length(res) == 0) {
    return(list(pkg_name = "", pkg_org = ""))
  }
  res$pkg_location = res$pkg_name
  res$pkg_org = vapply(strsplit(res$pkg_location, "/"), `[[`, character(1), 1)
  res$pkg_name = vapply(strsplit(res$pkg_location, "/"), `[[`, character(1), 2)
  res[!(res$pkg_org == "cran" |
          res$pkg_org == "Bioconductor-mirror" |
          res$pkg_name %in% available_packages()[, "Package"]), ]
})

get_answer = function(msg, allowed, default) {
  if (!interactive()) {
    return(default)
  }
  repeat {
    cat(msg)
    answer = readLines(n = 1)
    if (answer %in% allowed)
      return(answer)
  }
}

display_matches = function(matches) {
  nums = as.character(seq_along(matches))
  width_nums = max(nchar(nums))
  cat(multicol(paste0(sprintf(paste0("%", width_nums, "s"), nums), "| ", matches)), sep = "")
}

# From gaborcsardi/crayon/R/utils.r
multicol = function(x) {
  xs = x
  max_len = max(nchar(xs))
  to_add = max_len - nchar(xs) + 1
  x = paste0(x, substring(paste0(collapse = "", rep(" ", max_len + 2)), 1, to_add))
  screen_width = getOption("width")
  num_cols = trunc(screen_width / max_len)
  num_rows = ceiling(length(x) / num_cols)
  x = c(x, rep("", num_cols * num_rows - length(x)))
  xm = matrix(x, ncol = num_cols, byrow = TRUE)
  paste0(apply(xm, 1, paste, collapse = ""), "\n")
}

# TODO: use lighter version of install_github
autoinst = function(package, ...) {
  pkg = try(as.character(package), silent = TRUE)
  if (inherits(pkg, "try-error")) {
    pkg = as.character(substitute(package))
  }
  has_loaded = try(base::library(pkg, character.only = TRUE),
                   silent = TRUE)
  if (!inherits(has_loaded, "try-error")) {
    return(invisible(NULL))
  }
  #  pkg = as.character(substitute(package)) # nolint
  cli::cli_alert_info("{pkg} not installed. Trying to install now")
  pkgs = available_packages()
  if (!is.na(pkgs[, "Package"][pkg])) {
    cli::cli_alert_info("Installing {pkg}")
    utils::install.packages(pkg, quiet = TRUE)
    base::library(as.character(substitute(package)), character.only = TRUE)
    cli::cli_alert_success("{pkg} installed and loaded")
    return(invisible(NULL))
  }
  if (is.null(tryCatch(utils::packageVersion("remotes"), error = function(e) NULL))) {
    return(invisible(NULL))
  }
  gh_pkgs = gh_pkg(pkg)
  matches = which(pkg == gh_pkgs$pkg_name)
  if (length(matches) == 0) {
    cli::cli_alert_danger("Package {pkg} does not exist")
    return(invisible(NULL))
  }
  i =
    if (length(matches) == 1) {
      ans = get_answer(
        sprintf("Install '%s'? (Y/N): ", gh_pkgs$pkg_location[matches]),
        c("Y", "N", "y", "n"), "N")
      if (ans %in% c("y", "Y")) {
        "1"
      }
    } else {
      display_matches(gh_pkgs$pkg_location[matches])
      get_answer(
        sprintf("Which package would you like to install? (1-%d, N): ", length(matches)),
        c(as.character(seq(1, length(matches))), "N"), "N")
    }
  if (any(i %in% c("n", "N"))) {
    return()
  }
  remotes::install_github(gh_pkgs$pkg_location[matches[as.integer(i)]])
  base::library(as.character(substitute(package)), character.only = TRUE)
  cli::cli_alert_success("{pkg} installed and loaded")
  return(invisible(NULL))
}
