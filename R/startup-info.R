

get_wifi = function() {
#  start_locs = c(1, 9, 25, 32, 38, 50, 58, 64)
  wifi = system2("nmcli", args = c("dev", "wifi"), stdout = TRUE)
  wifi = wifi[grep("^\\*", wifi)][[1]]
  wifi = strsplit(wifi, "")[[1]]

  # wifi_name
  wifi_name = paste(wifi[9:24], collapse = "")
  wifi_name = stringr::str_trim(wifi_name)

  # wifi_signal
  wifi_signal = paste(wifi[50:57], collapse = "")
  wifi_signal = stringr::str_trim(wifi_signal)

  wifi_rate = paste(wifi[38:49], collapse = "")
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


#' @export
startup_info = function() {
  cat("\014")
  wifi_name = get_wifi() #nolint
  no_sessions = get_r_sessions() #nolint
  msg = glue::glue("{crayon::yellow('wifi:')} {wifi_name}
                    {crayon::yellow('#rsessions:')} {no_sessions}")
  message(msg)
}
