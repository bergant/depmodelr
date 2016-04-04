#' depmodelr
#'
#' Create module dependency graphs
#'
#' @examples
#' \dontrun{
#' # read yaml file
#' library(yaml)
#' dep1 <- yaml.load_file(system.file("example.yml", package = "depmodelr") )
#'
#' # create dependency graph
#' g1 <- dep_graph(dep1)
#'
#' # display graph
#' library(DiagrammeR)
#' grViz(g1)
#'
#' }
#' @seealso \code{\link{dep_graph}}
#' @name depmodelr
#' @docType package
#' @name depmodelr-package
#' @aliases depmodelr
NULL

#' Dependency graph
#'
#' Returns a graphviz dot source for dependency graph
#'
#' @param x A list with elements \code{refId}, \code{name}, \code{description}
#'   and optional elements executables (nested packages) and references
#'   (dependencies) with \code{from} and \code{to} elements.
#' @param ... Additional graphviz attributes
#' @examples
#' test1 <-
#'   list(
#'     refId = "01", name = "Package 01", executables = list(
#'       list(refId = "0101", name = "Package 0101"),
#'       list(refId = "0102", name = "Package 0102")
#'     ),
#'     references = list(
#'       list(from = "0101", to = "0102")
#'     )
#'   )
#'
#' dot_source <- dep_graph(test1)
#' @export
dep_graph <- function(x, ...) {
  gv_digraph(
    x$refId,
    label = dep_description(x),
    x = gv_body("node [shape = box]", dep_body(x)),
    ...
  )
}

dep_subraph <- function(x) {
  if(is.null(x$executables)) {
    dep_body(x)
  } else {
    gv_cluster(x$refId, label = dep_description(x), gv_body(
      dep_body(x),
      gv_node(x$refId, style = "invis", shape = "point")
    ))
  }
}

dep_description <- function(x) {
  paste(x$name, x$description, sep = "\\n")
}

dep_body <- function(x) {

  nodes <-
    if(!is.null(x$executables)) {
      paste(lapply(x$executables, dep_subraph), collapse = "\n")
    } else {
      if(is.null(x$description)) x$description <- ""
      gv_node(x$refId, label = dep_description(x))
    }
  links <-
    paste(
      lapply(x$references, function(ref) {
        gv_link(ref$from, ref$to)
      }),
      collapse = "\n"
    )
  paste(nodes, links, sep = "\n")
}

