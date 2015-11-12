import pandas as pd
import re
from bs4 import BeautifulSoup
from urllib2 import urlopen, URLError

sp500 = pd.read_csv("S&P500.csv", header = 0)
tickers = sp500.Symbol

#tickers = ["AAPL", "GOOG", "WMT"]

keyStatistics = [
    "Market Cap ",
    #"Enterprise Value",
    #"Trailing P/E ",
    #"Forward P/E ",
    #"PEG Ratio ",
    #"Price/Sales (ttm)",
    "Price/Book (mrq)",
    #"Enterprise Value/Revenue (ttm)",
    #"Enterprise Value/EBITDA (ttm)",
    "Fiscal Year Ends",
    "Most Recent Quarter (mrq)",
    "Profit Margin (ttm)",
    "Operating Margin (ttm)",
    #"Return on Assets (ttm)",
    #"Return on Equity (ttm)",
    "Revenue (ttm)",
    #"Revenue Per Share (ttm)",
    #"Qtrly Revenue Growth (yoy)",
    "Gross Profit (ttm)",
    "EBITDA (ttm)",
    "Net Income Avl to Common (ttm)",
    #"Diluted EPS (ttm)",
    #"Qtrly Earnings Growth (yoy)",
    "Total Cash (mrq)",
    #"Total Cash Per Share (mrq)",
    "Total Debt (mrq)",
    #"Total Debt/Equity (mrq)",
    #"Current Ratio (mrq)",
    #"Book Value Per Share (mrq)",
    #"Operating Cash Flow (ttm)",
    #"Levered Free Cash Flow (ttm)",
    "Beta",
    #"52-Week Change",
    #"S&P500 52-Week Change",
    #"52-Week High ",
    #"52-Week Low ",
    #"50-Day Moving Average",
    #"200-Day Moving Average",
    #"Avg Vol (3 month)",
    #"Avg Vol (10 day)",
    #"Shares Outstanding",
    #"Float",
    "% Held by Insiders",
    "% Held by Institutions",
    #"Shares Short ",
    #"Short Ratio ",
    #"Short % of Float ",
    #"Shares Short (prior month)",
    #"Forward Annual Dividend Rate",
    #"Forward Annual Dividend Yield",
    #"Trailing Annual Dividend Yield",
    #"Trailing Annual Dividend Yield",
    #"5 Year Average Dividend Yield",
    #"Payout Ratio",
    #"Dividend Date",
    #"Ex-Dividend Date",
    #"Last Split Factor (new per old)",
    #"Last Split Date"
]

result = pd.DataFrame(index = tickers, columns = keyStatistics)

def getValue(allTd, keyStatistic):
    for t in allTd:
        tdValue = t.find(text=re.compile(re.escape("%s" % keyStatistic)))
        if tdValue:
            #print '"'+t.get_text()+'",'
            return tdValue.findNext('td').text
            #return tdValue.parent.nextSibling.text
    return "NA"

for ticker in tickers: 
    url = 'http://finance.yahoo.com/q/ks?s='+ticker+'+Key+Statistics'
    try:
        resp = urlopen(url)
    except URLError as e:
        raise Exception("Cannot open url.")    
    soup = BeautifulSoup(resp.read(), 'html.parser')
    allTd = soup.find_all('td',attrs={'class':'yfnc_tablehead1'})
    #
    for keyStatistic in keyStatistics:
        result.ix[ticker, keyStatistic] = getValue(allTd, keyStatistic)    
	
#print result 
result.to_csv("fundamentalData.csv", header=True, index=True, index_label="ticker")
