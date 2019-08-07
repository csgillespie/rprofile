ip = function(path = getwd()) {
  rstudioapi::initializeProject(path)
  op(path)
}

#' @export
op = function(path = ".") {
  path = normalizePath(path)
  proj = list.files(path, pattern = "\\.Rproj$")
  if (grepl("\\.Rproj$", path)) {
    setwd(dirname(path))
    rstudioapi::openProject(path)
  } else  if (length(proj) == 0L) {
    message("No available project.")
    create_project = readline(prompt = "Create (y/N): ")
    if (tolower(create_project) == "y") {
      ip(path)
    }
  } else {
    setwd(path)
    rstudioapi::openProject(proj)
  }
}

#' @export
cp = function(path = NULL) {
  if (!is.null(path)) {
    op(path)
    return(invisible(NULL))
  }
  projs_paths = readLines("~/.rstudio-desktop/monitored/lists/project_mru") #nolint
  projs_paths = c(getwd(),
                  projs_paths[file.exists(projs_paths)][1:9])
  projs_paths = projs_paths[!is.na(projs_paths)]

  ## Get project name
  projs = gsub(basename(projs_paths), pattern = ".Rproj", replacement = "")
  projs[1] = "Current dir"
  projs = paste0(crayon::bold(seq_along(projs) - 1), ". ", crayon::cyan(projs))
  projs[1] = paste0(" ", projs[1])

  ## Get project directory
  projs_dir = dirname(projs_paths)
  tilde = path.expand("~")
  projs_dir = stringr::str_replace(projs_dir, tilde, "~")

  path_split = stringr::str_split(projs_dir, pattern = "/")
  path_lens = unlist(lapply(path_split, length))
  path_start = path_lens - 2
  path_start = pmax(path_start, 0)

  shorten_path = purrr::imap_chr(path_split,
                                 ~ paste(.x[path_start[.y]:path_lens[.y]],
                                         collapse = .Platform$file.sep))

  all = paste0(projs, " (", crayon::italic(shorten_path), ")\n")
  cat(all)

  proj_number = readline("Select Project: ")
  proj_number = as.numeric(proj_number)


  if (is.na(proj_number) || proj_number == 0) op()
  else op(projs_paths[proj_number + 1])
}
