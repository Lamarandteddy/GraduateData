#Problem Set 4 group work
#Names in Group: # Names in group: Jonathan Thompson, Alex Graf, Nicolas House, Faysal Bulbul, Daniel Adiele, John Kleine-Kracht

# Problem 1: Create a Date-Quarter Function in R

# Install the lubridate package if not installed already

# Loading lubridate package
library(lubridate)

# Defining date_quarter function
date_quarter <- function(dates) {
  # Check if dates is a character vector
  if (!is.character(dates)) {
    stop("Input must be a character vector of dates in the format 'YYYY-MM-DD'")
  }
  
  # Converting dates to Date objects
  dates <- as.Date(dates, format = "%Y-%m-%d")
  
  # Checking for invalid dates
  if (any(is.na(dates))) {
    stop("Invalid date(s) found in the input vector.")
  }
  
  # Extracting quarter for each date using lubridate function
  quarters <- quarters(dates)
  
  return(quarters)
}

#Print examples
print(date_quarter("2019-01-01"))  # Returning "Q1"
print(date_quarter("2011-05-23"))  # Returning "Q2"
print(date_quarter("1978-09-30"))  # Returning "Q3"
print(date_quarter("invalid-date")) # Returning "error message"

