% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_nodes.R
\name{get_nodes}
\alias{get_nodes}
\title{Get a vector of node ID values}
\usage{
get_nodes(x, node_attr = NULL, match = NULL)
}
\arguments{
\item{x}{either a graph object of class
\code{dgr_graph} that is created using
\code{create_graph} or a node data frame.}

\item{node_attr}{an optional character vector of
node attribute values for filtering the node ID
values returned.}

\item{match}{an option to provide a logical
expression with a comparison operator (\code{>},
\code{<}, \code{==}, or \code{!=}) followed by a
number for numerical filtering, or, a character
string for filtering the edges returned through
string matching.}
}
\value{
a vector of node ID values.
}
\description{
Obtain a vector of node ID values from
a graph object or a node data frame. An optional
filter by node attribute can limit the set of node
ID values returned.
}
\examples{
# Before getting node ID values, create a
# simple graph
nodes <-
  create_nodes(
    nodes = c("a", "b", "c", "d"),
    type = "letter",
    color = c("red", "green", "grey", "blue"),
    value = c(3.5, 2.6, 9.4, 2.7))

graph <-
  create_graph(nodes_df = nodes)

# Get a vector of all nodes in a graph
get_nodes(graph)
#> [1] "a" "b" "c" "d"

# Get a vector of node ID values from a node
# data frame
get_nodes(nodes)
#> [1] "a" "b" "c" "d"

# Get a vector of node ID values using a numeric
# comparison (i.e., all nodes with 'value' attribute
# greater than 3)
get_nodes(
  graph,
  node_attr = "value",
  match = "> 3")
#> [1] "a" "c"

# Get a vector of node ID values using a match
# pattern (i.e., all nodes with 'color' attribute
# of "green")
get_nodes(
  graph,
  node_attr = "color",
  match = "green")
#> [1] "b"
}

