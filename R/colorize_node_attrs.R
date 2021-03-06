#' Apply colors based on node attribute values
#' @description Within a graph's internal node data
#' frame (ndf), mutate numeric node attribute values
#' using an expression. Optionally, one can specify a
#' different node attribute name and create a new node
#' attribute while retaining the original node
#' attribute and its values.
#' @param graph a graph object of class
#' @param node_attr_from the name of the node attribute
#' column from which color values will be based.
#' @param node_attr_to the name of the new node
#' attribute to which the color values will be applied.
#' @param alpha an optional alpha transparency value to
#' apply to the generated colors. Should be in
#' the range of \code{0} (completely transparent) to
#' \code{100} (completely opaque).
#' single value will apply
#' @return a graph object of class
#' \code{dgr_graph}.
#' @examples
#' # Create a random graph of 50 nodes and 85 edges
#' graph <-
#'   create_random_graph(
#'     50, 85, set_seed = 1)
#'
#' # Find group membership values for all nodes
#' # in the graph through the Walktrap community
#' # finding algorithm and join those group values
#' # to the graph's internal node data frame (ndf)
#' # with the `join_node_attrs()` function
#' graph <-
#'   graph %>%
#'   join_node_attrs(get_cmty_walktrap(.))
#'
#' # Inspect the number of distinct communities
#' get_node_attrs(graph, "walktrap_group") %>%
#'   unique %>%
#'   sort
#' #> [1] 1 2 3 4 5 6 7 8 9
#'
#' # Visually distinguish the nodes in the different
#' # communities by applying colors using the
#' # `colorize_node_attrs()` function; specifically,
#' # set different `fillcolor` values with an alpha
#' # value of 80 and apply opaque colors to the node
#' # border (with the `color` node attribute)
#' graph <-
#'   graph %>%
#'   colorize_node_attrs(
#'     "walktrap_group", "fillcolor", 90) %>%
#'   colorize_node_attrs(
#'     "walktrap_group", "color") %>%
#'   set_node_attrs("fontcolor", "white") %>%
#'   set_global_graph_attrs(
#'     "graph", "layout", "circo")
#' @import viridis
#' @export colorize_node_attrs

colorize_node_attrs <- function(graph,
                                node_attr_from,
                                node_attr_to,
                                alpha = NULL) {

  # Extract ndf from graph
  nodes_df <- graph$nodes_df

  # Get the column number in the ndf from which to
  # recode values
  col_to_recode_no <-
    which(colnames(nodes_df) %in% node_attr_from)

  # Get the number of recoded values
  num_recodings <-
    nrow(unique(nodes_df[col_to_recode_no]))

  # Create a data frame which initial values
  new_node_attr_col <-
    data.frame(
      node_attr_to = rep(viridis(1), nrow(nodes_df)),
      stringsAsFactors = FALSE)

  # Get the column number for the new node attribute
  to_node_attr_colnum <- ncol(nodes_df) + 1

  # Bind the current ndf with the new column
  nodes_df <-
    cbind(nodes_df, new_node_attr_col)

  # Rename the new column with the target node attr name
  colnames(nodes_df)[to_node_attr_colnum] <-
    node_attr_to

  # Get a data frame of recodings
  viridis_df <-
    data.frame(to_recode = names(table(nodes_df[,col_to_recode_no])),
               colors = gsub("..$", "", viridis(num_recodings)),
               stringsAsFactors = FALSE)

  # Recode rows in the new node attribute
  for (i in seq_along(names(table(nodes_df[,col_to_recode_no])))) {

    recode_rows <-
      which(nodes_df[, col_to_recode_no] %in%
              viridis_df[i, 1])

    if (is.null(alpha)) {
      nodes_df[recode_rows, to_node_attr_colnum] <-
        gsub("..$", "", viridis(num_recodings)[i])
    } else if (!is.null(alpha)) {
      if (alpha < 100) {
        nodes_df[recode_rows, to_node_attr_colnum] <-
          gsub("..$", alpha, viridis(num_recodings)[i])
      } else if (alpha == 100) {
        nodes_df[recode_rows, to_node_attr_colnum] <-
          gsub("..$", "", viridis(num_recodings)[i])
      }
    }
  }

  # Create the graph
  graph <-
    create_graph(
      nodes_df = nodes_df,
      edges_df = graph$edges_df,
      directed = graph$directed,
      graph_attrs = graph$graph_attrs,
      node_attrs = graph$node_attrs,
      edge_attrs = graph$edge_attrs,
      graph_name = graph$graph_name,
      graph_tz = graph$graph_tz,
      graph_time = graph$graph_time)

  return(graph)
}
