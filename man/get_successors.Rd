% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_successors.R
\name{get_successors}
\alias{get_successors}
\title{Get node IDs for successor nodes to the specified
node}
\usage{
get_successors(graph, node)
}
\arguments{
\item{graph}{a graph object of class
\code{dgr_graph}.}

\item{node}{a node ID for the selected node.}
}
\value{
a vector of node ID values.
}
\description{
Provides a vector of node IDs for all
nodes that have a
connection from the given node.
}
\examples{
# Create a node data frame (ndf)
nodes <-
  create_nodes(
    nodes = LETTERS)

# Create an edge data frame (edf)
edges <-
  create_edges(
    from = sample(LETTERS, replace = TRUE),
    to = sample(LETTERS, replace = TRUE))

# From the ndf and edf, create a graph object
graph <-
  create_graph(
    nodes_df = nodes,
    edges_df = edges)

# Get sucessors for node `A` in the graph
get_successors(graph, node = "A")
#> [1] "Z" "Y"

# If there are no successors, NA is returned
get_successors(graph, node = "Z")
#> [1] NA
}

