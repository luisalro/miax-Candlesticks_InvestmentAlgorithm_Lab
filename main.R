# Ejercicio 7: Algoritmo de mechas

# Creamos un DF en el que guardaremos los datos de nuestra inversion.

inversion_ibex <- open

# Para cada activo, cada día, compra a precio de apertura y vende cuando ocurra el primero de los siguientes eventos: 
# El activo sube 3 céntimos (stop profit)
# El activo cae 10 céntimos (stop loss)
# Si no ocurre ninguno de los anteriores, vende a precio de cierre
# Ojo, habrá días positivos y negativos a la vez, en estos casos, supón que toca primero el stop loss
# El capital que invertimos en cada activo, cada día, debe ser 30.000 €
# La comisión de cada compra y venta será de 0.0003 * capital


for (columna in 2:dim(inversion_ibex)[2]){
  
  stop_profit <- which(high[,columna] >= open[,columna] + 0.03)
  stop_loss <- which(low[,columna] <= open[,columna] - 0.1)
  stop_profit_loss <- which(low[,columna] > open[,columna] - 0.1 & high[,columna] < open[,columna] + 0.03)
  
  for (fila in stop_profit_loss){
    numero_acciones <- 30000 %/% (open[fila,columna] * 1.0003)
    capital_entrada <- numero_acciones * open[fila,columna]
    capital_salida <- numero_acciones * close[fila,columna]
    inversion_ibex[fila,columna] <- numero_acciones * (close[fila,columna] - open[fila,columna]) - 0.0003 * capital_entrada - 0.0003 * capital_salida
  }
  
  if (length(stop_profit)>0){
    for (fila in stop_profit){
      numero_acciones <- 30000 %/% (open[fila,columna] * 1.0003)
      capital_entrada <- numero_acciones * open[fila,columna]
      capital_salida <- (open[fila,columna]+0.03)*numero_acciones
      inversion_ibex[fila,columna] <- numero_acciones * 0.03 - 0.0003 * capital_entrada - 0.0003 * capital_salida
    } 
  }
  
  if (length(stop_loss)>0){
    for (fila in stop_loss){
      numero_acciones <- 30000 %/% (open[fila,columna] * 1.0003)
      capital_entrada <- numero_acciones * open[fila,columna]
      capital_salida <- (open[fila,columna]-0.1)*numero_acciones
      inversion_ibex[fila,columna] <- numero_acciones * (-0.1) -0.0003*capital_entrada-0.0003*capital_salida
    }
  }
}

#Componemos la estrucutura del DF en el que tendremos el resumen de los resultados de nuestra inversión.

estructura <- c("Resultado medio por operación",
              "Beneficio Acumulado", 
              "% días positivos", 
              "% días negativos", 
              "Horquilla superior media", 
              "Horquilla inferior media", 
              "Número de operaciones")

inversion_ibex <- data.frame(inversion_ibex, row.names= "X.1")

algoritmo_mechas <- data.frame(head(inversion_ibex,7), row.names = estructura)

#Creamos una función para las horquillas superior e inferior media.

horquilla_media <- function(superior_inferior, col, open, high, low){
  
  if (superior_inferior == "superior"){
    horquilla_media <- high[,col]-open[,col]
    horquilla_media <- mean(horquilla_media, na.rm=TRUE)
  }else if (superior_inferior == "inferior"){
    horquilla_media <- open[,col]-low[,col]
    horquilla_media <- mean(horquilla_media, na.rm = TRUE)
  }
  
  return(horquilla_media)
}

# A partir del DF inversion_ibex , creamos un nuevo DF en el que limpiamos los datos.

inversion_ibex_total <- inversion_ibex
inversion_ibex_total[is.na(inversion_ibex_total)] <- 0
inversion_ibex_total[inversion_ibex_total!= 0] <- inversion_ibex_total[inversion_ibex_total != 0]

# Componemos el DF con el resumen de los resultados a partir de los cálculos obtenidos por el algoritmo de mechas

