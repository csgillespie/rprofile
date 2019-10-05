#ip link
#cat /sys/class/net/<interface>/speed

get_wifi = function() {
  wifi = system2("nmcli", args = c("dev", "wifi"), stdout = TRUE)
  if (length(wifi) <= 1L) return("-")
  start_locs = stringr::str_locate(wifi[1],
                                   c("IN-USE", "SSID", "MODE",
                                     "CHAN", "RATE", "SIGNAL",
                                     "BARS", "SECURITY"))
  start_locs = start_locs[, 1]
  wifi = wifi[grep("^\\*", wifi)][[1]]
  wifi = strsplit(wifi, "")[[1]]

  # wifi_name
  wifi_name = paste(wifi[start_locs[2]:(start_locs[3] - 1)], collapse = "")
  wifi_name = stringr::str_trim(wifi_name)

  # wifi_signal
  wifi_signal = paste(wifi[start_locs[6]:(start_locs[7] - 1)], collapse = "")
  wifi_signal = stringr::str_trim(wifi_signal)

  wifi_rate = paste(wifi[start_locs[5]:(start_locs[6] - 1)], collapse = "")
  wifi_rate = stringr::str_trim(wifi_rate)
  strength = if (wifi_signal > 70) {
    green(wifi_signal)
  } else if (wifi_signal > 60) {
    green(wifi_signal)
  } else if (wifi_signal > 50) {
    yellow(wifi_signal)
  } else {
    red(wifi_signal)
  }
  glue::glue("{wifi_name} ({strength}; {wifi_rate})")
}

get_r_sessions = function() {
  r_sessions = system2("ps", args = c("aux", "|", "grep", "rsession"), stdout = TRUE)
  no_sessions = length(r_sessions) - 2
  r_sessions = system2("ps", args = c("aux", "|", "grep", "exec/R"), stdout = TRUE)
  no_sessions + length(r_sessions) - 2
}


#' Customised Startup info
#'
#' Currently prints the numbe of Rsessions running and wifi details.
#' @export
set_startup_info = function() {
  cat("\014")
  wifi_name = get_wifi() #nolint
  no_sessions = get_r_sessions() #nolint
  msg = glue::glue("{crayon::yellow('wifi:')} {wifi_name}
                    {crayon::yellow('#rsessions:')} {no_sessions}")
  message(msg)
}
