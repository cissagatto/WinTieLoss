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


#' Generate a Random Data Frame
#'
#' This function generates a random data frame with a predefined number of rows 
#' and columns, simulating different methods and datasets. The resulting data 
#' frame is saved as a CSV file.
#'
#' @import dplyr
#' @import purrr
#' @import tibble
#' @importFrom stats filter runif
#' @importFrom utils read.csv write.csv install.packages
#' @importFrom grDevices pdf dev.off
#' @importFrom graphics abline barplot legend par
#'
#' @return A data frame with random values.
#' @export
#'
#' @examples
#' rdf <- random.dataframe()
#' rdf
random.dataframe <- function(){
  
  # Define the folder path where the CSV file will be saved
  FolderData = "~/WinTieLoss/Data"
  
  # Define the number of rows and columns
  num_linhas <- 20
  num_colunas <- 5
  
  # Generate random values and convert them into a data frame
  valores <- matrix(runif(num_linhas * num_colunas), nrow = num_linhas)
  df <- as.data.frame(valores)
  
  # Define method and dataset names
  methods <- paste0("method", 1:5)
  datasets <- paste0("dataset", 1:20)
  
  # Assign column names
  colnames(df) <- methods
  df = data.frame(datasets, df)
  
  # Save the data frame as a CSV file
  write.csv(df, paste(FolderData, "/random-data.csv", sep=""), row.names = FALSE)
}


#' Compute Win-Tie-Loss Summary for Methods
#'
#' This function calculates the win, tie, and loss summary between all pairs of 
#' methods based on their scores for a given measure type. 
#' 
#' For each pair of methods, it compares their scores:
#' - If `measure.type = 1`: higher scores are considered better (win if method1 > method2)
#' - If `measure.type = 0`: lower scores are considered better (win if method1 < method2)
#'
#' @param data A data frame containing the scores of different methods (columns are methods, rows are observations). 
#'   NA values are replaced by 0.
#' @param measure.type An integer indicating the measure type:
#'   \itemize{
#'     \item \code{1}: Higher scores are better.
#'     \item \code{0}: Lower scores are better.
#'   }
#'
#' @return A data frame summarizing the number of wins, ties, and losses for each method.
#'   The returned data frame has columns:
#'   \itemize{
#'     \item \code{method}: Method name.
#'     \item \code{win}: Total number of wins for this method.
#'     \item \code{tie}: Total number of ties for this method.
#'     \item \code{loss}: Total number of losses for this method.
#'   }
#'
#' @import dplyr
#' @import purrr
#' @import tibble
#' @importFrom utils write.csv read.csv
#'
#' @examples
#' \dontrun{
#' # Load example data
#' name.file = "~/WinTieLoss/Data/random-data.csv"
#' data = data.frame(read.csv(name.file))
#' data = data[,-1]  # Remove first column if needed
#' methods.names = colnames(data)
#'
#' # Load metric types
#' df_res.mes <- wtl.measures()
#' filtered_res.mes <- dplyr::filter(df_res.mes, names == "clp")
#' measure.type = as.numeric(filtered_res.mes$type)
#' 
#' # Compute Win-Tie-Loss summary
#' res = win.tie.loss.compute(data = data, measure.type = measure.type)
#' res$method <- factor(res$method, levels = methods.names)
#' res <- res[order(res$method), ]
#' 
#' # Save results to CSV
#' FolderResults <- "~/WinTieLoss/Results"
#' save = paste(FolderResults, "/clp.csv", sep = "")
#' write.csv(res, save, row.names = FALSE)
#'
#' # Plot results (optional)
#' wtl = c("win", "tie", "loss")
#' colnames(res) = wtl 
#' save = paste(FolderResults, "/clp.pdf", sep = "")
#' win.tie.loss.plot(
#'   data = res, 
#'   names.methods = methods.names, 
#'   name.file = save, 
#'   width = 18, height = 10, 
#'   bottom = 2, left = 11, top = 0, right = 1, 
#'   size.font = 2.0, wtl = wtl
#' )
#' }
#'
#' @export
win.tie.loss.compute <- function(data, measure.type) {
  
  # Replace NA values with 0
  data[is.na(data)] <- 0
  rownames(data) <- NULL
  
  # Create all possible combinations of columns (pairs of methods)
  combinations <- crossing(
    name.method.1 = colnames(data),
    name.method.2 = colnames(data)
  ) %>%
    filter(name.method.1 != name.method.2)  # Exclude comparisons of the same method
  
  # Compute win/tie/loss in a vectorized manner
  res <- map_dfr(1:nrow(combinations), function(i) {
    m1 <- combinations$name.method.1[i]
    m2 <- combinations$name.method.2[i]
    
    s1 <- data[[m1]]
    s2 <- data[[m2]]
    
    if (measure.type == 1) {
      # Higher scores are better
      tibble(
        name.method.1 = m1,
        win  = sum(s1 > s2),
        tie  = sum(s1 == s2),
        loss = sum(s1 < s2)
      )
    } else {
      # Lower scores are better
      tibble(
        name.method.1 = m1,
        win  = sum(s1 < s2),
        tie  = sum(s1 == s2),
        loss = sum(s1 > s2)
      )
    }
  })
  
  # Summarize results by method
  res.final <- res %>%
    group_by(name.method.1) %>%
    summarise(
      win = sum(win),
      tie = sum(tie),
      loss = sum(loss),
      .groups = "drop"
    ) %>%
    rename(method = name.method.1) %>%
    arrange(desc(win))
  
  return(as.data.frame(res.final))
}



