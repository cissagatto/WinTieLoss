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
#' @description
#' This function generates a random data frame with a predefined number of rows 
#' and columns, simulating the results of different methods across multiple datasets.
#' The generated data can be used for testing or demonstrating the Win–Tie–Loss
#' computation and plotting functions.
#'
#' @details
#' The function creates:
#' - 20 datasets (rows)
#' - 5 methods (columns)
#' 
#' Each cell contains a random value uniformly distributed between 0 and 1.
#' The resulting data frame is also saved as a CSV file in the directory
#' `~/WinTieLoss/Data/random-data.csv`.  
#'
#' This function is mainly designed for internal testing and examples within the
#' WinTieLoss package.
#'
#' @return A `data.frame` containing the generated random values, with:
#' \itemize{
#'   \item `datasets` – dataset names (dataset1, dataset2, …)
#'   \item `method1`, `method2`, … – random numeric values for each method
#' }
#'
#' @importFrom stats runif
#' @importFrom utils write.csv
#'
#' @examples
#' \dontrun{
#' #--------------------------------------------------------------
#' # Example: Generate random example data for testing
#' #--------------------------------------------------------------
#'
#' # Generate and save random dataset
#' df <- random.dataframe()
#'
#' # Display the first few rows
#' head(df)
#'
#' # Path to saved file
#' "~/WinTieLoss/Data/random-data.csv"
#'
#' # You can then use this file with:
#' #   win.tie.loss.compute()
#' #   win.tie.loss.plot()
#' }
#'
#' @export
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


#' Compute Win–Tie–Loss Summary for Methods
#'
#' @description
#' This function compares the performance of multiple methods across datasets by
#' calculating the **Win–Tie–Loss (WTL)** summary.  
#' It performs all pairwise comparisons between methods based on their scores,
#' counting how many times each method wins, ties, or loses relative to the others.
#'
#' The function is useful in benchmarking and performance evaluation studies,
#' where you want to summarize how often each method performs better or worse
#' than the others according to a given metric (e.g., accuracy, RMSE, F1-score).
#'
#' @details
#' The function expects a data frame where:
#' - Each **column** corresponds to a method.
#' - Each **row** corresponds to a dataset, experiment, or observation.
#'
#' Pairwise comparisons are performed for every combination of methods.
#' NA values are replaced with 0 before computation.
#'
#' If `measure.type = 1`, **higher values are better** (e.g., accuracy).  
#' If `measure.type = 0`, **lower values are better** (e.g., RMSE, error rate).
#'
#' @param data A `data.frame` containing the scores of different methods.
#'   - Columns represent methods.
#'   - Rows represent datasets or experimental runs.
#'   - NA values are replaced by 0.
#'
#' @param measure.type An integer (0 or 1) indicating the direction of optimization:
#'   \itemize{
#'     \item `1` – higher scores are better (wins if method1 > method2)
#'     \item `0` – lower scores are better (wins if method1 < method2)
#'   }
#'
#' @return A `data.frame` summarizing the number of wins, ties, and losses per method.
#' It has the following columns:
#' \itemize{
#'   \item `method` – the method name.
#'   \item `win` – total number of pairwise wins.
#'   \item `tie` – total number of pairwise ties.
#'   \item `loss` – total number of pairwise losses.
#' }
#'
#' @import dplyr
#' @importFrom utils read.csv write.csv
#'
#' @examples
#' \dontrun{
#' #--------------------------------------------------------------
#' # Example: Compute Win–Tie–Loss from random data
#' #--------------------------------------------------------------
#'
#' # 1. Load example dataset
#' data_path <- "~/WinTieLoss/Data/random-data.csv"
#' data <- data.frame(read.csv(data_path))
#' data <- data[, -1]  # Remove first column (dataset names)
#'
#' # 2. Define measure type
#' # Suppose lower is better (e.g., clp)
#' measure.type <- 0
#'
#' # 3. Compute Win–Tie–Loss summary
#' results <- win.tie.loss.compute(data = data, measure.type = measure.type)
#'
#' # 4. Sort by method
#' methods.names <- colnames(data)
#' results$method <- factor(results$method, levels = methods.names)
#' results <- results[order(results$method), ]
#'
#' # 5. Print results
#' print(results)
#'
#' # 6. Save to CSV
#' output_path <- "~/WinTieLoss/Results/wtl-summary.csv"
#' write.csv(results, output_path, row.names = FALSE)
#' }
#'
#' @export
win.tie.loss.compute <- function(data, measure.type) { 
  
  # Replace NA values with 0
  data[is.na(data)] <- 0
  
  # Create all possible combinations of column pairs
  combinacoes <- expand.grid(
    col1 = colnames(data),
    col2 = colnames(data)
  )
  
  # Apply a function to create data frames with results for each pair
  final <- do.call(rbind, apply(combinacoes, 1, function(row) {
    score.method.1 <- data[, row[1]]
    score.method.2 <- data[, row[2]]
    
    teste <- data.frame(
      name.method.1 = row[1],
      name.method.2 = row[2],
      score.method.1 = score.method.1,
      score.method.2 = score.method.2
    )
  }))
  
  # Reset row names
  rownames(final) <- NULL
  
  # Filter out rows where the methods are the same
  final.certo <- data.frame(
    dplyr::filter(final, !(final$name.method.1 == final$name.method.2))
  )
  
  # Calculate win, tie, and loss based on measure type
  if (measure.type == 1) {
    resultado <- final.certo %>%
      mutate(
        win  = if_else(score.method.1 > score.method.2, 1, 0),
        tie  = if_else(score.method.1 == score.method.2, 1, 0),
        loss = if_else(score.method.1 < score.method.2, 1, 0)
      )
  } else {
    resultado <- final.certo %>%
      mutate(
        win  = if_else(score.method.1 < score.method.2, 1, 0),
        tie  = if_else(score.method.1 == score.method.2, 1, 0),
        loss = if_else(score.method.1 > score.method.2, 1, 0)
      )
  }
  
  # Summarize results by method
  res.final <- resultado %>%
    group_by(name.method.1) %>%
    dplyr::summarise(
      win  = sum(win),
      tie  = sum(tie),
      loss = sum(loss)
    ) %>%
    arrange(-win)
  
  # Rename the first column to "method"
  names(res.final)[1] <- "method"
  
  res.final <- data.frame(res.final)
  
  return(res.final)
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



