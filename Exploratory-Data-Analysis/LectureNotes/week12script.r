##===========================##
##         Week 1 - 2        ##
##     Exploratory Graphs    ##
##===========================##

cc <- c("numeric", "character", "factor", "numeric", "numeric")
pollution <- read.csv("data/avgpm25.csv", colClasses = cc)

if (!file.exists("./images")){
	dir.create("./images")
}
	
## Five number summary
message("PM2.5 Five number summary:")
print(summary(pollution$pm25))

## Boxplot
png("images/w12_boxplot1.png")
boxplot(pollution$pm25, col = "blue")
dev.off()

## Histogram
png("images/w12_histogram1.png")
hist(pollution$pm25, col = "green")
dev.off()

png("images/w12_histogram2.png")
hist(pollution$pm25, col = "green")
rug(pollution$pm25)
dev.off()

png("images/w12_histogram3.png")
hist(pollution$pm25, col = "green", breaks = 100)
rug(pollution$pm25)
dev.off()

## Overlaying Features
png("images/w12_boxplot2.png")
boxplot(pollution$pm25, col = "blue")
abline(h = 12)
dev.off()

png("images/w12_histogram4.png")
hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2)
abline(v = median(pollution$pm25), col = "red", lwd = 4)
dev.off()

## Barplot
png("images/w12_barplot1.png")
barplot(table(pollution$region), col = "orange"
	, main = "Number of Counties in Each Region")
dev.off()

## Multiple boxplots
png("images/w12_boxplot3.png")
boxplot(pm25 ~ region, data = pollution, col = "red")
dev.off()

### Multiple Histograms
png("images/w12_histogram5.png")
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")
dev.off()

## Scatterplot
png("images/w12_scatterplot1.png")
with(pollution, plot(latitude, pm25))
abline(h = 12, lwd = 2, lty = 2)
dev.off()

png("images/w12_scatterplot2.png")
with(pollution, plot(latitude, pm25, col = region))
abline(h = 12, lwd = 2, lty = 2)
dev.off()

### Multiple Scatterplots
png("images/w12_scatterplot3.png", width = 960)
par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))
dev.off()


