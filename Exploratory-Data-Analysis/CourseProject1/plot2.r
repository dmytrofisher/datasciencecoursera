## Builds Global active power [Y axis, kilowatts] - household global minute-averaged active power
## dependence from time [X axis, minutes]
## Function receives HPC data via data-access-layer-function defined in "hpcdal.R"
## HPC database may be downloaded automatically if necessary
plot2 <- function(download.data = FALSE){
	source("hpcdal.R")
	DT <- hpc.data.for("plot2", download.data)
		
	png("plot2.png", bg = "transparent")
	plot(DT$datetime, DT$Global_active_power
		, type = "l"
		, xlab="", ylab = "Global Active Power (kilowatts)")
	dev.off()
	message("Plotting completed")
}