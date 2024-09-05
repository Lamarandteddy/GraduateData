##########################################################
# Visually Exploring Data with ggplot2
##########################################################

# Install and load tidyverse package
install.packages("tidyverse")
library(ggplot2)

# Explore the diamonds dataset
?diamonds
data <- diamonds

# Plot the relationship between carats and price
qplot(carat, price, data = diamonds)

# Plot the relationship between carats and price, adding diamond clarity as a color dimension
qplot(carat, price, data = diamonds, color = clarity)

# Plot a histogram of carat size
qplot(carat, data = diamonds, geom = "histogram")

# Plot a histogram of price and add diamond color as a fill
qplot(price, data = diamonds, geom = "histogram", fill = color)


#########################################################################
# Do bigger engines = more fuel consumption?

# Load and inspect the mpg dataset
?mpg

# Create a scatterplot of displacement vs. highway mileage
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy))

# Create a scatterplot of highway mileage vs. number of cylinders
ggplot(data = mpg) +
        geom_point(mapping = aes(x = hwy, y = cyl))

# Create a scatterplot of displacement vs. highway mileage, color-coded by vehicle class
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Create a scatterplot of displacement vs. highway mileage, with manual aesthetic properties
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# Create a scatterplot of displacement vs. highway mileage, with manual aesthetic properties and size
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy), color = "blue", size = 5)

# Create a scatterplot of displacement vs. highway mileage, mapping a logical expression to color
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

# Create a scatterplot of displacement vs. highway mileage, highlighting specific points
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = displ > 5 & hwy > 21))

# Create a faceted plot of engine size by gas mileage across vehicle classifications
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy)) +
        facet_wrap(~ class, nrow = 2)

# Create a faceted plot of engine size by gas mileage, with a grid layout based on drive type and number of cylinders
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
        facet_grid(drv ~ cyl)

# Customize labels and title for the plot
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
        facet_grid(drv ~ cyl) +
        labs(title = "Automobile Fuel Efficiency by Number of Engine Cylinders and Drive Type") +
        xlab("Engine Displacement (in Liters)") +
        ylab("Highway Miles per Gallon")

# Use different geoms to create scatterplots and smooth lines
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
        geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
        geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# Combine geoms in a single plot using global mappings
ggplot(data = mpg, aes(x = displ, y = hwy)) +
        geom_point(aes(color = class)) +
        geom_smooth()


#################################
# Bar charts and statistical transformations

# Create a bar chart of the count for each cut category in the diamonds dataset
ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut))

# Create a bar chart of the count for each cut category, using stat_count()
ggplot(data = diamonds) +
        stat_count(mapping = aes(x = cut))

# Create a bar chart showing the proportion of each cut category
ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

# Create a bar chart with fill color to differentiate the bars
ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut, fill = cut))

# Create a bar chart with fill color based on diamond clarity
ggplot(data = diamonds) +
        stat_count(mapping = aes(x = cut, fill = clarity))

# Create a stacked bar chart of proportions for cut and clarity
ggplot(data = diamonds) +
        stat_count(mapping = aes(x = cut, fill = clarity), position = "fill")

# Create a dodged bar chart of counts for cut and clarity
ggplot(data = diamonds) +
        stat_count(mapping = aes(x = cut, fill = clarity), position = "dodge")

# Install and load RColorBrewer package for color palettes
install.packages("RColorBrewer")
library(RColorBrewer)

# Choose a palette and add it as a layer to the bar chart
ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") +
        scale_fill_brewer(palette = "Set1")

# Create a clean theme for the plot
ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") +
        scale_fill_brewer(palette = "Set1") +
        theme_classic()

# Fix the y-axis issue by adjusting the scale
ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") +
        scale_fill_brewer(palette = "Set1") +
        theme_classic() +
        scale_y_continuous(expand = c(0, 0))


################
# Scatterplot variations

# Create a scatterplot of displacement vs. highway mileage with jitter
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")


#################################
# Activity: Prepare for Problem Set 1
#################################

# Install and load the gapminder package
install.packages("gapminder")
library(gapminder)
?gapminder

# Explore the gapminder dataset
head(gapminder)
