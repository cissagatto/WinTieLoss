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


#' Create a List of Evaluation Metrics
#'
#' This function creates a data frame containing the names of evaluation metrics,
#' their corresponding types, and the total count of metrics.
#' Each metric is categorized by its type, which indicates whether a higher
#' or lower value represents better performance.
#'
#' @return A data frame with the following columns:
#'   \itemize{
#'     \item \code{names}: A character vector of metric names.
#'     \item \code{type}: An integer vector representing the evaluation type of each metric.
#'   }
#'   The total number of metrics equals the length of the \code{names} vector.
#'
#' @details
#' The \code{type} vector categorizes metrics as follows:
#' \itemize{
#'   \item \code{1}: Metrics where a higher value indicates better performance.
#'   \item \code{0}: Metrics where a lower value indicates better performance.
#' }
#'
#' Below is a summary of the metrics and their evaluation types:
#'
#' \tabular{lll}{
#' \strong{Metric Name} \tab \strong{Type} \tab \strong{Interpretation} \cr
#' accuracy           \tab 1 \tab higher is better \cr
#' auprc_macro        \tab 1 \tab higher is better \cr
#' auprc_micro        \tab 1 \tab higher is better \cr
#' auprc_samples      \tab 1 \tab higher is better \cr
#' auprc_weighted     \tab 1 \tab higher is better \cr
#' average_precision  \tab 1 \tab higher is better \cr
#' clp                \tab 0 \tab lower is better \cr
#' coverage           \tab 0 \tab lower is better \cr
#' f1                 \tab 1 \tab higher is better \cr
#' hamming_loss       \tab 0 \tab lower is better \cr
#' macro_auc          \tab 1 \tab higher is better \cr
#' macro_F1           \tab 1 \tab higher is better \cr
#' macro_precision    \tab 1 \tab higher is better \cr
#' macro_recall       \tab 1 \tab higher is better \cr
#' margin_loss        \tab 0 \tab lower is better \cr
#' micro_auc          \tab 1 \tab higher is better \cr
#' micro_F1           \tab 1 \tab higher is better \cr
#' micro_precision    \tab 1 \tab higher is better \cr
#' micro_recall       \tab 1 \tab higher is better \cr
#' mlp                \tab 0 \tab lower is better \cr
#' one_error          \tab 0 \tab lower is better \cr
#' precision          \tab 1 \tab higher is better \cr
#' ranking_loss       \tab 0 \tab lower is better \cr
#' recall             \tab 1 \tab higher is better \cr
#' roc_auc_macro      \tab 1 \tab higher is better \cr
#' roc_auc_micro      \tab 1 \tab higher is better \cr
#' roc_auc_samples    \tab 1 \tab higher is better \cr
#' roc_auc_weighted   \tab 1 \tab higher is better \cr
#' subset_accuracy    \tab 1 \tab higher is better \cr
#' wlp                \tab 0 \tab lower is better \cr
#' }
#'
#' @examples
#' # Create the data frame of metrics
#' metric_df <- wtl.measures()
#'
#' # Display the resulting data frame
#' print(metric_df)
#'
#' @export
wtl.measures <- function() {
  
  # Define the metric names and their types
  names <- c("accuracy",
             "auprc_macro",
             "auprc_micro",
             "auprc_samples",
             "auprc_weighted",
             "average_precision",
             
             "clp",
             "coverage",
             
             "f1",
             
             "hamming_loss",
             
             "macro_auc",
             "macro_f1",
             "macro_precision",
             "macro_recall",
             
             "margin_loss",
             
             "micro_auc",
             "micro_f1",
             "micro_precision",
             "micro_recall",
             
             "mlp",
             "one_error",
             
             "precision",
             
             "ranking_loss",
             
             "recall",
             "roc_auc_macro",
             "roc_auc_micro",
             "roc_auc_samples",
             "roc_auc_weighted",
             "subset_accuracy",
             
             "wlp")
  
  type <- c(1, 
            1, 
            1, 
            1, 
            1, 
            1, 
            
            0, 
            0,
            
            1, 
            
            0,
            
            1, 
            1, 
            1, 
            1, 
            
            0,
            
            1, 
            1, 
            1, 
            1, 
            
            0, 
            0, 
            
            1, 
            
            0, 
            
            1, 
            1, 
            1, 
            1,
            1,
            1,
            
            0)
  
  # Create a data frame with the metric names and their types
  df <- data.frame(
    names = names,
    type = type,
    stringsAsFactors = FALSE
  )
  
  # Return the data frame
  return(df)
}

##############################################################################
# 
##############################################################################
