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


# rm(list=ls())


##############################
# 
##############################

FolderRoot = "~/WinTieLoss"
FolderScripts = "~/WinTieLoss/R"
FolderData = "~/WinTieLoss/Data"
FolderResults = "~/WinTieLoss/Results"



##############################
# 
##############################

#setwd(FolderScripts)
#source("libraries.R")
#source("utils.R")
#source("win-tie-loss.R")
#source("analysis.R")

library(WinTieLoss)


##############################
# to one csv file
##############################

name.file = "~/WinTieLoss/Data/clp.csv"
data = data.frame(read.csv(name.file))
data = data[,-1]
methods.names = colnames(data)

df_res.mes <- wtl.measures()
filtered_res.mes <- filter(df_res.mes, names == "clp")
measure.type = as.numeric(filtered_res.mes$type)


res = win.tie.loss.compute(data = data, measure.type)
res$method <- factor(res$method, levels = methods.names)
res <- res[order(res$method), ]

save = paste(FolderResults, "/clp.csv", sep="")
write.csv(res, save, row.names = FALSE)

wtl = c("win", "tie", "loss")
colnames(res) = wtl 

save = paste(FolderResults, "/clp.pdf", sep="")
win.tie.loss.plot(data = res, 
                  names.methods = methods.names, 
                  name.file = save, 
                  width = 18, 
                  height = 10, 
                  bottom = 2, 
                  left = 11, 
                  top = 0, 
                  right = 1, 
                  size.font = 2.0,
                  wtl = wtl)




##############################
# to many csv files
##############################

setwd(FolderData)
current_dir <- getwd()
files <- list.files(full.names = TRUE) 
file_names <- tools::file_path_sans_ext(basename(files))
full_paths <- sapply(files, function(file) normalizePath(file))

df_res.mes <- wtl.measures()
measure.type = as.numeric(df_res.mes$type)


i = 1
while(i<=length(full_paths)){
  
  cat("\n", i, " - ", full_paths[i])
  
  df = data.frame(read.csv(full_paths[i]))
  df = df[,-1]
  
  methods.names = colnames(df)
  
  # compute win tie loss
  res = win.tie.loss.compute(data = df, measure.type[i])
  
  #here you must put the method's order
  res$method <- factor(res$method, levels = methods.names)
  
  # reorder
  res <- res[order(res$method), ]
  
  # save
  save = paste(FolderResults, "/", file_names[i], ".csv", sep="")
  write.csv(res, save, row.names = FALSE)
  
  # you can change win, tie, loss to you language mother
  wtl = c("win", "tie", "loss")
  colnames(res) = wtl 
  
  # here you must change the following parameters:
  # width
  # height 
  # bottom
  # left
  # top
  # right
  # size.font
  # They must be changed to fit the PDF
  save = paste(FolderResults, "/", file_names[i], ".pdf", sep="")
  win.tie.loss.plot(data = res, 
                    names.methods = methods.names, 
                    name.file = save, 
                    width = 30, 
                    height = 40, 
                    bottom = 10, 
                    left = 23, 
                    top = 10, 
                    right = 3, 
                    size.font = 5.0,
                    wtl = wtl)
  
  # in the plot.win.tie.loss there is one arameterthat you
  # can change if the image is not fitting well the pdf
  # xlim = c(0, (max.value))
  # add somevalue into max.value and the plot will  fit
  
  i = i + 1
}




##############################
# SAVING IN EXCEL
##############################

# This script processes multiple CSV files containing method evaluation data.
# It reads each CSV file into a data frame, removes the "METHOD" column from 
# all but the first file, prefixes column names with their corresponding file 
# names, combines the data frames into one, and saves the result as an Excel 
# file named "combined_data.xlsx" in the specified directory.


# Set the directory where the CSV files are located
setwd("~/WinTieLoss/Results")

# List all CSV files
files <- list.files(pattern = "\\.csv$", full.names = TRUE)

# Read each CSV as a dataframe and store them all in a list
csv_list <- lapply(files, read_csv)

# Extract the names of the files (without extensions) to use as prefixes
file_names <- tools::file_path_sans_ext(basename(files))

# Process the files: remove the METHOD column from all except the first
for (i in seq_along(csv_list)) {
  if (i > 1) {
    # Remove the METHOD column (if present) in all except the first
    csv_list[[i]] <- csv_list[[i]][ , !names(csv_list[[i]]) %in% "METHOD"]
  }
  
  # Add the file name as a prefix to the columns (except METHOD)
  colnames(csv_list[[i]]) <- ifelse(
    colnames(csv_list[[i]]) == "METHOD", 
    "METHOD", 
    paste(file_names[i], colnames(csv_list[[i]]), sep = ".")
  )
}

