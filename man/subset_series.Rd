% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/subset_series.R
\name{subset_series}
\alias{subset_series}
\title{Subset a graph series object}
\usage{
subset_series(graph_series, by = "number", values, tz = NULL)
}
\arguments{
\item{graph_series}{a graph series object of type
\code{dgr_graph_1D}.}

\item{by}{either \code{number}, which allows for
subsetting of the graph series by graph indices, or
\code{time} which for graph series objects of type
\code{temporal} allows for a subsetting of graphs by
a date-time or time range.}

\item{values}{where the subsetting of the graph
series by to occur via graph indices (where
\code{by = number}), provide a vector of those
indices; when subsetting by time (where
\code{by = time}), a range of times can be provided
as a vector.}

\item{tz}{the time zone (\code{tz}) corresponding to
dates or date-time string provided in \code{values}
(if \code{by = "date"}).}
}
\value{
a graph series object of type
\code{dgr_graph_1D}.
}
\description{
Subsetting a graph series by the
graphs' index positions in the graph series or
through selection via graphs' date-time attributes.
}
\examples{
# Create three graphs
graph_time_1 <-
  create_graph(
    graph_name = "graph_with_time_1",
    graph_time = "2015-03-25 03:00",
    graph_tz = "GMT") \%>\%
  add_node("a") \%>\%
  add_node("b") \%>\%
  add_node("c") \%>\%
  add_edge("a", "c") \%>\%
  add_edge("a", "b") \%>\%
  add_edge("b", "c")

graph_time_2 <-
  create_graph(
    graph_name = "graph_with_time_2",
    graph_time = "2015-03-26 03:00",
    graph_tz = "GMT") \%>\%
  add_node("d") \%>\%
  add_node("e") \%>\%
  add_node("f") \%>\%
  add_edge("d", "f") \%>\%
  add_edge("d", "e") \%>\%
  add_edge("e", "f")

graph_time_3 <-
  create_graph(
    graph_name = "graph_with_time_3",
    graph_time = "2015-03-27 15:00",
    graph_tz = "GMT") \%>\%
  add_node("x") \%>\%
  add_node("y") \%>\%
  add_node("z") \%>\%
  add_edge("x", "z") \%>\%
  add_edge("x", "y") \%>\%
  add_edge("y", "z")

# Create an empty graph series and add
# the graphs
series_temporal <-
  create_series(series_type = "temporal") \%>\%
  add_to_series(graph_time_1, .) \%>\%
  add_to_series(graph_time_2, .) \%>\%
  add_to_series(graph_time_3, .)

# Subset graph series by sequence
series_sequence_subset <-
  subset_series(
    graph_series = series_temporal,
    by = "number",
    values = 2)

graph_count(series_sequence_subset)
#> [1] 1

# Subset graph series by date-time
series_time_subset <-
  subset_series(
    graph_series = series_temporal,
    by = "time",
    values = c("2015-03-25 12:00",
               "2015-03-26 12:00"),
    tz = "GMT")

graph_count(series_time_subset)
#> [1] 1
}

