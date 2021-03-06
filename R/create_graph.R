#' Create a graph object
#' @description Generates a graph object with the
#' option to use node data frames (ndfs) and/or edge
#' data frames (edfs) to populate the initial graph.
#' @param nodes_df an optional data frame containing,
#' at minimum, a column (called \code{nodes}) which
#' contains node IDs for the graph. Additional
#' columns (named as Graphviz node attributes) can be
#' included with values for the named node attribute.
#' @param edges_df an optional data frame containing,
#' at minimum, two columns (called \code{from} and
#' \code{to}) where node IDs are provided. Additional
#' columns (named as Graphviz edge attributes) can be
#' included with values for the named edge attribute.
#' @param graph_attrs an optional vector of graph
#' attribute statements that can serve as defaults
#' for the graph.
#' @param node_attrs an optional vector of node
#' attribute statements that can serve as defaults for
#' nodes.
#' @param edge_attrs an optional vector of edge
#' attribute statements that can serve as defaults for
#' edges.
#' @param directed with \code{TRUE} (the default) or
#' \code{FALSE}, either directed or undirected edge
#' operations will be generated, respectively.
#' @param graph_name an optional string for labeling
#' the graph object.
#' @param graph_time a date or date-time string
#' (required for insertion of graph into a graph series
#' of the type \code{temporal}).
#' @param graph_tz an optional value for the time zone
#' (\code{tz}) corresponding to the date or date-time
#' string supplied as a value to \code{graph_time}. If
#' no time zone is provided then it will be set to
#' \code{GMT}.
#' @param generate_dot an option to generate Graphviz
#' DOT code and place into the graph object.
#' @return a graph object of class \code{dgr_graph}.
#' @examples
#' # Create an empty graph
#' graph <- create_graph()
#'
#' # A graph can be created with nodes and
#' # without edges; this is usually done in 2 steps:
#' # 1. create a node data frame (ndf) using the
#' #    `create_nodes()` function
#' nodes <-
#'   create_nodes(
#'     nodes = c("a", "b", "c", "d"))
#'
#' # 2. create the graph object with `create_graph()`
#' #    and pass in the ndf to `nodes_df`
#' graph <- create_graph(nodes_df = nodes)
#'
#' # You can create a similar graph with just nodes but
#' # also provide a range of attributes for the nodes
#' # (e.g., types, labels, arbitrary 'values')
#' nodes <-
#'   create_nodes(
#'     nodes = c("a", "b", "c", "d"),
#'     label = TRUE,
#'     type = c("type_1", "type_1",
#'              "type_5", "type_2"),
#'     shape = c("circle", "circle",
#'               "rectangle", "rectangle"),
#'     values = c(3.5, 2.6, 9.4, 2.7))
#'
#' graph <- create_graph(nodes_df = nodes)
#'
#' # A graph can also be created by just specifying the
#' # edges between nodes (in this case the unique set
#' # of nodes will be created added along with their
#' # connections but there is no possibility to add
#' # node attributes this way--they can be added later
#' # with different function--although edge attributes
#' # can specified); this is usually done in 2 steps:
#' # 1. create an edge data frame (edf) using the
#' #    `create_edges()` function:
#' edges <-
#'   create_edges(
#'     from = c("a", "b", "c"),
#'     to = c("d", "c", "a"),
#'     rel = "leading_to",
#'     values = c(7.3, 2.6, 8.3))
#'
#' # 2. create the graph object with `create_graph()`
#' #    and pass in the edf to `edges_df`
#' graph <- create_graph(edges_df = edges)
#'
#' # You can create a graph with both nodes and nodes
#' # defined, and, also add in some default attributes
#' # to be applied to all the nodes (`node_attrs`) and
#' # edges (`edge_attrs`) in this initial graph
#' graph <-
#'   create_graph(
#'     nodes_df = nodes,
#'     edges_df = edges,
#'     node_attrs = "fontname = Helvetica",
#'     edge_attrs = c("color = blue",
#'                    "arrowsize = 2"))
#' @importFrom stringr str_replace str_replace_all
#' @export create_graph

