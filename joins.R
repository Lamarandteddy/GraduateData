# Joins in R using dplyr
# Load necessary libraries
library(tidyverse) # for data manipulation and visualization
library(nycflights13) # for datasets related to NYC flights

# Display the first few rows of the datasets to get a sense of the data
head(airlines)
head(airports)
head(planes)
head(weather)

# Let's join the airline name into the flights table
# First, select relevant columns from the flights dataset
flights2 <- flights %>% 
        select(year:day, hour, origin, dest, tailnum, carrier)

# Now perform a left join to add airline names
# A left join includes all rows from the left table (flights2) and matched rows from the right table (airlines)
flights_with_airlines <- flights2 %>%
        left_join(airlines, by = "carrier")

# View the first few rows of the joined data
head(flights_with_airlines)

# Note: The default behavior of dplyr join functions is a natural join
# Demonstrating with a left join between flights2 and weather data
# This will join the data on common column names
flights_weather_join <- flights2 %>%
        left_join(weather)

# View the first few rows of the joined data
head(flights_weather_join)

# Compute the average delay by destination
# Then join this info with the airports data frame to show spatial distribution of delays
avg_delay_table <- flights %>% 
        group_by(dest) %>%
        summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>%
        arrange(-avg_delay)

# Visualizing average delay on a map of the United States
# Note: We use a right join here to ensure we get all airports, even those without flight data
joined_data <- airports %>%
        right_join(avg_delay_table, c("faa" = "dest")) %>%
        filter(lon > -140) # Filter for continental US

# Plotting using ggplot
joined_data %>%
        ggplot(aes(lon, lat, color = avg_delay, size = avg_delay)) +
        borders("state") +
        geom_point() +
        coord_quickmap() +
        labs(title = "Average Flight Delays by US Airport",
             x = "Longitude",
             y = "Latitude",
             color = "Avg Delay",
             size = "Avg Delay")

# Save the plot if needed
# ggsave("flight_delays_map.png", plot = last_plot(), width = 10, height = 6)

