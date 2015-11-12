setwd("~/Documents/projects/fundamental data")
library(ggplot2)

data <- read.csv("fundamentalData.csv")
data <- subset(data[!is.na(data$Market.Cap),])
data <- subset(data[!is.na(data$Gross.Profit..ttm.),])
data <- subset(data[data$Gross.Profit..ttm.!="N/A",])

# market cap
data$Market.Cap <- as.numeric(gsub("B", "", data$Market.Cap))

boxplot(data[data$Market.Cap<40,]$Market.Cap)
ggplot(data, aes(x='',y=Market.Cap)) + geom_boxplot() + 
  labs(title="Market Cap of all S&P 500 companies") + 
  xlab("") + ylab("Market Cap in billions") + 
  theme(plot.title = element_text(face="bold",size=20))

majorityCap <- data[data$Market.Cap<40,]
ggplot(majorityCap, aes(Market.Cap)) + geom_bar(binwidth=1)
ggplot(majorityCap, aes(Market.Cap)) + geom_freqpoly(binwidth=1) + 
  labs(title="Market Cap of majorities") + 
  xlab("Market Cap in billions") + ylab("Number of Companies") + 
  theme(axis.title = element_text(face="bold",size=15),
        plot.title = element_text(face="bold",size=20))

data$ticker[order(-data$Market.Cap)][1:100]

top100 <- data[order(-data$Market.Cap),][1:15,]

ggplot(top100, aes(x='',y=Market.Cap,fill=ticker)) + 
  geom_bar(width=1,stat="identity") + 
  coord_polar(theta="y") + 
  geom_text(data=top100, aes(x='',y = Market.Cap/2 + c(0, cumsum(Market.Cap)[-length(Market.Cap)]), 
                label = ticker), size=5) + 
  labs(title="Market Cap of top 15 companies in billions") + 
  xlab("") + ylab("") + 
  theme(plot.title = element_text(face="bold",size=20)) 

# gross profit
convertBillion <- function(x) {
  if (grepl("B", x)) {
    x <- as.numeric(gsub("B", "", x))
    x <- x*1000.
  }
  else {
    x <- as.numeric(gsub("M", "", x))
  }
}

data$Gross.Profit..ttm. <- sapply(data$Gross.Profit..ttm., convertBillion)

boxplot(data$Gross.Profit..ttm.)
ggplot(data, aes(x='',y=Gross.Profit..ttm.)) + geom_boxplot() + 
  labs(title="Gross Profit of all S&P 500 companies") + 
  xlab("") + ylab("Gross Profit in millions") + 
  theme(plot.title = element_text(face="bold",size=20))

majority <- data[data$Gross.Profit..ttm.<6000,]

ggplot(majority, aes(Gross.Profit..ttm.)) + geom_bar(binwidth=30)
ggplot(majority, aes(Gross.Profit..ttm.)) + geom_freqpoly(binwidth=50) + 
  labs(title="Gross Profit of majorities") + 
  xlab("Gross Profit in millions") + ylab("Number of Companies") + 
  theme(axis.title = element_text(face="bold",size=15),
        plot.title = element_text(face="bold",size=20))

ggplot(top100, aes(x='',y=Gross.Profit..ttm.,fill=ticker)) + 
  geom_bar(width=1,stat="identity") + 
  coord_polar(theta="y") + 
  geom_text(data=top100, aes(x='',y = Gross.Profit..ttm./2 + c(0, cumsum(Gross.Profit..ttm.)[-length(Gross.Profit..ttm.)]), 
                             label = ticker), size=5) +
  labs(title="Gross Profit of top 15 companies in millions") + 
  xlab("") + ylab("") + 
  theme(plot.title = element_text(face="bold",size=20)) 

# net income
data$Net.Income.Avl.to.Common..ttm. <- sapply(data$Net.Income.Avl.to.Common..ttm., convertBillion)

boxplot(data[data$Net.Income.Avl.to.Common..ttm.<1500 & data$Net.Income.Avl.to.Common..ttm.>-500,]$Net.Income.Avl.to.Common..ttm.)

ggplot(data, aes(x='',y=Net.Income.Avl.to.Common..ttm.)) + geom_boxplot() + 
  labs(title="Net Income of all S&P 500 companies") + 
  xlab("") + ylab("Net Income in millions") + 
  theme(plot.title = element_text(face="bold",size=20))

majorityNetIncome <- data[data$Net.Income.Avl.to.Common..ttm.<1500 & data$Net.Income.Avl.to.Common..ttm.>-500,]

ggplot(majorityNetIncome, aes(Net.Income.Avl.to.Common..ttm.)) + geom_bar(binwidth=30)
ggplot(majorityNetIncome, aes(Net.Income.Avl.to.Common..ttm.)) + geom_freqpoly(binwidth=40) + 
  labs(title="Net Income of majorities") + 
  xlab("Net Income in millions") + ylab("Number of Companies") + 
  theme(axis.title = element_text(face="bold",size=15),
        plot.title = element_text(face="bold",size=20))

ggplot(top100, aes(x='',y=Net.Income.Avl.to.Common..ttm.,fill=ticker)) + 
  geom_bar(width=1,stat="identity") + 
  coord_polar(theta="y") + 
  geom_text(data=top100, aes(x='',y = Net.Income.Avl.to.Common..ttm./2 + c(0, cumsum(Net.Income.Avl.to.Common..ttm.)[-length(Net.Income.Avl.to.Common..ttm.)]), 
                             label = ticker), size=3) + 
  labs(title="Net Income of top 15 companies in millions") + 
  xlab("") + ylab("") + 
  theme(plot.title = element_text(face="bold",size=20)) 