for (columna in 1:(dim(algoritmo_mechas)[2])){
  algoritmo_mechas[1, columna] <- mean(inversion_ibex[,columna], na.rm=TRUE)
  algoritmo_mechas[2, columna] <- cumsum(inversion_ibex_total[,columna])[dim(inversion_ibex_total)[1]]
  algoritmo_mechas[3, columna] <- length(which(inversion_ibex[,columna] >= 0)) / length(which(!is.na(inversion_ibex[,columna])))
  algoritmo_mechas[4, columna] <- length(which(inversion_ibex[,columna] < 0)) / length(which(!is.na(inversion_ibex[,columna])))
  algoritmo_mechas[5, columna] <- horquilla_media("superior",columna+1, open, high, low)
  algoritmo_mechas[6, columna] <- horquilla_media("inferior",columna+1, open, high, low)
  algoritmo_mechas[7, columna] <- length(which(!is.na(inversion_ibex[,columna])))

# Ploteamos el beneficio acumulado por activo
  
  plot(cumsum(inversion_ibex_total[,columna][inversion_ibex_total[,columna]!=0]), 
       type = "l", 
       main = names(algoritmo_mechas)[columna],
       ylab = "",
       xlab = "")
}

# Ajustamos el formato de los resultados redondeando las cifras

algoritmo_mechas <- round(algoritmo_mechas,4)

# Modificación del algoritmo anterior incluyendo el parámetro price_departures

# Cargamos el parámetro price_departures

setwd("~/Desktop/R/Enunciado de la práctica de R")
price_departures <- read.csv("price_departures.csv",header = T,sep=",",stringsAsFactors=FALSE,dec=".")

# Tratamos y limpiamos el dataset(cambio de formato en los datos para una mejor lectura, imputacion de 0s en NAs...)

price_departures<- rbind(price_departures, substr(colnames(price_departures),1,str_locate(colnames(price_departures),"_")-1))
price_departures[3954,][is.na(price_departures[3954,])] <- colnames(price_departures)[is.na(price_departures[3954,])]
price_departures[is.na(price_departures)] <- 0

for (columna in 3: dim(price_departures)[2]){
  if (price_departures[3954, columna] == price_departures[3954, columna-1]){
    for (fila in 1: dim(price_departures)[1]-1){
      price_departures[fila,columna-1] = as.numeric(price_departures[fila,columna]) + as.numeric(price_departures[fila,columna-1])
    }
  }
}
colnames(price_departures)<-price_departures[3954,]
price_departures <-price_departures[, unique(colnames(price_departures))]

# Creamos un DF en el que guardaremos los datos de nuestra inversion añadiendo el parámetro

inversion_ibex_parametro <- open

for (columna in 2:dim(inversion_ibex_parametro)[2]){
  
  stop_profit <- which(high[,columna] >= open[,columna] + 0.03)
  stop_loss <- which(low[,columna] <= open[,columna] - 0.1)
  stop_profit_loss <- which(low[,columna] > open[,columna] - 0.1 & high[,columna] < open[,columna] + 0.03)
  
  # Para cada activo, cada día, si el price_departure es >= 0.75, ocurrirán los eventos del ejercicio anterior. Sino, imputamos NAs.
  
  for (fila in stop_profit_loss){
    if(price_departures[fila, columna]>=0.75){
      numero_acciones <- 30000 %/% (open[fila,columna]*1.0003)
      capital_entrada <- numero_acciones * open[fila,columna]
      capital_salida <- close[fila,columna]*numero_acciones
      inversion_ibex_parametro[fila,columna] <- numero_acciones * (close[fila,columna]-open[fila,columna])-0.0003*capital_entrada-0.0003*capital_salida
    }else{
      inversion_ibex_parametro[fila,columna] <- NA
    }
  }
  
  
  if (length(stop_profit)>0){
    for (fila in stop_profit){
      if(price_departures[fila, columna]>=0.75){
        numero_acciones <- 30000 %/% (open[fila,columna] * 1.0003)
        capital_entrada <- numero_acciones * open[fila,columna]
        capital_salida <- (open[fila,columna]+0.03)*numero_acciones
        inversion_ibex_parametro[fila,columna] <- numero_acciones * 0.03 -0.0003*capital_entrada-0.0003*capital_salida
      }else{
        inversion_ibex_parametro[fila,columna] <- NA
      }
    } 
  }
  
  if (length(stop_loss)>0){
    for (fila in stop_loss){
      if(price_departures[fila, columna]>=0.75){
        numero_acciones <- 30000 %/% (open[fila,columna] * 1.0003)
        capital_entrada <- numero_acciones * open[fila,columna]
        capital_salida <- (open[fila,columna]-0.1)*numero_acciones
        inversion_ibex_parametro[fila,columna] = numero_acciones * (-0.1) -0.0003*capital_entrada-0.0003*capital_salida
      }else{
        inversion_ibex_parametro[fila,columna] = NA
      }
    }
  }
}

