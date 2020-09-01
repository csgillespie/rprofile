#TODO
#ip link
#cat /sys/class/net/<interface>/speed # Ethernet speed

get_windows_internet = function() {

  wifi_name = gsub("    SSID                   : ",
                   "", system("Netsh WLAN show interfaces", intern = TRUE)[[9]])
  wifi_signal = gsub("    Signal                 : ",
                     "", system("Netsh WLAN show interfaces", intern = TRUE)[[19]])
  glue::glue("{wifi_name} (", trimws("{wifi_signal}"), ")")
}

get_linux_internet = function() {
  cons = system2("nmcli", args = c("connection", "show"), stdout = TRUE)

  if (length(cons) <= 1L) return(crayon::red(symbol$cross))
  start_locs = stringr::str_locate(cons[1], c("NAME", "UUID", "TYPE", "DEVICE"))
  start_locs = start_locs[, 1]
  end_locs = numeric(4)
  end_locs = c(start_locs[2:4] - 1, max(nchar(cons)))

  cons = lapply(1:4, function(i) stringr::str_sub(cons[-1], start_locs[i], end_locs[i]))
  cons = lapply(cons, stringr::str_trim)
  cons = tibble::tibble(name = cons[[1]], type = cons[[3]], device = cons[[4]])
  cons = cons[cons$device != "--", ]

  # Wifi device
  # https://superuser.com/a/1360447/89305
  # TODO: quality vs strength ?
  wifi = cons[cons$type == "wifi", ]
  if (nrow(wifi) > 0) {
    wifi_name = wifi$name
    wifi_device = wifi$device
    wifi_quality = system2("iwconfig", args = c(wifi_device, "|", "grep", "-i", "quality"),
                           stdout = TRUE)
    quality = stringr::str_match(wifi_quality, "Link Quality=([0-9]*/[0-9][0-9])")[, 2]
    signal = as.numeric(stringr::str_match(wifi_quality, "level=(-[0-9]*)")[, 2])

    wifi_signal = signif((signal + 110) * 10 / 7, 0)
    wifi_strength = if (signal > 70) {
      green(wifi_signal)
    } else if (wifi_signal > 60) {
      green(wifi_signal)
    } else if (wifi_signal > 50) {
      yellow(wifi_signal)
    } else {
      red(wifi_signal)
    }
    wifi_string = glue::glue_col("{green {cli::symbol$tick}} {wifi_name} ({wifi_strength})")
  } else {
    wifi_string = glue::glue_col("{red {cli::symbol$cross}} wifi")
  }
  # Ethernet
  if (any(cons$type == "ethernet")) {
    con_str = glue::glue_col("{wifi_string} | {green {cli::symbol$tick}} ethernet")
  } else {
    con_str = glue::glue_col("{wifi_string} | {red {cli::symbol$cross}} ethernet")
  }
  return(con_str)
}
#' @importFrom tibble tibble
get_internet = function() {
  if (Sys.info()[["sysname"]] == "Windows") {
    con_str = get_windows_internet()
  } else if (Sys.info()[["sysname"]] == "Linux") {
    con_str = get_linux_internet()
  } else {
    con_str = "Unknown system"
  }
  return(con_str)
}


get_r_sessions = function() {
  if (Sys.info()[["sysname"]] == "Linux") {
    r_sessions = system2("ps", args = c("aux", "|", "grep", "rsession"), stdout = TRUE)
    no_sessions = length(r_sessions) - 2
    r_sessions = system2("ps", args = c("aux", "|", "grep", "exec/R"), stdout = TRUE)
    return(no_sessions + length(r_sessions) - 2)
  }
  return("Unknown system")
}

#' @rdname set_startup_info
#' @export
get_active_rproj = function() {
  wd = get_shorten_paths(getwd())

  if (isFALSE(rstudioapi::isAvailable())) return(glue::glue("{red(symbol$cross)} ({wd})"))
  active_proj = rstudioapi::getActiveProject()
  rproj = list.files(pattern = "\\.Rproj$")
  if (length(rproj) == 0L && is.null(active_proj)) return(NULL)

  if (is.null(active_proj)) {
    msg = glue::glue_col("{blue}{symbol$info} {rproj} available ({wd})")
  } else {
    active_proj = basename(active_proj)
    msg = glue::glue_col("{green}{active_proj} ({wd})")
  }
  return(msg)
}

#' Customised Startup info
#'
#' Currently prints the number of R sessions running and wifi details.
#' The \code{get_active_rproj} function needs to be explicitly added to .Rprofile due
#' to the way RStudio hooks work
#' @export
set_startup_info = function() {
  cat("\014")
  internet = get_internet() #nolint
  no_sessions = get_r_sessions() #nolint

  msg = glue::glue("{internet}
                    {crayon::yellow('#rsessions:')} {no_sessions}")
  message(msg)
}
