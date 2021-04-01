setwd("C:/Users/John/Desktop/repData")


# Loading and preprocessing the data
activity <- read.csv(file="activity.csv", header=TRUE)
activity$date <- as.Date(activity$date)
activity$interval <- as.factor(activity$interval)
# What is mean total number of steps taken per day?
# Calculate the total steps taken per day
library(plyr)
steps_per_day <- ddply(activity, .(date), summarise, sum = sum(steps, na.rm=T))
steps_per_day

# Make a histogram of the total number of steps taken per day
hist(totalSteps$steps,
     main = "Total Steps per Day",
     xlab = "Number of Steps")


# Calculate and report the mean and median of total steps taken per day
mean(steps_per_day$sum)
median(steps_per_day$sum)



# What is the average daily activity pattern?
# Make a time-series plot of the 5-minute interval and the average number of
# steps taken, averaged acoss all days.
library(ggplot2)
steps_per_interval <- ddply(activity, .(interval), summarise, sum = sum(steps, na.rm=T))
p <- ggplot(steps_per_interval, aes(x=interval, y=sum, group=1)) 
p + geom_line() + labs(title = "Average Steps per Day by 5-min Intervals, Oct-Nov 2012") + labs(x = "5-minute Intervals", y = "Average Number of Steps")

# Which 5-minute interval across all days contain the maximum number of steps
steps_per_interval[ which(steps_per_interval$sum==(max(steps_per_interval$sum))), ]

#Imputing Missing Values
# Calculate and report the total number of missing values in the dataset
NA_values <- activity[!complete.cases(activity),]
nrow(NA_values)


# Devise a strategy for filling in all of the missing values

# Calculate the mean for each interval
interval_mean <- ddply(activity, .(interval), summarise, mean = mean(steps, na.rm=T))
# Add the interval mean as a new variable to the activity dataset 
activity_with_interval_mean <- join(activity, interval_mean)


# Write function that will replace NA values with the interval mean
replace_NA <- function(dataset, variable, replacement) {
  for (i in 1:nrow(dataset)) {
    if (is.na(dataset[i, variable])) {
      dataset[i, variable] <- dataset[i, replacement]
    }
  }
  dataset
}
# Run the function on the dataset
complete_activity <- replace_NA(activity_with_interval_mean, variable=1, replacement=4)
complete_activity <- complete_activity[, -4]
head(complete_activity)


# Make a histogram of the total number of steps taken each day and
# and report the mean and median.
complete_steps_per_day <- ddply(complete_activity, .(date), summarise, sum = sum(steps))
complete_steps_per_day$sum <- round(complete_steps_per_day$sum)
hist(complete_steps_per_day$sum, ylab="Number of Days", col="red", xlab="Number of Steps", main="Histogram of Steps Per Day, Oct-Nov 2012")
mean(steps_per_day$sum)
mean(complete_steps_per_day$sum)
median(steps_per_day$sum)
median(complete_steps_per_day$sum)

#Are there differences in activity patterns between weekdays and weekends?
install.packages("timeDate")
library(timeDate)
complete_activity$day_of_week <- ifelse(isWeekday(complete_steps_per_day$date)==TRUE, "weekday", "weekend")

# Make a panel plot containnig a time-series plot of the 5-minute interval
# and the average number of steps taken across all weekdays or weekends
library(lattice)
xyplot(steps ~ interval | day_of_week, layout = c(1, 2), data=complete_activity, type="l")
