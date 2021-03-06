#' Get a minimum spanning tree subgraph
#' @description Get a minimum spanning tree subgraph
#' for a connected graph of class \code{dgr_graph}.
#' @param graph a graph object of class
#' \code{dgr_graph}.
#' @return a graph object of class \code{dgr_graph}.
#' @examples
#' # Create a random graph and obtain Jaccard
#' # similarity values for each pair of nodes
#' # as a square matrix
#' j_sim_matrix <-
#'   create_random_graph(
#'     10, 22, set_seed = 1) %>%
#'   get_jaccard_similarity
#'
#' # Create a weighted, undirected graph from the
#' # resultant matrix (effectively treating that
#' # matrix as an adjacency matrix)
#' graph <-
#'   j_sim_matrix %>%
#'   from_adj_matrix(weighted = TRUE)
#'
#' # The graph in this case is a fully connected graph
#' # with loops, where jaccard similarity values are
#' # assigned as edge weights (edge attribute `weight`);
#' # The minimum spanning tree for this graph is the
#' # connected subgraph where the edges retained have
#' # the lowest similarity values possible
#' min_spanning_tree_graph <-
#'   graph %>%
#'   get_min_spanning_tree %>%
#'   copy_edge_attrs("weight", "label") %>%
#'   set_edge_attrs("fontname", "Helvetica") %>%
#'   set_edge_attrs("color", "gray85") %>%
#'   rescale_edge_attrs("weight", 0.5, 4.0, "penwidth")
#'
#' # Render the graph to display in the RStudio Viewer
#' render_graph(min_spanning_tree_graph)
#' @importFrom igraph mst
#' @export get_min_spanning_tree

get_min_spanning_tree <- function(graph) {

  # Transform the graph to an igraph object
  igraph <- to_igraph(graph)

  # Get the minimum spanning tree
  igraph_mst <- mst(igraph)

  # Generate the graph object from an igraph graph
  graph <- from_igraph(igraph_mst)

  return(graph)
}