# Componemos la estrucutura del DF en el que tendremos el resumen de los resultados de nuestra inversión.

estructura <- c("Resultado medio por operación",
                "Beneficio Acumulado", 
                "% días positivos", 
                "% días negativos", 
                "Horquilla superior media", 
                "Horquilla inferior media", 
                "Número de operaciones")

inversion_ibex_parametro <- data.frame(inversion_ibex_parametro, row.names= "X.1")
algoritmo_mechas_parametro <- data.frame(head(inversion_ibex_parametro,7), row.names = estructura)

# A partir del DF inversion_ibex_parametro , creamos un nuevo DF en el que limpiamos los datos.

inversion_ibex_parametro_total <- inversion_ibex_parametro
inversion_ibex_parametro_total[is.na(inversion_ibex_parametro_total)] <- 0
inversion_ibex_parametro_total[inversion_ibex_parametro_total != 0] <- inversion_ibex_parametro_total[inversion_ibex_parametro_total != 0]

#Componemos el DF con el resumen de los resultados a partir de los cálculos obtenidos por el algoritmo de mechas con el parámetro price_departures.

for (columna in 1:(dim(algoritmo_mechas_parametro)[2])){
  algoritmo_mechas_parametro[1, columna] <- mean(inversion_ibex_parametro[,columna][], na.rm=TRUE)
  algoritmo_mechas_parametro[2, columna] <- cumsum(inversion_ibex_parametro_total[,columna])[dim(inversion_ibex_parametro_total)[1]]
  algoritmo_mechas_parametro[3, columna] <- length(which(inversion_ibex_parametro[,columna] >= 0)) / length(which(!is.na(inversion_ibex_parametro[,columna])))
  algoritmo_mechas_parametro[4, columna] <- length(which(inversion_ibex_parametro[,columna] < 0)) / length(which(!is.na(inversion_ibex_parametro[,columna])))
  algoritmo_mechas_parametro[5, columna] <- horquilla_media("superior",columna+1, open, high, low)
  algoritmo_mechas_parametro[6, columna] <- horquilla_media("inferior",columna+1, open, high, low)
  algoritmo_mechas_parametro[7, columna] <- length(which(!is.na(inversion_ibex_parametro[,columna])))
  
  # Ploteamos el beneficio acumulado por activo para el algoritmo con el parámetro aplicado.
  
  if (length(cumsum(inversion_ibex_parametro_total[,columna][inversion_ibex_parametro_total[,columna]!=0]>0))){
    plot(cumsum(inversion_ibex_parametro_total[,columna][inversion_ibex_parametro_total[,columna]!=0]), 
         type = "l", 
         main = names(algoritmo_mechas_parametro)[columna],
         ylab = "",
         xlab = "")
  }
}

# Ajustamos el formato de los resultados redondeando las cifras

algoritmo_mechas_parametro <- round(algoritmo_mechas_parametro,4)