# Combine the dataframes side by side (concatenating columns)
combined_data <- do.call(cbind, csv_list)

# Create a new workbook to save in Excel
wb <- createWorkbook()

# Add a worksheet
addWorksheet(wb, "Results")

# Write the combined data to the worksheet
writeData(wb, sheet = "Results", combined_data)

# Save the Excel file
saveWorkbook(wb, file = "~/WinTieLoss/Results/combined_data.xlsx", overwrite = TRUE)



##############################
# ANALYZING
##############################

# This script analyzes selected CSV files containing method evaluation data.
# It calculates the maximum and minimum values for each method and compares 
# the results between different methods, compiling them into a final data frame 
# for further analysis or reporting.

# Set the working directory
setwd("~/WinTieLoss/Results")

# List all CSV files in the directory
files <- list.files(pattern = "\\.csv$", full.names = TRUE)

# Select specific files by their indices
files.numbers <- c(3, 16, 22, 9, 10, 8)
selected_files <- files[files.numbers]

# Read the data from the 16th file into a data frame
res <- data.frame(read.csv(files[16]))

# Test the function with the data frame 'res' to calculate max and min
results <- calculate.max.min(res)
results

# Filter data for different methods and calculate max and min values
max.min.random <- res[grepl("Ra", res$method), ]
res.random <- calculate.max.min(max.min.random)

max.min.hierarchical <- res[grepl("^H", res$method), ]
res.hierarchical <- calculate.max.min(max.min.hierarchical)

max.min.non.hierarchical <- res[grepl("^NH", res$method), ]
res.non.hierarchical <- calculate.max.min(max.min.non.hierarchical)

max.min.jaccard <- res[grepl("J", res$method), ]
res.jaccard <- calculate.max.min(max.min.jaccard)

max.min.rogers <- res[grepl("Ro", res$method), ]
res.rogers <- calculate.max.min(max.min.rogers)

max.min.knn <- res[grepl("K", res$method), ]
res.knn <- calculate.max.min(max.min.knn)

max.min.threshold <- res[grepl("T", res$method), ]
res.threshold <- calculate.max.min(max.min.threshold)

# Combine the maximum results for different methods
max_win <- rbind(hierarchical = res.hierarchical[1,], 
                 non.hierarchical = res.non.hierarchical[1,], 
                 random = res.random[1,], 
                 jaccard = res.jaccard[1,], 
                 rogers = res.rogers[1,], 
                 knn = res.knn[1,], 
                 threshold = res.threshold[1,])
max_win <- max_win[, -1]  # Remove the first column (method names)
max_win

# Compare results between hierarchical and non-hierarchical methods
win_h_nh <- compare.results(method1 = max.min.hierarchical, 
                            method2 = max.min.non.hierarchical, 
                            names = c("H", "NH"), 
                            type = "wins")
win_h_nh 

# Compare results between Jaccard and Rogers methods
win_j_ro <- compare.results(method1 = max.min.jaccard, 
                            method2 = max.min.rogers, 
                            names = c("J", "Ro"), 
                            type = "wins")
win_j_ro

# Compare results between KNN and Threshold methods
win_k_t <- compare.results(method1 = max.min.knn, 
                           method2 = max.min.threshold, 
                           names = c("K", "T"), 
                           type = "wins")
win_k_t

# Compare results for random methods
win_ra <- compare.results(method1 = max.min.random, 
                          method2 = max.min.random, 
                          names = c("H.Ra", "NH.Ra"), 
                          type = "wins")
win_ra

# Combine wins from all comparisons
wins <- rbind(win_h_nh, win_j_ro, win_k_t)


##############################
# ANALYZING
##############################

# This script analyzes selected CSV files containing method evaluation data.
# It calculates the maximum and minimum values for each method and compiles the results 
# into a single data frame. The final results are displayed and can be saved to an 
# Excel file for further analysis or reporting.

# Set the working directory again
setwd("~/WinTieLoss/Results")

# List all CSV files again
files <- list.files(pattern = "\\.csv$", full.names = TRUE)
files.numbers <- c(3, 16, 22, 9, 10, 8)
selected_files <- files[files.numbers]

# Create a data frame to store final results
final_results <- data.frame(Max_Min = c("max_win", "min_win",
                                        "max_tie", "min_tie",
                                        "max_loss", "min_loss"))

# Iterate through selected files and calculate results
for (file in selected_files) {
  cat("\n", file)
  res <- data.frame(read.csv(file))
  results <- calculate.max.min(res)
  final_results <- cbind(final_results, 
                         Method = results$Method,
                         Value = results$Value)
}

