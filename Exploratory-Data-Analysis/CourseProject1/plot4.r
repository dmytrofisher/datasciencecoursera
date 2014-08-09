## Builds on one sheet:
##		1) Global active power [Y axis, kilowatts] - household global minute-averaged active power
##		   dependence from time [X axis, minutes]
##		2) Voltage [Y axis, volts] dependence from time [X axis, minutes]
##		3) Energy metering data [Y axis, watt-hour, 3 kinds] dependence from time [X axis, minutes]
## 		   Energy metering:
##		   - [Black] Corresponds to the kitchen, containing mainly a dishwasher, an oven and 
##					 a microwave	(hot plates are not electric but gas powered)
##		   - [Red]	 Corresponds to the laundry room, containing a washing-machine, a tumble-drier,
##					 a refrigerator and a light. 	
##		   - [Blue]  Corresponds to an electric water-heater and an air-conditioner.
##		4) Global reactive power [Y axis, kilowatts] - household global minute-averaged reactive power
##		   dependence from time [X axis, minutes]
## Function receives HPC data via data-access-layer-function defined in "hpcdal.R"
## HPC database may be downloaded automatically if necessary
plot4 <- function(download.data = FALSE) {
		source("hpcdal.R")
		DT <- hpc.data.for("plot4", download.data)
		
		png("plot4.png", bg = "transparent")
        
        par(mfrow = c(2,2))
        with(DT, {
				## plot 1st
                plot(datetime, Global_active_power, type = "l"
                        , xlab = "", ylab = "Global Active Power")
				## plot 2nd
                plot(datetime, Voltage, type = "l"
                        , ylab = "Voltage")
				## plot 3rd
                plot(datetime, Sub_metering_1, type = "l"
                        , xlab = "", ylab = "Energy sub metering")
                lines(datetime, Sub_metering_2, col = "red")
                lines(datetime, Sub_metering_3, col = "blue")
                legend("topright", lwd = 2, bty = "n"
                        , col = c("black", "red", "blue")
                        , legend = names(DT)[c(5,6,7)])
				## plot 4th
                plot(datetime, Global_reactive_power, type = "l",lwd = 1)            
        })
                
        dev.off()       
        message("Plotting completed")  
}