#' Plot Win-Tie-Loss Barplot
#'
#' This function generates a barplot visualizing the Win-Tie-Loss summary 
#' for different methods. The resulting plot provides a clear graphical 
#' representation of each method’s performance in terms of wins, ties, 
#' and losses. The plot is automatically saved as a PDF file.
#'
#' @param data A data frame containing the win-tie-loss summary, where each row 
#' corresponds to a method, and each column corresponds to the counts of wins, 
#' ties, and losses.
#' @param names.methods A character vector of method names to be displayed along 
#' the y-axis of the plot.
#' @param name.file The name (including full path) of the output PDF file 
#' where the plot will be saved.
#' @param max.value A numeric value indicating the maximum limit for the x-axis. 
#' This should correspond to the highest win-tie-loss value for proper scaling.
#' @param width The width of the output PDF in inches.
#' @param height The height of the output PDF in inches.
#' @param bottom Bottom margin size (in lines) for the plot.
#' @param left Left margin size (in lines) for the plot.
#' @param top Top margin size (in lines) for the plot.
#' @param right Right margin size (in lines) for the plot.
#' @param size.font Font size for labels, method names, and axis text.
#' @param wtl A character vector indicating the labels for the respective 
#' categories: wins, ties, and losses. Default is \code{c("win", "tie", "loss")}.
#'
#' @return Invisibly returns the input data (for consistency), and saves 
#' a PDF file containing the Win-Tie-Loss barplot at the specified location. 
#' The plot includes a legend and reference lines for interpretation.
#'
#' @importFrom grDevices pdf dev.off
#' @importFrom graphics barplot legend abline par text axis
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Define the file path and read the data
#' name.file <- "~/WinTieLoss/Data/random-data.csv"
#' data <- read.csv(name.file)
#' data <- data[, -1]  # Remove the first column if not needed
#' 
#' # Get method names
#' methods.names <- colnames(data)
#'
#' # Calculate Win-Tie-Loss measures
#' df_res.mes <- wtl.measures()
#' filtered_res.mes <- dplyr::filter(df_res.mes, names == "clp")
#' measure.type <- as.numeric(filtered_res.mes$type)
#' 
#' # Compute Win-Tie-Loss summary
#' res <- win.tie.loss.compute(data = data, measure.type)
#' res$method <- factor(res$method, levels = methods.names)
#' res <- res[order(res$method), ]
#' 
#' # Save summary to CSV
#' FolderResults <- "~/WinTieLoss/Results"
#' save.path <- paste0(FolderResults, "/clp.csv")
#' write.csv(res, save.path, row.names = FALSE)
#'
#' # Define Win-Tie-Loss labels
#' wtl <- c("win", "tie", "loss")
#' colnames(res) <- wtl 
#' 
#' # Generate and save the barplot
#' pdf.path <- paste0(FolderResults, "/clp.pdf")
#' win.tie.loss.plot(
#'   data = res,
#'   names.methods = methods.names,
#'   name.file = pdf.path,
#'   max.value = 600,
#'   width = 18,
#'   height = 10,
#'   bottom = 2,
#'   left = 11,
#'   top = 0,
#'   right = 1,
#'   size.font = 2.0,
#'   wtl = wtl
#' )
#' }
win.tie.loss.plot <- function(data, names.methods, 
                              name.file, max.value,
                              width, height, bottom, 
                              left, top, right, 
                              size.font, wtl) {
  
  # Calculate the sum of win, tie, and loss for each method
  soma <- apply(data[,-1], 1, sum)  # Sum across rows, ignoring the first column
  half.value <- soma[1] / 2          # Calculate half of the first row's sum
  max.value <- max.value              # Ensure max.value is set
  
  # Transpose the data frame for plotting
  res <- data.frame(t(data))
  colnames(res) <- names.methods       # Set column names to method names
  res <- res[-1, ]                     # Remove the first row (which contains the original column names)
  
  # Create the barplot and save it as a PDF
  pdf(name.file, width, height)
  par(mar=c(bottom, left, top, right))  # Set margins
  colors <- c("#00CCFF", "#009900", "#990066")  # Define colors for bars
  barplot(
    as.matrix(res),
    col = colors,
    horiz = TRUE,
    names.arg = names.methods,
    las = 1,  # Horizontal labels
    border = "#888888",  # Border color for bars
    xlim = c(0, max.value),  # Set x-axis limit
    cex.names = size.font,  # Control font size for names
    cex.axis = size.font,    # Control font size for axis
    axisnames = TRUE         # Show axis names
  )
  
  # Add reference line at half value
  abline(v = half.value, col = "white")
  
  # Add a legend
  legend("right", wtl, cex = size.font, fill = colors)
  
  dev.off()  # Close the PDF device
}



