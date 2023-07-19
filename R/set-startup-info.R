#TODO
#ip link
#cat /sys/class/net/<interface>/speed # Ethernet speed
# Used in glue, so namespacing is annoying
#' @importFrom crayon green red blue yellow italic bold make_style
get_darwin_internet = function() {

  # Connections
  con = system("route get 10.10.10.10", intern = TRUE, ignore.stderr = TRUE)
  con_interface = stringr::str_trim(stringr::str_remove(con[5], "interface:"))

  # nolint start
  if (is.na(con_interface)) {
    con_type = "None"
  } else {
    con_type = system("networksetup -listallhardwareports | grep -C1 $(route get default | grep interface | awk '{print $2}')", intern = TRUE, ignore.stderr = TRUE)
  }

  # Wifi
  if (stringr::str_detect(con_type[1], "Wi-Fi")) {

    wifi_name = system("/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I  | awk -F' SSID: '  '/ SSID: / {print $2}'", intern = TRUE)

    wifi_quality = system("/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F: '/ agrCtlRSSI/{print $2}'", intern = TRUE)

    lastTXRate = system("/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I  | awk -F' lastTxRate: '  '/ lastTxRate: / {print $2}'", intern = TRUE)

    maxRate = system("/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I  | awk -F' maxRate: '  '/ maxRate: / {print $2}'", intern = TRUE)
    signal = as.numeric(wifi_quality)
    wifi_signal = signif((signal + 110) * 10 / 7, 0)
    wifi_strength = if (signal > 70) {
      crayon::green(wifi_signal)
    } else if (wifi_signal > 60) {
      crayon::green(wifi_signal)
    } else if (wifi_signal > 50) {
      crayon::yellow(wifi_signal)
    } else {
      crayon::red(wifi_signal)
    }
    wifi_string = glue::glue_col("{green {cli::symbol$tick}} {wifi_name} (Strength: {wifi_strength}, lastTXRate: {lastTXRate}, maxRate: {maxRate})")
    # nolint end
  } else {
    wifi_string = glue::glue_col("{red {cli::symbol$cross}} wifi")
  }

  # Ethernet
  if (stringr::str_detect(con_type[1], "Ethernet")) {
    con_str = glue::glue_col("{wifi_string} | {green {cli::symbol$tick}} ethernet")
  } else {
    con_str = glue::glue_col("{wifi_string} | {red {cli::symbol$cross}} ethernet")
  }
  return(con_str)
}

get_linux_internet = function() {
  cons = system2("nmcli", args = c("connection", "show"), stdout = TRUE)

  if (length(cons) <= 1L) return(crayon::red(cli::symbol$cross))
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
      crayon::green(wifi_signal)
    } else if (wifi_signal > 60) {
      crayon::green(wifi_signal)
    } else if (wifi_signal > 50) {
      crayon::yellow(wifi_signal)
    } else {
      crayon::red(wifi_signal)
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

get_windows_internet = function() {

  wifi_name = gsub("    SSID                   : ",
                   "", system("Netsh WLAN show interfaces", intern = TRUE)[[9]])
  wifi_signal = gsub("    Signal                 : ",
                     "", system("Netsh WLAN show interfaces", intern = TRUE)[[19]])
  glue::glue("{wifi_name} (", trimws("{wifi_signal}"), ")")
}

get_internet = function() {
  if (Sys.info()[["sysname"]] == "Windows") {
    con_str = get_windows_internet()
  } else if (Sys.info()[["sysname"]] == "Linux") {
    con_str = get_linux_internet()
  } else if (Sys.info()[["sysname"]] == "Darwin") {
    con_str = get_darwin_internet()
  } else {
    con_str = "Unknown system"
  }
  return(con_str)
}

get_r_sessions = function() {
  if (Sys.info()[["sysname"]] %in% c("Linux", "Darwin")) {
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

  if (isFALSE(rstudioapi::isAvailable())) return(glue::glue("{red(cli::symbol$cross)} ({wd})"))
  active_proj = rstudioapi::getActiveProject()
  rproj = list.files(pattern = "\\.Rproj$")
  if (length(rproj) == 0L && is.null(active_proj)) return(NULL)

  if (is.null(active_proj)) {
    msg = glue::glue_col("{blue}{cli::symbol$info} {rproj} available ({wd})")
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
