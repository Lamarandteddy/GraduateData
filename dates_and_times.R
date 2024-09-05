# Dates and Times in R with lubridate

# Installing and loading necessary packages
install.packages("nycflights13")  # Flight data for New York City in 2013

library(tidyverse)   # Includes ggplot2, dplyr, etc. for data manipulation and visualization
library(lubridate)   # Simplifies working with dates and times
library(nycflights13) # Contains the flights dataset

# Basic lubridate functions for creating date objects from strings
# ymd(), mdy(), and dmy() automatically parse dates from strings in different formats
ymd("2017-01-31")    # Year-month-day format
mdy("January 31st, 2017") # Month-day-year format, flexible with text
dmy("31-Jan-2017")   # Day-month-year format

# Lubridate can also parse dates from numbers without quotes
ymd(20170131)        # Year-month-day in a continuous number format

# Adding time to dates
# Lubridate functions like mdy_hm() can parse date-time strings
mdy_hm("01/31/17 08:05") # Parses month-day-year hour:minute format

# Specifying time zones with dates
ymd(20170131, tz = "UTC") # Creating a date in the UTC time zone

# Working with flight data: Extracting and combining date-time components
# Selecting date-time components from the flights dataset
flights %>%
        select(year, month, day, hour, minute)

# Combining these components into a single date-time object using make_datetime()
flights %>%
        select(year, month, day, hour, minute) %>%
        mutate(departure = make_datetime(year, month, day, hour, minute))

# Handling times in a non-standard format (e.g., 1245 for 12:45)
# Defining a function to handle times represented as a single number
make_datetime_100 <- function(year, month, day, time) {
        make_datetime(year, month, day, time %/% 100, time %% 100)
}

# Creating a cleaned up dataframe with proper date-time formats for departures and arrivals
flights_dt <- flights %>%
        filter(!is.na(dep_time), !is.na(arr_time)) %>%
        mutate(
                dep_time = make_datetime_100(year, month, day, dep_time),
                arr_time = make_datetime_100(year, month, day, arr_time),
                sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
                sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>%
        select(origin, dest, ends_with("delay"), ends_with("time"))

# Data Visualization with ggplot2
# Plotting departure times across different days
flights_dt %>%
        ggplot(aes(dep_time)) +
        geom_freqpoly(binwidth = 86400) # 86400 seconds in a day

# Plotting departure times within a single day
flights_dt %>%
        filter(dep_time < ymd(20130102)) %>%
        ggplot(aes(dep_time)) +
        geom_freqpoly(binwidth = 600) # 600 seconds (10 minutes)

# Switching between dates and times
as_datetime(today())  # Converts today's date to a datetime object
as_date(now())        # Converts the current time to a date object

# Parsing strings: Handling valid and invalid dates
ymd(c("2010-10-10", "bananas")) # "bananas" returns NA as it's not a valid date

# Time zones and their importance
today(tzone = "EST")  # The current date in Eastern Standard Time

# Extracting components from date-time objects
datetime <- ymd_hms("2016-07-08 12:34:56") # Creating a date-time object

year(datetime)   # Extracting the year
month(datetime)  # Extracting the month
day(datetime)    # Extracting the day of the month
mday(datetime)   # Same as day()
yday(datetime)   # Extracting the day of the year
wday(datetime)   # Extracting the day of the week
hour(datetime)   # Extracting the hour
minute(datetime) # Extracting the minute
second(datetime) # Extracting the second

# Analyzing departure times across a week
flights_dt %>%
        mutate(wday = wday(dep_time, label = TRUE)) %>%
        ggplot(aes(x = wday))
