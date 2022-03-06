This lab was created  by Guillermo Melendez , professor from mIA-X master's degree at BME Institute. It necessarily needed to be programmed in R.

Check out his LinkedIn profile.

<a href="https://www.linkedin.com/in/dptoestrategia/" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/linkedin-%230077B5.svg?&style=for-the-badge&logo=linkedin&logoColor=white" /></a> 

### Introduction

When making trading decisions, we can utilize several different information sources on our technical analysis. One of these sources is OHLC (open, high, low, close) data. Candlestick charts can be plotted to extract patterns from OHLC data for any tradable instrument.




A candlestick pattern is a movement in prices shown graphically on a candlestick chart that some believe can predict a particular market movement.¹


### Instructions

### 1st part

For each asset, each day, buy at the opening price and sell when the first of the following events occurs:

- Assets go up 3 cents (stop profit)

- The asset falls 10 cents (stop loss)

If none of the above occurs, sell at closing price.

Be careful, there will be positive and negative days at the same time, in these cases, we suppose that you play the stop loss first.

The capital that we invest in each asset, every day, must be € 30,000.

The commission for each purchase and sale will be 0.0003 * capital.

### Deliverable 

Code that generates a dataframe with the following structure (for all assets) with the following indexes per row:
                                
- Average result per operation
- Accumulated benefit
- % positive days
- % negative days
- Medium top fork
- Middle lower fork
- Number of operations

### 2nd part

Based on the candlestick algorithm above, add the price_departure parameter.

For each asset, each day, if the price_departure is> = 0.75, buy at the opening price and sell when the first of the following events occurs:

- Assets up 3 cents (stop profit).

- The asset falls 10 cents (stop loss).

If none of the above occurs, sell at closing price

Be careful, there will be positive and negative days at the same time, in these cases, suppose you touch the stop loss first.

The capital that we invest in each asset, every day, must be € 30,000.

The commission for each purchase and sale will be 0.0003 * capital.

### Deliverable

Code that generates the same dataframe as in the previous exercise. And the same graph.




 

