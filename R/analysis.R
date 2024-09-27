##############################################################################
# Copyright (C) 2024                                                         #
#                                                                            #
# CC BY-NC-SA 4.0                                                            #
#                                                                            #
# Canonical URL https://creativecommons.org/licenses/by-nc-sa/4.0/           #
# Attribution-NonCommercial-ShareAlike 4.0 International CC BY-NC-SA 4.0     #
#                                                                            #
# Prof. Elaine Cecilia Gatto | Prof. Ricardo Cerri | Prof. Mauri Ferrandin   #
#                                                                            #
# Federal University of São Carlos - UFSCar - https://www2.ufscar.br         #
# Campus São Carlos - Computer Department - DC - https://site.dc.ufscar.br   #
# Post Graduate Program in Computer Science - PPGCC                          # 
# http://ppgcc.dc.ufscar.br - Bioinformatics and Machine Learning Group      #
# BIOMAL - http://www.biomal.ufscar.br                                       #
#                                                                            #
# You are free to:                                                           #
#     Share — copy and redistribute the material in any medium or format     #
#     Adapt — remix, transform, and build upon the material                  #
#     The licensor cannot revoke these freedoms as long as you follow the    #
#       license terms.                                                       #
#                                                                            #
# Under the following terms:                                                 #
#   Attribution — You must give appropriate credit , provide a link to the   #
#     license, and indicate if changes were made . You may do so in any      #
#     reasonable manner, but not in any way that suggests the licensor       #
#     endorses you or your use.                                              #
#   NonCommercial — You may not use the material for commercial purposes     #
#   ShareAlike — If you remix, transform, or build upon the material, you    #
#     must distribute your contributions under the same license as the       #
#     original.                                                              #
#   No additional restrictions — You may not apply legal terms or            #
#     technological measures that legally restrict others from doing         #
#     anything the license permits.                                          #
#                                                                            #
##############################################################################



##############################################################################
# WORSKSPACE
##############################################################################
FolderRoot = "~/WinTieLoss"
FolderScripts = "~/WinTieLoss/R"



#' Compare Results Between Two Methods
#' 
#' This function compares the results of two methods based on their performance metrics,
#' such as wins, ties, or losses. It calculates the total for each method and determines
#' which method performed better.
#' 
#' @param method1 A data frame containing performance metrics for the first method. 
#'                Must include columns for wins, ties, and losses.
#' @param method2 A data frame containing performance metrics for the second method.
#'                Must include columns for wins, ties, and losses.
#' @param names A character vector of length 2, providing the names of the two methods
#'              being compared.
#' @param type A character string specifying the type of comparison. 
#'             Acceptable values are "wins", "ties", or "losses".
#' 
#' @return A data frame with the following columns:
#' \item{Method}{The names of the two methods being compared.}
#' \item{Total}{The total count of wins, ties, or losses for each method, depending on the comparison type.}
#' \item{Best}{A character string indicating which method performed better. 
#'             Values can be "Yes", "No", or "Tie".}
#' 
#' @examples
#' # Example usage
#' method1_results <- data.frame(win = c(3, 5), tie = c(1, 0), loss = c(2, 1))
#' method2_results <- data.frame(win = c(4, 4), tie = c(2, 1), loss = c(1, 3))
#' compare.results(method1 = method1_results, method2 = method2_results, 
#'                 names = c("Method A", "Method B"), type = "wins")
#' 
#' @export
compare.results <- function(method1, method2, names, type) {
  
  # Initialize sums based on the comparison type
  if (type == "wins") {
    sum.method1 <- sum(method1$win)
    sum.method2 <- sum(method2$win)
  } else if (type == "ties") {
    sum.method1 <- sum(method1$tie)
    sum.method2 <- sum(method2$tie)
  } else if (type == "losses") {
    sum.method1 <- sum(method1$loss)
    sum.method2 <- sum(method2$loss)
  } else {
    stop("Invalid comparison type. Use 'wins', 'ties', or 'losses'.")
  }
  
  # Create a DataFrame to store the results
  results <- data.frame(
    Method = c(names[1], names[2]),
    Total = c(sum.method1, sum.method2),
    Best = c("", "")  # Initialize the "Best" column
  )
  
  # Determine which method is the best
  if (sum.method1 > sum.method2) {
    results$Best[1] <- "Yes"
    results$Best[2] <- "No"
  } else if (sum.method1 < sum.method2) {
    results$Best[1] <- "No"
    results$Best[2] <- "Yes"
  } else {
    results$Best[1] <- "Tie"
    results$Best[2] <- "Tie"
  }
  
  return(results)  # Return the DataFrame with results
}



