#plot 1
#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#group data by year
EmissionByYear <- aggregate(NEI$Emissions, by=list(NEI$year), FUN=sum)
colnames(EmissionByYear) <- c("Year","Emissions")

#Plot the data
png("plot1.png")
barplot(EmissionByYear$Emissions,EmissionByYear$Year, 
        xlab = "Year",
        ylab="Total Emission (ton)",
        main = "Total Emission by Year",
        names.arg = EmissionByYear$Year,
        col = "blue")
dev.off()

#plot 2
#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#get baltimore data
baltimoreData <- subset(NEI, fips == "24510")
baltEmissionByYear <- aggregate(baltimoreData$Emissions, by=list(baltimoreData$year), FUN=sum)
colnames(baltEmissionByYear) <- c("Year","Emissions")
#Plot the data
png("plot2.png")
with(baltEmissionByYear,
barplot(Emissions,Year, 
        xlab = "Year",
        ylab="Total Emission (ton)",
        main = "Total Emission by Year in Baltimore",
        names.arg = Year,
        col = "blue")
)
dev.off()

#plot 3
library(ggplot2)
#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#get baltimore data
baltimoreData <- subset(NEI, fips == "24510")
baltimoreTypeData <- aggregate(baltimoreData$Emissions, by=list(baltimoreData$year,baltimoreData$type), FUN=sum)
colnames(baltimoreTypeData) <- c("Year","Type","Emissions")
#plot the data
png("plot3.png")
with(baltimoreTypeData,
     qplot(Year, Emissions, group=Type, color=Type, geom=c("point","line"),ylab="Total Emissions", xlab="Year", main="Total Emissions in Baltimare by Type"))
dev.off()

#plot 4
#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
coalrows <- grepl("coal",SCC$Short.Name, ignore.case=TRUE)
coalData <- SCC[coalrows,]
combinedData <- merge(NEI,coalData, by="SCC")
coalYearData <- aggregate(combinedData$Emissions, by=list(combinedData$year), FUN=sum)
colnames(coalYearData) <- c("Year","Emissions")
#Plot the data
png("plot4.png")
with(coalYearData,
     barplot(Emissions,Year, 
             xlab = "Year",
             ylab="Total Emission (ton)",
             main = "Total Emission from coal related sources",
             names.arg = Year,
             col = "blue")
)
dev.off()

#plot 5
#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#get baltimore vehicle data
baltimoreData <- subset(NEI, fips == "24510" & type=="ON-ROAD")
baltEmissionByYear <- aggregate(baltimoreData$Emissions, by=list(baltimoreData$year), FUN=sum)
colnames(baltEmissionByYear) <- c("Year","Emissions")
#Plot the data
png("plot5.png")
with(baltEmissionByYear,
     barplot(Emissions,Year, 
             xlab = "Year",
             ylab="Total Emission (ton)",
             main = "Total Vehicle (on-road) Emission by Year in Baltimore",
             names.arg = Year,
             col = "blue")
)
dev.off()

#plot 6
#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#get LA data
laData <- subset(NEI, fips == "06037" & type=="ON-ROAD")
#get baltimore data
baltimoreData <- subset(NEI, fips == "24510" & type=="ON-ROAD")
laData$city <- "Los Anageles"
baltimoreData$city <- "Baltimore"
combinedData <- rbind(laData,baltimoreData)
EmissionByYear <- aggregate(combinedData$Emissions, by=list(combinedData$year,combinedData$city),FUN=sum)
colnames(EmissionByYear) <- c("Year","City","Emissions")
png("plot6.png")
qplot(Year, Emissions, data = EmissionByYear, group = City, 
     color = City, geom = c("point","line"), ylab = "Total Emission (ton)", 
     xlab = "Year", main = "Comparison of Vehicle Emissions by City") 
dev.off()