final_results

# Uncomment to save the final results to Excel
# write_xlsx(final_results, "final_results.xlsx")


##############################
# ANALYZING
##############################

# This script processes selected CSV files containing method evaluation data.
# It uses the 'process_max_min' function to calculate the maximum and minimum values 
# for different methods, and saves the results to separate Excel files for each method.

# Set your working directory
setwd("~/WinTieLoss/Results")

# List all CSV files in the directory
files <- list.files(pattern = "\\.csv$", full.names = TRUE)

# Specify the indices of the files to be selected
files.numbers <- c(3, 16, 22, 9, 10, 8)
selected_files <- files[files.numbers]

# Process and save results for each method using the specified function
clp.res = process_max_min(selected_files[1], "clp")  # Process CLP method
write_xlsx(clp.res, "clp.xlsx")  # Save results to CLP Excel file

mlp.res = process_max_min(selected_files[2], "mlp")  # Process MLP method
write_xlsx(mlp.res, "mlp.xlsx")  # Save results to MLP Excel file

wlp.res = process_max_min(selected_files[3], "wlp")  # Process WLP method
write_xlsx(wlp.res, "wlp.xlsx")  # Save results to WLP Excel file

map.res = process_max_min(selected_files[4], "map")  # Process MAP method
write_xlsx(map.res, "map.xlsx")  # Save results to MAP Excel file

mar.res = process_max_min(selected_files[5], "mar")  # Process MAR method
write_xlsx(mar.res, "mar.xlsx")  # Save results to MAR Excel file

maf1.res = process_max_min(selected_files[6], "maf1")  # Process MAF1 method
write_xlsx(maf1.res, "maf1.xlsx")  # Save results to MAF1 Excel file


##############################
# ANALYZING
##############################

# This script analyzes method names contained in the 'final_results' data frame. 
# It counts occurrences of specific prefixes or substrings within method names and 
# displays the counts. Additionally, it summarizes how often each method appears 
# in the data frame.

df <- final_results  # Store the final results data frame
methods <- unlist(df)  # Flatten the data frame into a vector of method names

# 1) Count how many times T and K appear (regardless of prefixes and suffixes)
tk_count <- sum(grepl("T", methods)) + sum(grepl("K", methods))

# 2) Count how many times Ro and J appear (regardless of what comes before or after)
ro_j_count <- sum(grepl("Ro", methods)) + sum(grepl("J", methods))

# 3) Count how many times H and NH appear (regardless of what comes before or after)
h_nh_count <- sum(grepl("\\bH\\b", methods)) + sum(grepl("NH", methods))

# 4) Count how many times G appears
g_count <- sum(grepl("G", methods))

# 5) Count how many times Lo appears
lo_count <- sum(grepl("Lo", methods))

# 6) Count how many times T appears
t_count <- sum(grepl("T", methods))

# 7) Count how many times Ra appears
ra_count <- sum(grepl("\\bRa\\b", methods))

# 8) Count how many times K appears
k_count <- sum(grepl("K", methods))

# 9) Count how many times J appears
j_count <- sum(grepl("J", methods))

# 10) Count how many times Ro appears
ro_count <- sum(grepl("Ro", methods))

# 11) Count how many times H appears (as a prefix or alone)
h_count <- sum(grepl("\\bH\\b", methods))

# 12) Count how many times NH appears
nh_count <- sum(grepl("NH", methods))

# Display results for T and K
cat("Count of T and K:", tk_count, "\n")
# Display results for Ro and J
cat("Count of Ro and J:", ro_j_count, "\n")
# Display results for H and NH
cat("Count of H and NH:", h_nh_count, "\n")

# Display individual counts
cat("Count of G:", g_count, "\n")
cat("Count of Lo:", lo_count, "\n")
cat("Count of T:", t_count, "\n")
cat("Count of K:", k_count, "\n")
cat("Count of J:", j_count, "\n")
cat("Count of Ra:", ra_count, "\n")
cat("Count of Ro:", ro_count, "\n")
cat("Count of H:", h_count, "\n")
cat("Count of NH:", nh_count, "\n")

# Count how many times each method appears in the data frame
methods_counts <- table(c(df$CLP_Methods, df$MLP_Methods, df$WLP_Methods, 
                          df$MACRO_PRECISION_Methods, df$MACRO_RECALL_Methods, 
                          df$MACRO_F1_Methods))

# Sort the results in alphabetical order
sorted_methods_counts <- sort(methods_counts)
sorted_methods_counts

