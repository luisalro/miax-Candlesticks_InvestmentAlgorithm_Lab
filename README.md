### Introduction

When making trading decisions, we can utilize several different information sources on our technical analysis. One of these sources is OHLC (open, high, low, close) data. Candlestick charts can be plotted to extract patterns from OHLC data for any tradable instrument.

A candlestick pattern is a movement in prices shown graphically on a candlestick chart that some believe can predict a particular market movement.

![alt text](https://static.ffbbbdc6d3c353211fe2ba39c9f744cd.com/wp-content-learn/uploads/2020/11/22163923/Bearish-and-Bullish-Candlestick.jpg)

### Instructions


For each asset, each day, buy at the opening price and sell when the first of the following events occurs:

- Assets go up 3 cents (stop profit)

- The asset falls 10 cents (stop loss)

If none of the above occurs, sell at closing price.

Be careful, there will be positive and negative days at the same time, in these cases, we suppose that you play the stop loss first.

The capital that we invest in each asset, every day, must be € 30,000.

The commission for each purchase and sale will be 0.0003 * capital.

### Deliverable 

A R script that generates a dataframe with the following structure (for all assets) with the following indexes per row:
                                
![My Image](output.png)

And plot the accumulated profit per asset. For example:

![My Image](MAP.png)






 

