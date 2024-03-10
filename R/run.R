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
# Katholieke Universiteit Leuven Campus Kulak Kortrijk Belgium               #
# Medicine Department - https://kulak.kuleuven.be/                           #
# https://kulak.kuleuven.be/nl/over_kulak/faculteiten/geneeskunde            #
#                                                                            #
##############################################################################

rm(list=ls())

FolderRoot = "~/Analise-HPMLD"
FolderScripts = "~/Analise-HPMLD/R"
FolderData = "~/Analise-HPMLD/Data-2"
FolderWTL = "~/Analise-HPMLD/WTL"

setwd(FolderScripts)
source("win-tie-loss.R")

# random.dataframe()

setwd(FolderData)
current_dir <- getwd()
files <- list.files(full.names = TRUE) 
full_paths <- sapply(files, function(file) normalizePath(file))
methods.names = c("method1", "method2", "method3", "method4", "method5")
measure.type = 1

# calcula o número de win-tie-loss para todos os arquivos na pasta
# plota o gráfico para todos os arquivos na pasta
i = 1
while(i<=length(full_paths)){
  
  df = data.frame(read.csv(full_paths[i]))
  df = df[,-1]
  
  # compute win tie loss
  res.1 = compute.win.tie.loss(data = df, measure.type)
  
  #here you must put the method's order
  res.1$method <- factor(res.1$method, levels = methods.names)
  
  # reorder
  res.1 <- res.1[order(res.1$method), ]
  
  # save
  save = paste(FolderWTL, "/measure-1.csv", sep="")
  write.csv(res.1, save, row.names = FALSE)
  
  # you can change win, tie, loss to you language mother
  wtl = c("win", "tie", "loss")
  colnames(res.1) = wtl 
  
  # here you must change the following parameters:
  # width
  # height 
  # bottom
  # left
  # top
  # right
  # size.font
  # They must be changed to fit the PDF
  save = paste(FolderWTL, "/measure-1.pdf", sep="")
  plot.win.tie.loss(data = res.1, 
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

cat("\n")