#' Calculate Maximums and Minimums of Performance Metrics
#' 
#' This function calculates the maximum and minimum values for wins, ties, and losses
#' from a given results data frame. It identifies which method achieved these values.
#' 
#' @param res A data frame containing performance metrics. It must include the following columns:
#'            \itemize{
#'              \item \code{method}: Names of the methods.
#'              \item \code{win}: Count of wins for each method.
#'              \item \code{tie}: Count of ties for each method.
#'              \item \code{loss}: Count of losses for each method.
#'            }
#' 
#' @return A data frame with the following columns:
#' \item{Category}{The category of the metric (e.g., Max Win, Min Win, etc.).}
#' \item{Method}{The method corresponding to the maximum or minimum value in the respective category.}
#' \item{Value}{The maximum or minimum value for the respective category.}
#' 
#' @examples
#' # Example usage
#' results_df <- data.frame(
#'   method = c("Method A", "Method B", "Method C"),
#'   win = c(5, 3, 8),
#'   tie = c(2, 1, 4),
#'   loss = c(1, 0, 2)
#' )
#' calculate.max.min(results_df)
#' 
#' @export
calculate.max.min <- function(res) {
  # Maximums
  max.win.value <- max(res$win)
  method.max.win <- res$method[which(res$win == max.win.value)]
  
  max.tie.value <- max(res$tie)
  method.max.tie <- res$method[which(res$tie == max.tie.value)]
  
  max.loss.value <- max(res$loss)
  method.max.loss <- res$method[which(res$loss == max.loss.value)]
  
  # Minimums
  min.win.value <- min(res$win)
  method.min.win <- res$method[which(res$win == min.win.value)]
  
  min.tie.value <- min(res$tie)
  method.min.tie <- res$method[which(res$tie == min.tie.value)]
  
  min.loss.value <- min(res$loss)
  method.min.loss <- res$method[which(res$loss == min.loss.value)]
  
  # Create a data frame with the results
  results <- data.frame(
    Category = c("Max Win", "Min Win", "Max Tie", "Min Tie", "Max Loss", "Min Loss"),
    Method = c(method.max.win[1], method.min.win[1], method.max.tie[1], method.min.tie[1], method.max.loss[1], method.min.loss[1]),
    Value = c(max.win.value, min.win.value, max.tie.value, min.tie.value, max.loss.value, min.loss.value)
  )
  
  return(results)
}



#' Process Maximum and Minimum Metrics from a CSV File
#' 
#' This function reads a CSV file containing performance metrics for various methods,
#' categorizes the data into different method types, and calculates the maximum and
#' minimum values for wins, ties, and losses for each category.
#' 
#' @param file A character string representing the path to the CSV file that contains
#'             performance metrics. The file should have a column named \code{method},
#'             along with \code{win}, \code{tie}, and \code{loss} columns.
#' @param measure A character string that indicates the measure associated with the
#'                results being processed (e.g., "clp", "mlp").
#' 
#' @return A data frame containing the following columns:
#' \item{measure}{The measure associated with the results.}
#' \item{Max_Min}{Categories of metrics (e.g., max_win, min_win, etc.).}
#' \item{Methods}{The method corresponding to the maximum or minimum value in the respective category.}
#' \item{Value}{The maximum or minimum value for the respective category.}
#' 
#' @examples
#' # Example usage
#' result <- process_max_min("path/to/your/data.csv", "clp")
#' print(result)
#' 
#' @export
process_max_min <- function(file, measure) {
  
  # Initialize an empty data frame to store final results
  final_results <- data.frame(Max_Min = c("max_win", "min_win",
                                          "max_tie", "min_tie",
                                          "max_loss", "min_loss"))
  res <- data.frame(read.csv(file))
  
  # Create a list to hold results for each method category
  results_list <- list()
  
  # Calculate results for each method category
  method_categories <- list(
    random = res[grepl("Ra", res$method), ],
    hierarquicos = res[grepl("^H", res$method), ],
    nao_hierarquicos = res[grepl("^NH", res$method), ],
    jaccard = res[grepl("J", res$method), ],
    rogers = res[grepl("Ro", res$method), ],
    knn = res[grepl("K", res$method), ],
    tr = res[grepl("T", res$method), ]
  )
  
  # Loop through each category to calculate max/min
  for (name in names(method_categories)) {
    results <- calculate.max.min(method_categories[[name]])
    final_results = cbind(final_results,
                          Methods = results$Method,
                          Value = results$Value)
  }
  
  final_results = data.frame(measure, final_results)
  return(final_results)
}




