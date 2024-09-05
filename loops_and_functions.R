# Loops and Functions in R

# control structures in R -------------------------------------------------

# if:
if(<condition>) {
    # do something
} else {
    # do something else
}


if(<condition>) {
    # do something
} else if(<condition>) {
    # do something different
} else {
    # do something different
}



# If/Else structure to demonstrate conditional execution
x <- 5

# First structure
if (x > 3) {
    y <- 10
} else {
    y <- 0
}

# Second structure (inline if)
# This is a more concise way to write simple if-else conditions
y <- if (x > 3) 10 else 0

# Note: Always make sure the else occurs on the same line as the closing brace from if

# Example of an if condition with a comparison to FALSE
# It's more idiomatic to use 'if (!x)' instead of 'if (x == FALSE)'
x <- FALSE

if (!x) {
    message("This won't execute")
} else {
    message("This will execute if x is FALSE")
}

# Handling NA values in a vector with an if statement
x <- c(1, NA, 3)

# The if condition needs to be vectorized since 'x' is a vector
if (any(is.na(x))) {
    message("There are NAs in the vector.")
} else {
    message("There are no NAs in the vector.")
}

# Check for NA values
is.na(x)  # This will return a logical vector indicating which elements are NA



# loops in R --------------------------------------------------------------

# Repeat Loops

# Infinite loop - be careful with these! Uncomment to run.
 repeat {
     Sys.sleep(1)
     message("Just keep swimming...")
 }

# Repeat loop with a conditional break statement
repeat {
    Sys.sleep(1)

    # Simulate rolling a 6-sided die
    action <- sample(1:6, 1)

    # Print the result of the roll
    message("Die roll: ", action)

    # Break the loop if a 3 is rolled
    if (action == 3) break
}

# While Loops

# Initialize action variable
action <- sample(1:6, 1)

# Loop executes while the condition is TRUE
while (action != 3) {
    Sys.sleep(1)
    action <- sample(1:6, 1)
    message("Die roll: ", action)
}

# For Loops

# Simple for loop iterating over a sequence
for (i in 1:10) {
    message("Value of i: ", i)
}

# For loop with an additional operation (calculating square of i)
for (i in 1:15) {
    j <- i^2
    message("i: ", i, " j (i^2): ", j)
}

# For loops can iterate over different types of sequences
# Character vector
for (month in month.name) {
    message("Month: ", month)
}

# Logical vector
for (yn in c(TRUE, FALSE, NA)) {
    message("Boolean value: ", yn)
}

# List
complex_list <- list(
    pi,
    LETTERS[1:5],
    charToRaw("R is fun"),
    list(TRUE)
)

for (element in complex_list) {
    print(element)
}

# The following code uses a for loop to create a new variable in a dataframe
# and demonstrates the same operation using dplyr for comparison
library(ggplot2)
library(dplyr)

data <- mpg
data$hwy_sq <- NA

# Using a for loop
for (i in 1:nrow(data)) {
    data$hwy_sq[i] <- data$hwy[i]^2
}

# Using dplyr
data <- data %>%
    mutate(hwy_sq = hwy^2)



# Advanced Looping: The Apply Functions -----------------------------------

# The `apply` family of functions in R is used for performing actions across the margins of arrays, lists, data frames, and matrices.
# The main members are `apply`, `lapply`, `sapply`, `vapply`, `mapply`, and `tapply`.

# `apply` is used to apply a function to the rows or columns of a matrix or data frame.

# Example: Calculate the sum of each row in a matrix
matrix_data <- matrix(1:9, nrow = 3) # Create a 3x3 matrix
apply(matrix_data, 2, sum) # Apply 'sum' across rows (MARGIN = 1)

# `lapply` returns a list of the same length as the input, each element of which is the result of applying a function to the corresponding element of the input.

# Example: Calculate the length of each character vector in a list
list_data <- list(c("a", "b", "c"), c("d", "e"), c("f", "g", "h"))
lapply(list_data, length) # Apply 'length' to each element of the list

