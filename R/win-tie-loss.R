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



###############################################################
#
###############################################################
random.dataframe <- function(){
  FolderData = "~/Analise-HPMLD/Data-2"
  num_linhas <- 20
  num_colunas <- 5
  valores <- matrix(runif(num_linhas * num_colunas), nrow = num_linhas)
  df <- as.data.frame(valores)
  methods <- paste0("method", 1:5)
  datasets <- paste0("dataset", 1:20)
  colnames(df) <- methods
  df = data.frame(datasets, df)
  write.csv(df, paste(FolderData, "/measure-1.csv", sep=""), row.names = FALSE)
}

###############################################################
#
###############################################################
compute.win.tie.loss <- function(data, measure.type) {
  
  data[is.na(data)] <- 0
  
  # Criar todas as combinações possíveis de pares de colunas
  combinacoes <-
    expand.grid(col1 = colnames(data), col2 = colnames(data))
  
  # Aplicar uma função para criar os dataframes com os resultados
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
  
  # Resetar os rownames
  rownames(final) <- NULL
  
  final.certo = data.frame(filter(final, !(
    final$name.method.1 == final$name.method.2
  )))
  
  
  if(measure.type == 1){
    
    cat("\n| ", measure.type)
    # measuare.type == 1
    # win: m1 > m2
    # loss : m1 < m2 
    
    resultado <- final.certo %>%
      mutate(
        win = if_else(score.method.1 > score.method.2, 1, 0),
        tie = if_else(score.method.1  == score.method.2, 1, 0),
        loss = if_else(score.method.1 < score.method.2, 1, 0)
      )
  } else {
    
    cat("\n| ", measure.type)
    
    # measuare.type == 1
    # win: m1 < m2
    # loss : m1 > m2 
    
    resultado <- final.certo %>%
      mutate(
        win = if_else(score.method.1 < score.method.2, 1, 0),
        tie = if_else(score.method.1  == score.method.2, 1, 0),
        loss = if_else(score.method.1 > score.method.2, 1, 0)
      )
  }
  
  
  res.final <- resultado %>%
    group_by(name.method.1) %>%
    dplyr::summarise(win = sum(win),
                     tie = sum(tie),
                     loss = sum(loss)) %>%
    arrange(-win)
  names(res.final)[1] = "method"
  res.final = data.frame(res.final)
  
  return(res.final)
}



###############################################################
#
###############################################################
plot.win.tie.loss <- function(data, names.methods, name.file, 
                              width, height, bottom, 
                              left, top, right, 
                              size.font, wtl) {
  #data = wlt.roc.auc
  soma = apply(data[,-1], 1, sum)
  max.value = soma[1]
  half.value = soma[1]/2
  max.value = soma[1]+18
  
  res = data.frame(t(data))
  colnames(res) = names.methods
  res = res[-1, ]
  
  pdf(name.file, width, height)
  par(mar=c(bottom, left, top, right))
  colors = c("#00CCFF", "#009900", "#990066")
  barplot(
    as.matrix(res),
    col = colors,
    horiz = TRUE,
    names.arg = names.methods,
    las = 1,
    border = "#888888",
    xlim = c(0, (max.value)),
    cex.names = size.font,
    cex.axis = size.font,
    axisnames = TRUE
  )
  abline(v = half.value, col = "white")
  abline(v = 115, col = "white")
  legend("right", wtl, cex = size.font, fill = colors)
  dev.off()
  
}

