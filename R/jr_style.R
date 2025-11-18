#' R Code styling
#'
#' @inheritParams styler::tidyverse_style
jr_style = function(scope = "tokens") {
  transformers = styler::tidyverse_style(scope = scope)

  transformers = use_equals_assignment(transformers)

  transformers$style_guide_name = "jrAdminStyle::jr_style"
  transformers$style_guide_version = utils::packageVersion("jrAdminStyle")

  transformers
}

use_equals_assignment = function(transformers) {
  # Equals-assignment styler is only valid for transformers that are active at scope=='tokens'
  if (!("token" %in% names(transformers)) || is.null(transformers[["token"]])) {
    return(transformers)
  }

  # Remove the equals-to-leftAssignment styler
  transformers$token$force_assignment_op = NULL

  # Add a leftAssignment-to-equals styler
  transformers$token$force_equals_assignment = function(pd) {
    to_replace = pd$token == "LEFT_ASSIGN"
    pd$token[to_replace] = "EQ_ASSIGN"
    pd$text[to_replace] = "="
    pd
  }
  transformers
}
