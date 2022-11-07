#' @importFrom utils capture.output object.size
# SO: http://stackoverflow.com/q/1358003/203420
# improved list of objects
ls.objects = function(pos = 1, order.by,
                      decreasing = FALSE, head = FALSE, n = 10) {
  napply = function(names, fn) sapply(names, function(x) fn(get(x, pos = pos)))
  names = ls(pos = pos)

  obj.class = napply(names, function(x) as.character(class(x))[1])
  obj.mode = napply(names, mode)
  obj.type = ifelse(is.na(obj.class), obj.mode, obj.class)
  obj.prettysize = napply(names, function(x) {
    capture.output(print(object.size(x), units = "auto"))
  })
  obj.size = napply(names, object.size)
  obj.dim = t(napply(names, function(x) as.numeric(dim(x))[1:2]))

  if (length(names) > 0) {
    vec = is.na(obj.dim)[, 1] & (obj.type != "function")
    obj.dim[vec, 1] = napply(names, length)[vec]
    out = data.frame(obj.type, obj.size, obj.prettysize, obj.dim)
  } else {
    out = data.frame("a", "b", "c", "d", "e")
    out = out[FALSE, ]
  }
  names(out) = c("Type", "Size", "PrettySize", "Rows", "Columns")
  if (!missing(order.by))
    out = out[order(out[[order.by]], decreasing = decreasing), ]
  if (head)
    out = head(out, n)
  out
}

lsos = function(..., n = 10) {
  ls.objects(...,
             order.by = "Size",
             decreasing = TRUE,
             head = TRUE,
             n = n)
}
