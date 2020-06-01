# miax-candlesticks_algorithm

Candlestick algorithm development


Para cada activo, cada día, compra a precio de apertura y vende cuando ocurra el primer de los siguientes eventos: 
- El activo sube 3 céntimos (stop profit)
- El activo cae 10 céntimos (stop loss) 
Si no ocurre ninguno de los anteriores, vende a precio de cierre

Ojo, habrá días positivos y negativos a la vez, en estos casos, suponemos que toca primero el stop loss

El capital que invertimos en cada activo, cada día, debe ser 30.000 €
La comisión de cada compra y venta será de 0.0003 * capital

Entregable: Código que genere un dataframe con la siguiente estructura (para todos los activos) con los siguientes índices por fila:
                                
- Resultado medio por operación		
- Beneficio acumulado		          
- % días positivos		           
- % días negativos		            
- Horquilla superior media	    
- Horquilla inferior media		    
- Número de operaciones		            

Y grafique el beneficio acumulado por activo. 

 

