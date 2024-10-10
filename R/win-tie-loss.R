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


#' Compute Win-Tie-Loss Summary
#'
#' This function calculates the win, tie, and loss summary between pairs of 
#' methods based on their scores for a given measure type. 
#'
#' @param data A data frame containing the scores of different methods.
#' @param measure.type An integer indicating the measure type (1 or 2) which 
#'   defines the win/loss criteria.
#'
#' @return A data frame summarizing the number of wins, ties, and losses for each method.
#' @export
#'
#' @examples
#' name.file = "~/WinTieLoss/Data/clp.csv"
#' data = data.frame(read.csv(name.file))
#' data = data[,-1]
#' methods.names = colnames(data)
#'
#' df_res.mes <- wtl.measures()
#' filtered_res.mes <- filter(df_res.mes, names == "clp")
#' measure.type = as.numeric(filtered_res.mes$type)
#' 
#' res = win.tie.loss.compute(data = data, measure.type)
#' res$method <- factor(res$method, levels = methods.names)
#' res <- res[order(res$method), ]
#' 
#' save = paste(FolderResults, "/clp.csv", sep="")
#' write.csv(res, save, row.names = FALSE)
#'
#' wtl = c("win", "tie", "loss")
#' colnames(res) = wtl 
#' 
#' save = paste(FolderResults, "/clp.pdf", sep="")
#' win.tie.loss.plot(data = res, 
#'                   names.methods = methods.names, 
#'                   name.file = save, width = 18, height = 10, 
#'                   bottom = 2, left = 11, top = 0, right = 1, 
#'                   size.font = 2.0,wtl = wtl)
#' 
#' 
win.tie.loss.compute <- function(data, measure.type) {
  
  # Replace NA values with 0
  data[is.na(data)] <- 0
  
  # Create all possible combinations of column pairs
  combinacoes <- expand.grid(col1 = colnames(data), col2 = colnames(data))
  
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
  final.certo = data.frame(filter(final, !(final$name.method.1 == final$name.method.2)))
  
  # Calculate win, tie, and loss based on measure type
  if(measure.type == 1){
    resultado <- final.certo %>%
      mutate(
        win = if_else(score.method.1 > score.method.2, 1, 0),
        tie = if_else(score.method.1 == score.method.2, 1, 0),
        loss = if_else(score.method.1 < score.method.2, 1, 0)
      )
  } else {
    resultado <- final.certo %>%
      mutate(
        win = if_else(score.method.1 < score.method.2, 1, 0),
        tie = if_else(score.method.1 == score.method.2, 1, 0),
        loss = if_else(score.method.1 > score.method.2, 1, 0)
      )
  }
  
  # Summarize results by method
  res.final <- resultado %>%
    group_by(name.method.1) %>%
    dplyr::summarise(win = sum(win),
                     tie = sum(tie),
                     loss = sum(loss)) %>%
    arrange(-win)
  
  # Rename the first column to "method"
  names(res.final)[1] = "method"
  res.final = data.frame(res.final)
  
  return(res.final)
}


#' Plot Win-Tie-Loss Barplot
#'
#' This function generates a barplot visualizing the win-tie-loss summary 
#' for different methods. The resulting plot provides a clear graphical 
#' representation of the performance of various methods in terms of wins, ties, 
#' and losses. The plot is saved as a PDF file.
#'
#' @param data A data frame containing the win-tie-loss summary, where each row 
#' corresponds to a method, and each column corresponds to the counts of wins, 
#' ties, and losses.
#' @param names.methods A vector of method names to be displayed along the 
#' y-axis of the plot.
#' @param name.file The name of the output PDF file, including the path where 
#' the file will be saved.
#' @param max.value A numeric value indicating the maximum limit for the x-axis. 
#' This should correspond to the highest value of the win-tie-loss counts for 
#' proper visualization.
#' @param width The width of the plot in inches.
#' @param height The height of the plot in inches.
#' @param bottom Margin size (in lines) for the bottom of the plot.
#' @param left Margin size (in lines) for the left of the plot.
#' @param top Margin size (in lines) for the top of the plot.
#' @param right Margin size (in lines) for the right of the plot.
#' @param size.font Font size for labels, method names, and axis text.
#' @param wtl A character vector indicating the labels for the respective 
#' categories: wins, ties, and losses. Default is `c("win", "tie", "loss")`.
#'
#' @return A PDF file containing the win-tie-loss barplot saved at the specified 
#' location. The plot includes a legend and reference lines to aid in 
#' interpretation.
#' 
#' @export
#'
#' @examples 
#' # Define the file path and read the data
#' name.file <- "~/WinTieLoss/Data/clp.csv"
#' data <- read.csv(name.file)
#' data <- data[,-1]  # Remove the first column if not needed
#' 
#' # Get method names from the data frame
#' methods.names <- colnames(data)
#'
#' # Calculate win-tie-loss measures
#' df_res.mes <- wtl.measures()
#' filtered_res.mes <- filter(df_res.mes, names == "clp")
#' measure.type <- as.numeric(filtered_res.mes$type)
#' 
#' # Compute win-tie-loss summary
#' res <- win.tie.loss.compute(data = data, measure.type)
#' res$method <- factor(res$method, levels = methods.names)
#' res <- res[order(res$method), ]
#' 
#' # Save results to CSV
#' save <- paste(FolderResults, "/clp.csv", sep="")
#' write.csv(res, save, row.names = FALSE)
#'
#' # Define win-tie-loss labels
#' wtl <- c("win", "tie", "loss")
#' colnames(res) <- wtl 
#' 
#' # Generate and save the barplot
#' save <- paste(FolderResults, "/clp.pdf", sep="")
#' win.tie.loss.plot(data = res, 
#'                   names.methods = methods.names, 
#'                   name.file = save, 
#'                   max.value = 600,  # Set the maximum x-axis value
#'                   width = 18, 
#'                   height = 10, 
#'                   bottom = 2, 
#'                   left = 11, 
#'                   top = 0, 
#'                   right = 1, 
#'                   size.font = 2.0, 
#'                   wtl = wtl)
#' 
#' 
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



