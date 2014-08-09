## Builds Energy metering data [Y axis, watt-hour, 3 kinds] dependence from time [X axis, minutes]
## Energy metering:
##	1) [Black] Corresponds to the kitchen, containing mainly a dishwasher, an oven and 
##	           a microwave (hot plates are not electric but gas powered)
##	2) [Red]   Corresponds to the laundry room, containing a washing-machine, a tumble-drier,
##	           a refrigerator and a light.
##	3) [Blue]  Corresponds to an electric water-heater and an air-conditioner.
## Function receives HPC data via data-access-layer-function defined in "hpcdal.R"
## HPC database may be downloaded automatically if necessary
plot3 <- function(download.data = FALSE){
	source("hpcdal.R")
	DT <- hpc.data.for("plot3", download.data)
	
	png("plot3.png", bg = "transparent")
	with(DT, plot(datetime, Sub_metering_1, type = "l"
		, xlab = "", ylab = "Energy sub metering"))
	with(DT, lines(datetime, Sub_metering_2, col = "red"))
	with(DT, lines(datetime, Sub_metering_3, col = "blue")) 
	legend("topright"
		, lwd = 2
		, col = c("black", "red", "blue")
		, legend = names(DT)[c(1,2,3)])
	dev.off()
	message("Plotting completed")  
}