#' Rename a node attribute
#' @description Within a graph's internal node data
#' frame (ndf), rename an existing node attribute.
#' @param graph a graph object of class
#' @param node_attr_from the name of the node attribute
#' that will be renamed.
#' @param node_attr_to the new name of the node
#' attribute column identified in \code{node_attr_from}.
#' @return a graph object of class \code{dgr_graph}.
#' @examples
#' # Create a random graph
#' graph <-
#'   create_random_graph(
#'     5, 10, set_seed = 3) %>%
#'   set_node_attrs("shape", "circle")
#'
#' # Get the graph's internal ndf to show which
#' # node attributes are available
#' get_node_df(graph)
#' #>   nodes type label value  shape
#' #> 1     1          1     2 circle
#' #> 2     2          2   8.5 circle
#' #> 3     3          3     4 circle
#' #> 4     4          4   3.5 circle
#' #> 5     5          5   6.5 circle
#'
#' # Rename the `value` node attribute as `weight`
#' graph <-
#'   graph %>%
#'   rename_node_attrs("value", "weight")
#'
#' # Get the graph's internal ndf to show that the
#' # node attribute had been renamed
#' get_node_df(graph)
#' #>   nodes type label weight  shape
#' #> 1     1          1      2 circle
#' #> 2     2          2    8.5 circle
#' #> 3     3          3      4 circle
#' #> 4     4          4    3.5 circle
#' #> 5     5          5    6.5 circle
#' @export rename_node_attrs

rename_node_attrs <- function(graph,
                              node_attr_from,
                              node_attr_to) {

  # Stop function if `node_attr_from` and
  # `node_attr_to` are identical
  if (node_attr_from == node_attr_to) {
    stop("You cannot rename using the same name.")
  }

  # Stop function if `node_attr_to` is `nodes`, `node`,
  # or any other column name in the graph's node
  # data frame
  if (any(unique(c("nodes", "node",
                   colnames(get_node_df(graph)))) %in%
          node_attr_to)) {
    stop("You cannot use that name for `node_attr_to`.")
  }

  # Extract the graph's ndf
  nodes <- get_node_df(graph)

  # Get column names from the graph's ndf
  column_names_graph <- colnames(nodes)

  # Stop function if `node_attr_from` is not one
  # of the graph's columns
  if (!any(column_names_graph %in% node_attr_from)) {
    stop("The node attribute to rename is not in the ndf.")
  }

  # Set the column name for the renamed attr
  colnames(nodes)[
    which(colnames(nodes) %in%
            node_attr_from)] <- node_attr_to

  # Create a new graph object
  dgr_graph <-
    create_graph(nodes_df = nodes,
                 edges_df = graph$edges_df,
                 graph_attrs = graph$graph_attrs,
                 node_attrs = graph$node_attrs,
                 edge_attrs = graph$edge_attrs,
                 directed = graph$directed,
                 graph_name = graph$graph_name,
                 graph_time = graph$graph_time,
                 graph_tz = graph$graph_tz)

  return(dgr_graph)
}
