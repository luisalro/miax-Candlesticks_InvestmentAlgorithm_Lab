# miax-candlesticks_algorithm

## Candlestick algorithm development

### Instructions


For each asset, each day, buy at the opening price and sell when the first of the following events occurs:
- Assets go up 3 cents (stop profit)
- The asset falls 10 cents (stop loss)
If none of the above occurs, sell at closing price

Be careful, there will be positive and negative days at the same time, in these cases, we suppose that you play the stop loss first

The capital that we invest in each asset, every day, must be € 30,000
The commission for each purchase and sale will be 0.0003 * capital

### Deliverable 

Code that generates a dataframe with the following structure (for all assets) with the following indexes per row:
                                
- Average result per operation
- Accumulated benefit
- % positive days
- % negative days
- Medium top fork
- Middle lower fork
- Number of operations

 

