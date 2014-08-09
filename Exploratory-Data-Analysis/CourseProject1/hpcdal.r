## Household Power Consupmtion Data Access Layer

## Function returns HPC data for corresponding plot
## Data may be downloaded automatically if 'download' arg is 'TRUE'
## Also it verifies if user has 'data.table' package 
## if yes - function will load data much(!) faster using data.table:::fread
## otherwise it will use base libraries and this might take time
hpc.data.for <- function(plotIx, download = FALSE){
		## Check for exisence of HPC-database file
		## Dowload database if necessary
		if (!file.exists("household_power_consumption.txt")){
				if (!download) {
						stop("'Household Power Consuption' database was not found")
				}
				else {						
						download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
								, "exdata-data-household_power_consumption.zip")
						unzip("exdata-data-household_power_consumption.zip")
				}
		}

		## Check if 'data.table' package is available
		suppressWarnings(has.data.table <- require("data.table"))
		
		DT <- NULL
		## Load only columns which are necessary for given plot
		if (has.data.table) {	
				## Will disable warnings from 'fread' when it finds the NA char '?'
				suppressWarnings(DT <- fread("household_power_consumption.txt"				
						, sep = ";"
						, header = TRUE		
						, select = columns.for(plotIx)								
						, na.strings = c("?")))
		} 
		else {
				message("'data.table' package was not found")
				message("Using basic packages. It may take a little time")
				DT <- read.table("household_power_consumption.txt"				
						, sep = ";"
						, comment.char = ""
						, header = TRUE	
						, colClasses = c(rep("character", 2), rep("numeric", 7))
						, na.strings = c("?"))
				DT <- subset(DT, select = columns.for(plotIx))				
		}
    
		## Select rows specified in task
		DT <- subset(DT, Date == "1/2/2007" | Date == "2/2/2007")
		
		## Actually, there are no missing values for 1/2/2007 and 2/2/2007
		## So, it is just a fuse
		DT <- DT[complete.cases(DT),] 
						 
	
		if (plotIx == 1 | plotIx == "plot1") {
				## No need to parse date/time for plot-1
		}
		else {
				## Code in 'else' case is good for data.table too, but
				## I believe that 'data.table' methods written in C will work faster
				if (has.data.table) {
						DT[, datetime := parseTime(DT$Date, DT$Time)]
						DT[, Date := NULL]
						DT[, Time := NULL]			
				} 
				else {
						DT <- cbind(DT, datetime = parseTime(DT$Date, DT$Time))
						DT <- DT[-c(1,2)]
				}
		}
		return(DT)		
}

## Service function: 
## returns vector of indexes of columns necessary to build corresponding plot
columns.for <- function(ix = "plot4"){
		colNames <- NULL
		switch(ix, 
				plot1 = { return(c(1, 3)) },
				plot2 = { return(c(1:3)) },
				plot3 = { return(c(1:2, 7:9)) },
				plot4 = { return(c(1:9)) },								
		)
		stop("Wrong input")		
}

## Service function: 
## parse date/time in specific format defined in HPC database into POSIXct
parseTime <- function(dat, tim){
		as.POSIXct(strptime(paste(dat, tim), format="%d/%m/%Y %H:%M:%S"))
}



