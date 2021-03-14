# checking for data directory/file and creating it if it doesn’t exist
targetFolder <- 'IHEPC Data'
filename <- 'IHEPC_Data.zip'

# checking for data directory/file and creating it if it doesn’t exist

if(!file.exists(targetFolder)){
    if(!file.exists(filename)){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                      destfile = filename
        )
    }
    # Unzip the file
    unzip(filename)
}

# Create a sample of the dataset in order to extract
# the classes and the header

initial <- read.table(file.path("household_power_consumption.txt"),
                      header = TRUE,
                      sep = ";",
                      nrows = 100
)

header <- colnames(initial)
classes <- sapply(initial, class)

# read the subset dataset for the dates 1-2/2/2007

HPC <- read.table("household_power_consumption.txt",
                  col.names = header,
                  sep = ";",
                  colClasses = classes,
                  skip = grep("31/1/2007;23:59:00", readLines("household_power_consumption.txt")),
                  nrows = 2880
)

# Transform `Date` and `Time` in the proper format
# and paste them into `DateTime`
HPC$DateTime <- strptime(paste(HPC$Date, HPC$Time, sep = " "), "%d/%m/%Y %H:%M:%S")

### Plot 3

png(file = "plot3.png", width = 480, height = 480)

with(HPC,{
    plot(DateTime, Sub_metering_1,
         type = "l",
         xlab = "",
         ylab = "Energy sub meeting",
         col = "black")
    lines(DateTime, Sub_metering_2, col = "red")
    lines(DateTime, Sub_metering_3, col = "blue")
})

legend("topright",
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1,
       lwd=2.5,
       col=c("black", "red", "blue"))

dev.off()
