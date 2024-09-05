# Strings with stringr 

# Libraries
library(tidyverse)
library(stringr)

# Creating Strings
string1 <- "This is a string"
string2 <- 'It is proper practice to put a "quote" inside a string, using single quotes'

# Displaying string2
string2

# Note: R requires that strings are properly closed with matching quotes.
# Unfinished string (will cause an error)
# "this is a string without closing quotes

# The plus sign of death (+) in the R console indicates an incomplete command.
# This often happens when quotes or parentheses are not closed.

# Escaping Characters
# Use a backslash (\) to escape characters like quotes within a string.
doublequote <- "adding a backslash escapes the quote symbol \" like this"

# Printing vs. writeLines
# Printing a string shows its representation including escape characters.
print(doublequote)

# writeLines displays the string as it would appear in text.
writeLines(doublequote)

# Special Characters: New Lines and Tabs
# \n creates a new line, useful for formatting long strings.
# \t inserts a tab space, often used for indentation or formatting.

# Example: Biography of Hadley Wickham
textblock <- "Hadley Wickham is a statistician from New Zealand... [Biography Text]"

# Using writeLines to display the textblock with new lines and tabs.
writeLines(textblock)

# Unicode Characters
# Use \u followed by a hexadecimal code to represent Unicode characters.
micro <- "\u00b5"
micro  # Displays the micro symbol (µ)

# Special Characters Info
# For more information on special characters in R, use the help command.
?'\''

# Working with Character Vectors
# Strings can be stored in a character vector.
stringvector <- c("one string", "two strings", "three strings", "etc.")

# Combining Strings with str_c
# str_c() is used to concatenate strings together.

# Simple concatenation
str_c("x", "y")  # "xy"

# Using sep argument to define a separator
str_c("one", "two", "three", sep = ", ")  # "one, two, three"

# Dealing with Missing Values
# NA values in strings can cause issues. Use str_replace_na to handle them.
x <- c("abc", NA)
str_c(" | ", x, " | ")  # " | abc |  | NA | "
str_c(" | ", str_replace_na(x), " | ")  # " | abc |  | NA | "

# Collapsing a Vector into a Single String
# Use the collapse argument in str_c to combine a vector into one string.
str_c(c("x", "y", "z"), collapse = ", ")  # "x, y, z"

# Splitting Strings
# Use str_split to divide a string into parts based on a separator.
str_split("one two three", pattern = " ")  # Splits at spaces

# Subsetting Strings
# str_sub allows extracting or replacing substrings.
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)  # "App", "Ban", "Pea"
str_sub(x, -3, -1)  # "ple", "ana", "ear"

# Modifying Strings
# str_to_lower, str_to_upper, str_to_title for case conversion.
str_to_title(x)  # "Apple", "Banana", "Pear"

# Regular Expressions
# Regular expressions are patterns that describe sets of strings.

# Simple Pattern Matching
x <- c("apple", "banana", "pear")
str_view(x, "an")  # Highlights 'an' in each element of x

# Anchors: ^ for start, $ for end of string
str_view(x, "^a")  # Matches 'a' at the start of the string
str_view(x, "a$")  # Matches 'a' at the end of the string

# Escape Characters in Regex
# Double backslash (\\) is used to escape special characters in regex.
dot <- "\\."
str_view(c("abc", "a.c", "bef"), "a\\.c")  # Matches 'a.c'

# Brief Demo: Finding Colors in Sentences
# Using regular expressions to extract information from text.
sent <- stringr::sentences
colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(colors, collapse = "|")
has_color <- str_subset(sent, color_match)

matches <- str_extract(has_color, color_match)

# combine sentences and matches into a data frame
sentdf <- as.data.frame(cbind(has_color, matches))
colnames(sentdf)[1] <- "sent" 
sentences <- as.data.frame(sent)
sent_matches <- left_join(sentences, sentdf)

# Quick Check:        
  # how can we extract the first word of every sentence?
  first <- str_extract(sent, "^\\S+\\s")
  first <- as.data.frame(cbind(sent, first))
  colnames(first)[1] <- "sent"
  sent_matches <- left_join(sent_matches, first)
  
  # how can we extract all words ending with "ing"?
  ing <- str_extract(sent, "\\s+\\S+ing")
  ing <- as.data.frame(cbind(sent, ing))
  colnames(ing)[1] <- "sent"
  sent_matches <- left_join(sent_matches, ing)
  






