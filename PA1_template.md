---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---


## Loading and preprocessing the data
activity <- read.csv(file="activity.csv", header=TRUE)
activity$date <- as.Date(activity$date)
activity$interval <- as.factor(activity$interval)


## What is mean total number of steps taken per day?
> mean(steps_per_day$sum)
[1] 9354.23
> median(steps_per_day$sum)
[1] 10395


## What is the average daily activity pattern?

interval   sum
104      835 10927

## Imputing missing values
NA_values <- activity[!complete.cases(activity),]
> nrow(NA_values)
[1] 2304


## Are there differences in activity patterns between weekdays and weekends?
install.packages("timeDate")
library(timeDate)
complete_activity$day_of_week <- ifelse(isWeekday(complete_steps_per_day$date)==TRUE, "weekday", "weekend")

# Make a panel plot containnig a time-series plot of the 5-minute interval
# and the average number of steps taken across all weekdays or weekends
library(lattice)
xyplot(steps ~ interval | day_of_week, layout = c(1, 2), data=complete_activity, type="l")