create_graph <- function(nodes_df = NULL,
                         edges_df = NULL,
                         graph_attrs = NULL,
                         node_attrs = NULL,
                         edge_attrs = NULL,
                         directed = TRUE,
                         graph_name = NULL,
                         graph_time = NULL,
                         graph_tz = NULL,
                         generate_dot = TRUE) {

  # Add default values for `graph_attrs`, `node_attrs`,
  # and `edge_attrs`
  if (is.null(graph_attrs)) {
    graph_attrs <-
      c("layout = neato", "outputorder = edgesfirst")
  }

  if (is.null(node_attrs)) {
    node_attrs <-
      c("fontname = Helvetica", "fontsize = 10",
        "shape = circle", "fixedsize = true",
        "width = 0.5", "style = filled",
        "fillcolor = aliceblue", "color = gray70",
        "fontcolor = gray50")
  }

  if (is.null(edge_attrs)) {
    edge_attrs <-
      c("len = 1.5", "color = gray40",
        "arrowsize = 0.5")
  }

  # Create vector of graph attributes
  graph_attributes <-
    c("bgcolor", "layout", "overlap", "fixedsize",
      "mindist", "nodesep", "outputorder", "ranksep",
      "rankdir", "stylesheet")

  # Create vector of node attributes
  node_attributes <-
    c("color", "distortion", "fillcolor",
      "fixedsize", "fontcolor", "fontname", "fontsize",
      "group", "height", "label", "labelloc", "margin",
      "orientation", "penwidth", "peripheries", "pos",
      "shape", "sides", "skew", "style", "tooltip",
      "width", "img", "icon")

  # Create vector of edge attributes
  edge_attributes <-
    c("arrowhead", "arrowsize", "arrowtail", "color",
      "constraint", "decorate", "dir", "edgeURL",
      "edgehref", "edgetarget", "edgetooltip",
      "fontcolor", "fontname", "fontsize", "headclip",
      "headhref", "headlabel", "headport", "headtarget",
      "headtooltip", "headURL", "href", "id", "label",
      "labelangle", "labeldistance", "labelfloat",
      "labelfontcolor", "labelfontname", "labelfontsize",
      "labelhref", "labelURL", "labeltarget",
      "labeltooltip", "layer", "lhead", "ltail", "minlen",
      "penwidth", "samehead", "sametail", "style",
      "tailclip", "tailhref", "taillabel", "tailport",
      "tailtarget", "tailtooltip", "tailURL", "target",
      "tooltip", "weight")

  # If nodes, edges, and attributes not provided,
  # create an empty graph
  if (all(c(is.null(nodes_df), is.null(edges_df),
            is.null(graph_attrs), is.null(node_attrs),
            is.null(edge_attrs)))) {

    # Create DOT code with nothing in graph
    dot_code <-
      paste0(ifelse(directed,
                    "digraph", "graph"),
             " {\n", "\n}")

    # Create the 'dgr_graph' list object
    dgr_graph <-
      list(graph_name = graph_name,
           graph_time = graph_time,
           graph_tz = graph_tz,
           nodes_df = NULL,
           edges_df = NULL,
           graph_attrs = NULL,
           node_attrs = NULL,
           edge_attrs = NULL,
           directed = ifelse(directed,
                             TRUE, FALSE),
           dot_code = dot_code)

    attr(dgr_graph, "class") <- "dgr_graph"

    return(dgr_graph)
  }

  # If nodes and edges not provided, but other
  # attributes are, create an empty graph with
  # attributes
  if (all(c(is.null(nodes_df),
            is.null(edges_df)))) {

    # Create DOT code with nothing in graph
    dot_code <-
      paste0(ifelse(directed,
                    "digraph", "graph"),
             " {\n", "\n}")

    # Create the 'dgr_graph' list object
    dgr_graph <-
      list(graph_name = graph_name,
           graph_time = graph_time,
           graph_tz = graph_tz,
           nodes_df = NULL,
           edges_df = NULL,
           graph_attrs = graph_attrs,
           node_attrs = node_attrs,
           edge_attrs = edge_attrs,
           directed = ifelse(directed,
                             TRUE, FALSE),
           dot_code = dot_code)

    attr(dgr_graph, "class") <- "dgr_graph"

    return(dgr_graph)
  }

  # Perform basic checks of the inputs
  if (!is.null(nodes_df)) {

    stopifnot("nodes" %in% colnames(nodes_df))

    # Force all columns to be of the character class
    for (i in 1:ncol(nodes_df)) {
      nodes_df[, i] <- as.character(nodes_df[, i])
    }
  }

  if (inherits(edges_df,"data.frame")) {
    if (ncol(edges_df) > 2) {

      # Force all columns to be of the character class
      for (i in 1:ncol(edges_df)) {
        edges_df[, i] <- as.character(edges_df[, i])
      }
    }
  }

  if (generate_dot) {

    #
    # Create the DOT attributes block
    #

    # Create the default attributes statement
    # for graph attributes
    if (!is.null(graph_attrs)) {
      graph_attr_stmt <-
        paste0("graph [",
               paste(graph_attrs,
                     collapse = ",\n       "),
               "]\n")
    }

    # Create the default attributes statement
    # for node attributes
    if (!is.null(node_attrs)) {
      node_attr_stmt <-
        paste0("node [", paste(node_attrs,
                               collapse = ",\n     "),
               "]\n")
    }

    # Create the default attributes statement
    # for edge attributes
    if (!is.null(edge_attrs)) {
      edge_attr_stmt <-
        paste0("edge [", paste(edge_attrs,
                               collapse = ",\n     "),
               "]\n")
    }

    # Combine default attributes into a single block
    if (exists("graph_attr_stmt") &
        exists("node_attr_stmt") &
        exists("edge_attr_stmt")) {
      combined_attr_stmts <-
        paste(graph_attr_stmt,
              node_attr_stmt,
              edge_attr_stmt, sep = "\n")
    }

    if (!exists("graph_attr_stmt") &
        exists("node_attr_stmt") &
        exists("edge_attr_stmt")) {
      combined_attr_stmts <-
        paste(node_attr_stmt,
              edge_attr_stmt, sep = "\n")
    }

    if (exists("graph_attr_stmt") &
        !exists("node_attr_stmt") &
        exists("edge_attr_stmt")) {
      combined_attr_stmts <-
        paste(graph_attr_stmt,
              edge_attr_stmt, sep = "\n")
    }

    if (exists("graph_attr_stmt") &
        exists("node_attr_stmt") &
        !exists("edge_attr_stmt")) {
      combined_attr_stmts <-
        paste(graph_attr_stmt,
              node_attr_stmt, sep = "\n")
    }

    if (exists("graph_attr_stmt") &
        !exists("node_attr_stmt") &
        !exists("edge_attr_stmt")) {
      combined_attr_stmts <-
        paste0(graph_attr_stmt, "\n")
    }

    if (!exists("graph_attr_stmt") &
        exists("node_attr_stmt") &
        !exists("edge_attr_stmt")) {
      combined_attr_stmts <-
        paste0(node_attr_stmt, "\n")
    }

    if (!exists("graph_attr_stmt") &
        !exists("node_attr_stmt") &
        exists("edge_attr_stmt")) {
      combined_attr_stmts <-
        paste0(edge_attr_stmt, "\n")
    }

    #
    # Create the DOT node block
    #

    if (!is.null(nodes_df)) {

      # Determine whether positional (x,y)
      # data is included
      column_with_x <-
        which(colnames(nodes_df) %in% "x")[1]

      column_with_y <-
        which(colnames(nodes_df) %in% "y")[1]

      if (!is.na(column_with_x) & !is.na(column_with_y)) {

        pos <-
          data.frame(
            "pos" =
              paste0(
                nodes_df[, column_with_x],
                ",",
                nodes_df[, column_with_y],
                "!"))

        nodes_df$pos <- pos$pos
      }

      # Determine whether column 'alpha' exists
      if (any(grepl("$alpha^", colnames(nodes_df)))) {
        column_with_alpha_assigned <-
          grep("$alpha^", colnames(nodes_df))
      } else {
        column_with_alpha_assigned <- NA
      }

      if (!is.na(column_with_alpha_assigned)) {

        # Determine the number of color attributes in
        # the node data frame
        number_of_col_attr <-
          length(which(colnames(nodes_df) %in%
                         c("color", "fillcolor",
                           "fontcolor")))

        # If the number of color attrs in df is 1,
        # rename referencing alpha column
        if (number_of_col_attr == 1) {

          name_of_col_attr <-
            colnames(nodes_df)[
              which(colnames(nodes_df) %in%
                      c("color", "fillcolor",
                        "fontcolor"))]

          colnames(nodes_df)[column_with_alpha_assigned] <-
            paste0("alpha:", name_of_col_attr)
        }
      }

      # Determine whether column 'alpha' with
      # color attr exists
      if (any(grepl("alpha:.*", colnames(nodes_df)))) {

        alpha_column_no <- grep("alpha:.*", colnames(nodes_df))

        color_attr_column_name <-
          unlist(strsplit(colnames(nodes_df)[
            (which(grepl("alpha:.*", colnames(nodes_df))))
            ], ":"))[-1]

        color_attr_column_no <-
          which(colnames(nodes_df) %in% color_attr_column_name)

        # Append alpha value only if referenced
        # column is for color
        if (any(c("color", "fillcolor", "fontcolor") %in%
                colnames(nodes_df)[color_attr_column_no])) {

          # Append alpha for color values that are
          # X11 color names
          if (all(grepl("[a-z]*",
                        as.character(nodes_df[, color_attr_column_no]))) &
              all(as.character(nodes_df[, color_attr_column_no]) %in%
                  x11_hex()[, 1])) {

            for (i in 1:nrow(nodes_df)) {
              nodes_df[i, color_attr_column_no] <-
                paste0(x11_hex()[
                  which(x11_hex()[, 1] %in%
                          as.character(nodes_df[i, color_attr_column_no])), 2],
                  formatC(round(as.numeric(nodes_df[i, alpha_column_no]), 0),
                          flag = "0", width = 2))
            }
          }

          # Append alpha for color values that
          # are hex color values
          if (all(grepl("#[0-9a-fA-F]{6}$",
                        as.character(nodes_df[, color_attr_column_no])))) {

            for (i in 1:nrow(nodes_df)) {
              nodes_df[, color_attr_column_no] <-
                as.character(nodes_df[, color_attr_column_no])

              nodes_df[i, color_attr_column_no] <-
                paste0(nodes_df[i, color_attr_column_no],
                       round(as.numeric(nodes_df[i, alpha_column_no]), 0))
            }
          }
        }
      }

      # Determine which other columns correspond
      # to node attribute values
      other_columns_with_node_attributes <-
        which(colnames(nodes_df) %in% node_attributes)

      # Construct the 'node_block' character object
      for (i in 1:nrow(nodes_df)) {
        if (i == 1) {
          node_block <- vector(mode = "character", length = 0)
        }

        if (length(other_columns_with_node_attributes) > 0) {
          for (j in other_columns_with_node_attributes) {
            if (j == other_columns_with_node_attributes[1]) {
              attr_string <- vector(mode = "character", length = 0)
            }

            # Create the node attributes for labels
            # and tooltips when provided
            if (all(colnames(nodes_df)[j] %in%
                    c("label", "tooltip"),
                    nodes_df[i, j] == '')) {
              attribute <- NULL
            } else if (all(colnames(nodes_df)[j] %in%
                           c("label", "tooltip"),
                           nodes_df[i, j] != '')) {
              attribute <-
                paste0(colnames(nodes_df)[j],
                       " = ", "'", nodes_df[i, j], "'")
            } else if (all(!(colnames(nodes_df)[j] %in%
                             c("label", "tooltip")),
                           nodes_df[i, j] == '')) {
              attribute <- NULL
            } else if (all(!(colnames(nodes_df)[j] %in%
                             c("label", "tooltip")),
                           nodes_df[i, j] != '')) {
              attribute <-
                paste0(colnames(nodes_df)[j],
                       " = ", "'", nodes_df[i, j], "'")
            }
            attr_string <- c(attr_string, attribute)
          }

          if (j == other_columns_with_node_attributes[
            length(other_columns_with_node_attributes)]) {
            attr_string <- paste(attr_string, collapse = ", ")
          }
        }

        # Generate a line of node objects when an
        # attribute string exists
        if (exists("attr_string")) {
          line <- paste0("  '", nodes_df[i, 1], "'",
                         " [", attr_string, "] ")
        }

        # Generate a line of node objects when an
        # attribute string doesn't exist
        if (!exists("attr_string")) {
          line <-
            paste0("  '",
                   nodes_df[i, 1],
                   "'")
        }
        node_block <- c(node_block, line)
      }

      if ('rank' %in% colnames(nodes_df)) {
        node_block <-
          c(node_block,
            tapply(node_block,
                   nodes_df$rank, FUN = function(x) {
                     if(length(x) > 1) {
                       x <- paste0('subgraph{rank = same\n',
                                   paste0(x, collapse = '\n'),
                                   '}\n')
                     }
                     return(x)
                   }))
      }

      # Construct the `node_block` character object
      node_block <- paste(node_block, collapse = "\n")

      # Remove the `attr_string` object if it exists
      if (exists("attr_string")) {
        rm(attr_string)
      }

      # Remove the `attribute` object if it exists
      if (exists("attribute")) {
        rm(attribute)
      }

      if ('cluster' %in% colnames(nodes_df)) {

        # Get column number for column with node
        # attribute `cluster`
        cluster_colnum <-
          which(colnames(nodes_df) %in% "cluster")

        # Get list of clusters defined for the nodes
        cluster_ids <-
          unique(nodes_df$cluster)[
            which(
              unique(nodes_df$cluster) != "")]

        for (i in seq_along(cluster_ids)) {

          regex <-
            paste0("'",
                   paste(nodes_df[which(nodes_df[, cluster_colnum] == i ), 1],
                         collapse = "'.*?\n |'"), "'.*?\n")

          node_block <-
            stringr::str_replace_all(node_block, regex, "")

          replacement <-
            stringr::str_replace(
              paste0("  cluster_", i, " [label = 'xN\n",
                     cluster_ids[i],
                     "'; shape = 'circle';",
                     " fixedsize = 'true';",
                     " fontsize = '8pt';",
                     " peripheries = '2']  \n"), "x",
              length(
                nodes_df[which(nodes_df[, cluster_colnum] == i ), 1]))

          node_block <-
            stringr::str_replace(node_block, "^", replacement)
        }
      }
    }

    if (is.null(nodes_df) & !is.null(edges_df)) {
      from_to_columns <-
        ifelse(any(c("from", "to") %in%
                     colnames(edges_df)), TRUE, FALSE)

      # Determine which columns in the `edges_df` df
      # contains edge attributes
      other_columns_with_edge_attributes <-
        which(colnames(edges_df) %in% edge_attributes)

      # Determine whether the complementary set of
      # columns is present
      if (from_to_columns) {
        both_from_to_columns <-
          all(c(any(c("from") %in%
                      colnames(edges_df))),
              any(c("to") %in%
                    colnames(edges_df)))
      }

      if (exists("both_from_to_columns")) {
        if (both_from_to_columns) {
          from_column <-
            which(colnames(edges_df) %in% c("from"))[1]
          to_column <-
            which(colnames(edges_df) %in% c("to"))[1]
        }
      }

      nodes_df <-
        create_nodes(nodes = unique(c(edges_df$from,
                                      edges_df$to)))

      for (i in 1:nrow(nodes_df)) {
        if (i == 1) {
          node_block <-
            vector(mode = "character", length = 0)
        }
        node_block <-
          c(node_block,
            paste0("  '",
                   nodes_df[i, 1], "'"))
      }

      # Construct the `node_block` character object
      node_block <- paste(node_block, collapse = "\n")
    }

    #
    # Create the DOT edge block
    #

    if (!is.null(edges_df)) {

      # Determine whether `from` or `to` columns are
      # in `edges_df`
      from_to_columns <-
        ifelse(any(c("from", "to") %in%
                     colnames(edges_df)), TRUE, FALSE)

      # Determine which columns in `edges_df`
      # contain edge attributes
      other_columns_with_edge_attributes <-
        which(colnames(edges_df) %in% edge_attributes)

      # Determine whether the complementary set of
      # columns is present
      if (from_to_columns) {
        both_from_to_columns <-
          all(c(any(c("from") %in%
                      colnames(edges_df))),
              any(c("to") %in%
                    colnames(edges_df)))
      }

      # If the complementary set of columns is present,
      # determine the positions
      if (exists("both_from_to_columns")) {
        if (both_from_to_columns) {
          from_column <-
            which(colnames(edges_df) %in% c("from"))[1]
          to_column <-
            which(colnames(edges_df) %in% c("to"))[1]
        }
      }

      # Construct the `edge_block` character object
      if (exists("from_column") &
          exists("to_column")) {
        if (length(from_column) == 1 &
            length(from_column) == 1) {
          for (i in 1:nrow(edges_df)) {
            if (i == 1) {
              edge_block <-
                vector(mode = "character", length = 0)
            }
            if (length(other_columns_with_edge_attributes) > 0) {
              for (j in other_columns_with_edge_attributes) {
                if (j == other_columns_with_edge_attributes[1]) {
                  attr_string <- vector(mode = "character", length = 0)
                }
                # Create the edge attributes for labels
                # and tooltips when provided
                if (all(colnames(edges_df)[j] %in%
                        c("edgetooltip", "headtooltip",
                          "label", "labeltooltip",
                          "taillabel", "tailtooltip",
                          "tooltip"),
                        edges_df[i, j] == '')) {
                  attribute <- NULL
                } else if (all(colnames(edges_df)[j] %in%
                               c("edgetooltip", "headtooltip",
                                 "label", "labeltooltip",
                                 "taillabel", "tailtooltip",
                                 "tooltip"),
                               edges_df[i, j] != '')) {
                  attribute <-
                    paste0(colnames(edges_df)[j],
                           " = ", "'", edges_df[i, j],
                           "'")
                } else if (all(!(colnames(edges_df)[j] %in%
                                 c("edgetooltip", "headtooltip",
                                   "label", "labeltooltip",
                                   "taillabel", "tailtooltip",
                                   "tooltip")),
                               edges_df[i, j] == '')) {

                  attribute <- NULL
                } else if (all(!(colnames(edges_df)[j] %in%
                                 c("edgetooltip", "headtooltip",
                                   "label", "labeltooltip",
                                   "taillabel", "tailtooltip",
                                   "tooltip")),
                               edges_df[i, j] != '')) {
                  attribute <-
                    paste0(colnames(edges_df)[j],
                           " = ", "'", edges_df[i, j], "'")
                }
                attr_string <- c(attr_string, attribute)
              }

              if (j == other_columns_with_edge_attributes[
                length(other_columns_with_edge_attributes)]) {
                attr_string <- paste(attr_string, collapse = ", ")
              }
            }

            # Generate a line of edge objects when an
            # attribute string exists
            if (exists("attr_string")) {
              line <-
                paste0("'", edges_df[i, from_column], "'",
                       ifelse(directed, "->", "--"),
                       "'", edges_df[i, to_column], "'",
                       paste0(" [", attr_string, "] "))
            }

            # Generate a line of edge objects when an
            # attribute string doesn't exist
            if (!exists("attr_string")) {
              line <-
                paste0("  ",
                       "'", edges_df[i, from_column], "'",
                       ifelse(directed, "->", "--"),
                       "'", edges_df[i, to_column], "'",
                       " ")
            }
            edge_block <- c(edge_block, line)
          }
        }
      }

      # Construct the `edge_block` character object
      if (exists("edge_block")) {
        edge_block <- paste(edge_block, collapse = "\n")
      }

      if ('cluster' %in% colnames(nodes_df)) {


        # Get column number for column with node
        # attribute `cluster`
        cluster_colnum <-
          which(colnames(nodes_df) %in% "cluster")

        # Get list of clusters defined for the nodes
        cluster_ids <-
          which(
            unique(nodes_df$cluster) != "")

        for (i in seq_along(cluster_ids)) {

          regex <-
            stringr::str_replace(
              "'x'", "x",
              paste(nodes_df[which(nodes_df[, cluster_colnum] == i ), 1],
                    collapse = "'|'"))

          edge_block <-
            stringr::str_replace_all(edge_block, regex, paste0("'cluster_", i, "'"))

          regex <-
            paste0("('cluster_", i, "'->'cluster_", i, "' \n |",
                   "'cluster_", i, "'->'cluster_", i, "')")

          edge_block <-
            stringr::str_replace_all(edge_block, regex, "")
        }
      }
    }

    # Create the graph code from the chosen attributes,
    # and the nodes and edges blocks
    if (exists("combined_attr_stmts")) {
      if (exists("edge_block") & exists("node_block")) {
        combined_block <-
          paste(combined_attr_stmts,
                node_block, edge_block,
                sep = "\n")
      }
      if (!exists("edge_block") & exists("node_block")) {
        combined_block <-
          paste(combined_attr_stmts,
                node_block,
                sep = "\n")
      }
    }
    if (!exists("combined_attr_stmts")) {
      if (exists("edge_block")) {
        combined_block <- paste(node_block, edge_block,
                                sep = "\n")
      }
      if (!exists("edge_block")) {
        combined_block <- node_block
      }
    }

    # Create DOT code
    dot_code <-
      paste0(ifelse(directed, "digraph", "graph"),
             " {\n", "\n", combined_block, "\n}")

    # Remove empty node or edge attribute statements
    dot_code <- gsub(" \\[\\] ", "", dot_code)

    # Create the `dgr_graph` list object
    dgr_graph <-
      list(graph_name = graph_name,
           graph_time = graph_time,
           graph_tz = graph_tz,
           nodes_df = nodes_df,
           edges_df = edges_df,
           graph_attrs = graph_attrs,
           node_attrs = node_attrs,
           edge_attrs = edge_attrs,
           directed = directed,
           dot_code = dot_code)

    attr(dgr_graph, "class") <- "dgr_graph"
  }

  if (generate_dot == FALSE) {

    # Create the `dgr_graph` list object
    dgr_graph <-
      list(graph_name = graph_name,
           graph_time = graph_time,
           graph_tz = graph_tz,
           nodes_df = nodes_df,
           edges_df = edges_df,
           graph_attrs = graph_attrs,
           node_attrs = node_attrs,
           edge_attrs = edge_attrs,
           directed = directed,
           dot_code = NULL)

    attr(dgr_graph, "class") <- "dgr_graph"
  }

  return(dgr_graph)
}
