
gv_graph <- function(tag, name, x, ...) {
  attrs <- list(...)
  attrs_str <-
    paste(
      sapply(names(attrs), function(n) {
        sprintf('%s = "%s"', n, attrs[n])
      }),
      collapse = "\n"
    )
  if(length(x) > 1) {
    x <- paste(x, collapse = "\n")
  }
  sprintf("%s %s {\n%s\n\n%s\n}", tag, name, attrs_str, x )
}

gv_digraph <- function(name, x, ...) {
  gv_graph("digraph", name, x, ...)
}

gv_subgraph <- function(name, x, ...) {
  gv_graph("subgraph", name, x, ...)
}


gv_cluster <- function(name, x, ...) {
  name <- gsub(" ", "_", name)
  name <- gsub("-", "_", name)

  name <- paste("cluster", name, sep = "_")
  gv_graph("subgraph", name, x, ...)
}


gv_node <- function(name, ...) {
  attrs <- list(...)
  attrs_str <-
    paste0(
      sapply(names(attrs), function(n) {
        sprintf('%s = "%s"', n, attrs[n])
      }),
      collapse = " "
    )
  name <- gsub(" ", "_", name)
  name <- gsub("-", "_", name)
  sprintf("\"%s\" [%s]\n", name, attrs_str)
}


gv_link <- function(x, y, ...) {
  attrs <- list(...)
  attrs_str <-
    paste0(
      sapply(names(attrs), function(n) {
        sprintf('%s = "%s"', n, attrs[n])
      }),
      collapse = " "
    )
  x <- gsub(" ", "_", x)
  y <- gsub(" ", "_", y)
  x <- gsub("-", "_", x)
  y <- gsub("-", "_", y)

  sprintf('"%s" -> "%s" [%s]', x, y, attrs_str)
}

gv_body <- list

# example
if(FALSE) {

  library(DiagrammeR)
  grViz(
    gv_digraph("graf", label = "testni graf", gv_body(
      gv_cluster("podgraf", label = "testni podgraf", gv_body(
        gv_node("test", label = "testni node"),
        gv_cluster("podpodgraf", label = "testni podpodgraf",
                   gv_node("test2", label = "testni node 2")
        ),
        gv_link("test", "test2", label = 2)
      )),
      gv_cluster("podgraf2", label = "testni podgraf2", gv_body(
        gv_node("test2", label = "testni node 2"),
        gv_cluster("podpodgraf", label = "testni podpodgraf",
                   gv_node("test3", label = "testni node 3")
        ),
        gv_link("test2", "test3", label = 2)
      ))
    ))
  )

}

