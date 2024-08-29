##############################################################################
# Copyright (C) 2024                                                         #
#                                                                            #
# This code is free software: you can redistribute it and/or modify it under #
# the terms of the GNU General Public License as published by the Free       #
# Software Foundation, either version 3 of the License, or (at your option)  #
# any later version. This code is distributed in the hope that it will be    #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of     #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General   #
# Public License for more details.                                           #
#                                                                            #
# Prof. Elaine Cecilia Gatto | Prof. Ricardo Cerri | Prof. Mauri Ferrandin   #
# Prof. Celine Vens | Prof. Felipe Nakano Kenji                              #
#                                                                            #
# Federal University of São Carlos - UFSCar - https://www2.ufscar.br         #
# Campus São Carlos - Computer Department - DC - https://site.dc.ufscar.br   #
# Post Graduate Program in Computer Science - PPGCC                          # 
# http://ppgcc.dc.ufscar.br - Bioinformatics and Machine Learning Group      #
# BIOMAL - http://www.biomal.ufscar.br                                       #
#                                                                            #
##############################################################################

# rm(list=ls())

FolderRoot = "~/WinTieLoss"
FolderScripts = "~/WinTieLoss/R"
FolderData = "~/WinTieLoss/Data"
FolderResults = "~/WinTieLoss/Results"


setwd(FolderScripts)
source("libraries.R")
source("utils.R")
source("win-tie-loss.R")



##############################
# para um unico arquivo
##############################
name.file = "~/WinTieLoss/Data/clp.csv"
data = data.frame(read.csv(name.file))
data = data[,-1]
methods.names = colnames(data)

df_res.mes <- measures()
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
# para vários arquivos
##############################
setwd(FolderData)
current_dir <- getwd()
files <- list.files(full.names = TRUE) 
file_names <- tools::file_path_sans_ext(basename(files))
full_paths <- sapply(files, function(file) normalizePath(file))



# calcula o número de win-tie-loss para todos os arquivos na pasta
# plota o gráfico para todos os arquivos na pasta
i = 1
while(i<=length(full_paths)){
  
  df = data.frame(read.csv(full_paths[i]))
  df = df[,-1]
  
  # compute win tie loss
  res = win.tie.loss.compute(data = df, measure.type)
  
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
                    width = 18, 
                    height = 10, 
                    bottom = 2, 
                    left = 11, 
                    top = 0, 
                    right = 1, 
                    size.font = 2.0,
                    wtl = wtl)
  
  # in the plot.win.tie.loss there is one arameterthat you
  # can change if the image is not fitting well the pdf
  # xlim = c(0, (max.value))
  # add somevalue into max.value and the plot will  fit
  
  i = i + 1
}