# `sapply` is a user-friendly version of `lapply` by default returning a vector or matrix if appropriate.

# Example: Same as above but returns a vector instead of a list
sapply(list_data, length) # Apply 'length' to each element of the list

# `vapply` is similar to `sapply`, but you can specify the output type, which makes it safer.

# Example: Same as `sapply` but with specified return type
vapply(list_data, length, numeric(1)) # Apply 'length' with specified return type

# `mapply` is a multivariate version of `sapply`. It applies a function to the 1st elements of each ... argument, the 2nd elements, the 3rd elements, and so on. Arguments are recycled if necessary.

# Example: Add corresponding elements of two vectors
vector1 <- 1:5
vector2 <- 6:10
mapply(sum, vector1, vector2) # Element-wise sum of two vectors

# `tapply` applies a function over subsets of a vector.

# Example: Calculate the mean of a numeric vector based on a grouping variable
numeric_vector <- 1:10
grouping_factor <- factor(c("a", "a", "b", "b", "c", "c", "a", "b", "c", "c"))
tapply(numeric_vector, grouping_factor, mean) # Mean of numbers by group



# Writing Custom Functions in R -------------------------------------------

### How to Create Custom R Functions

# In R, you can create your own functions. The basic syntax is as follows:

# my_function <- function(arg1, arg2, ...) {
#   # Function body
#   result <- ... # some operations on arguments
#   return(result)
# }

# 1. Understanding Functions:
#
#    - Functions are reusable blocks of code that perform specific tasks.
#    - They take inputs (arguments) and return outputs.
#    - Functions are crucial for organizing and simplifying code.

# 2. Anatomy of a Function:
#
#    A function typically consists of:
#       - Function name
#       - Parameters (input variables)
#       - Function body (code that performs the task)
#       - Return statement (output)

# 3. Simple Functions:

# Let's start with a basic example:

square <- function(x) {
    result <- x^2
    return(result)
}

#   Explanation:
#       - square is the function name.
#       - x is the parameter.
#       - result stores the squared value.
#       - return(result) returns the result.

# to use a function, call it and add arguments
result <- square(5) # 5 is the argument we are passing to our function

result  # Output: 25

# 4. Default Arguments
#
#   - You can set default values for parameters

greet <- function(name = "Guest") {
    message <- paste0("Hello, ", name, "!")
    return(message)
}

# in this example, you can call the 'greet' function without passing a 'name' parameter
greet()

# or you can change the argument to get a different result
greet("Nick")

# 5. Functions can have multiple parameters

#   - you can set up more than one argument when creating a function
#   - functions with more than one argument can use multiple inputs to generate outputs

# A simple exercise to practice:

# Create a simple function that takes 2 values and adds them together


# test your function
add2(13, 49) # should result in 62


# 7. Advanced Functions

#   - functions can be used to solve complex tasks.
#
# for example, lets build a funciton to calculate the factorial of an input number
factorial <- function(n) {
    if (n <= 1) {
        return(1)
    } else {
        return(n * factorial(n - 1))
    }
}


# 8. Function Documentation
#
#   - Use comments and documentation to explain the purpose and usage of your functions
#

# Calculates the factorial of a non-negative integer n.
# Returns the factorial value.
factorial <- function(n) {
    if (n <= 1) {
        return(1)
    } else {
        return(n * factorial(n - 1))
    }
}

factorial(5)


# 9. Creating functions that handle errors:
#
#    - sometimes the arguments passed into functions result in errors
#    - in order for the function to run, we need to anticipate erorrs and provide instructions
#      that tell R what to do in case an error occurs

# A function that stops if it encounters an error
safe_division <- function(x, y) {
    if (y == 0) {
        stop("Error: Division by zero is not allowed.")
    }
    return(x / y)
}

# Call the function with a non-zero denominator
safe_div <- safe_division(10, 2)

# Attempt to call the function with a zero denominator
# Uncomment to run and see the error
#unsafe_div <- safe_division(10, 0)

