## Builds histogram of Global active power - household global minute-averaged active power in kilowatts
## Function receives HPC data via data-access-layer-function defined in "hpcdal.R"
## HPC database may be downloaded automatically if necessary
plot1 <- function(download.data = FALSE){
		source("hpcdal.R")
		DT <- hpc.data.for("plot1", download.data)
		
		png("plot1.png", bg = "transparent")
		hist(as.numeric(DT$Global_active_power)
				, col = "red"				
				, xlab = "Global active power (kilowatts)"
				, main = "Global Active Power")
		dev.off()
		message("Plotting complete")		
}