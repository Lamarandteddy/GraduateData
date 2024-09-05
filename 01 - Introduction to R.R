# MSBA 615 - Week 1
# Instructor: Nick Holt, Ph.D.

# Introduction to R

# Welcome to Week 1 of MSBA 615! In this session, we will explore the fundamentals of R programming 
# and become familiar with the R Studio environment. Through hands-on exercises and examples, 
# we will cover various aspects of R, including arithmetic operations, object assignment, 
# vectorization, special numbers, logical vectors, object attributes, coercion, matrices, 
# and data frames. Let's dive right in!

## Basic Operations ------------------------------------------------------------

# Addition and subtraction
1 + 5
15 - 9

# Multiplication and division
102834 * 989
73492 / 3868

# Modulo operator
73492 %% 3868

# Exponents
3 ^ 3
5i ^ 2

# Colon operator and concatenation
1:5
c(1, 2, 3, 4, 5)

# Case sensitivity
 C(1, 2, 3, 4, 5)  # This line will result in an error

# In this section, we perform basic arithmetic operations such as addition, subtraction,
# multiplication, and division. We also introduce the modulo operator, exponentiation, 
# and demonstrate the use of the colon operator for creating sequences. Additionally, 
# we explore concatenation, which allows us to combine multiple values into a 
# single vector. Please note that R is case-sensitive, so be careful with 
# capitalization when using functions and objects.


## Object Assignment ------------------------------------------------------------


# Assigning values to objects
object <- 8
print(object)  # Explicit printing
object  # Auto-printing

x <- c(1, 2, 3, 4, 5)
x + 2  # Operators passed to vectors modify each value individually

# In this section, we learn how to assign values to objects using the assignment 
# operator (\<-). We demonstrate both explicit printing using the print() function 
# and automatic printing by typing the object name. We also explore how operators 
# applied to vectors modify each value individually, resulting in element-wise operations.


## Vectorization ------------------------------------------------------------

1:5 * 10  # Vectorized operation using the sequence 1:5
sum(1:5)
median(1:5)

sum(1, 2, 3, 4, 5)  # This line will not result in an error
median(1, 2, 3, 4, 5)  # This line will result in an error

# the result of the median function implemented above is not the expected
# median of the values 1 to 5. Why?


# Fix the previous function (median) by passing a vector instead





# one possible solution:

x <- c(1, 2, 3, 4, 5) # create vector
median(x)

# In this section, we explore the concept of vectorization in R, 
# which allows us to perform operations on entire vectors efficiently. 
# We demonstrate vectorized multiplication using the sequence 1:5. We also show 
# examples of using the sum() and median() functions, emphasizing the importance 
# of passing vectors as arguments to these functions instead of individual values.


## Quick Check Activity #1: ------------------------------------------------------------

# Write some R code to find the answer to the following question: Is the sum of 
# all integers between 1 and 500 greater than 50 cubed?

# Fill in with your solution:

















# Possible solution code:

sum(1:500) > 50^3



## R objects and their types ------------------------------------------------------------

### The Five Atomic Classes of R Objects

# In R, atomic classes refer to the fundamental data types that objects can belong to. 
# R has five atomic classes of objects: character, numeric, integer, complex, and logical.

        # Character objects represent textual data and are enclosed in double or 
        # single quotes. They can store individual characters or strings of characters.

        # Numeric objects are used to represent numerical data. They can store real 
        # numbers, including integers and decimals.

        # Integer objects are a specific subset of numeric objects that store whole 
        # numbers without decimal places. They are denoted by adding the "L" suffix 
        # to the number.

        # Complex objects are used to represent complex numbers with real and 
        # imaginary parts. They are written in the form of a + bi, where a is 
        # the real part and b is the imaginary part.

        # Logical objects represent Boolean values, which can be either TRUE or FALSE. 
        # They are used to represent logical conditions or the outcome of logical 
        # operations.

# Understanding the atomic classes in R is important for data manipulation and 
# analysis, as it allows us to work with different types of data and perform 
# appropriate operations based on their class.


# Character
x <- c("a", "b", "c")
str(x)

# Numeric
x <- c(0.52, 0.61, 0.32)
str(x)

# Integer
x <- 3:43
str(x)

# Complex
x <- c(1+0i, 2+4i)
str(x)

# Logical
x <- c(TRUE, FALSE, TRUE)
str(x)

# In this section, we explore the five atomic classes of objects in R. 
# We create objects of each class (character, numeric, integer, complex, and logical) 
# and examine their structure using the str() function.


### Numbers
x <- 5
x
class(x)

x <- 5L  # The 'L' suffix specifically denotes an integer type
x
class(x)

x <- 5.1  # When a number requires decimal precision it is stored as numeric type
x
class(x)

# In this section, we work with numeric values in R. We assign the value 5 to the 
# variable x, which can be either a regular numeric value or an integer. 
# The 'L' suffix in 5L explicitly indicates an integer data type. 
# When we need to use decimal precision, R stores numbers as numeric type 
# instead of integer type. Integer and Numeric are the two atomic classes that 
# are use to store numbers.


### Special Numbers

# Inf: Infinity
1 / 0

# NaN: Not a Number
0 / 0

# Creating a vector of special numbers
vec <- c(0, Inf, -Inf, NaN, NA)

# Checking for finite values, NaN, and NAs
is.finite(vec)
is.nan(vec)
is.na(vec)

# In this section, we explore special numbers in R. We divide 1 by 0 to demonstrate 
# the concept of infinity (Inf). We also divide 0 by 0 to generate a "Not a Number" 
# (NaN) result. We create a vector (vec) containing various special numbers and 
# use the is.finite(), is.nan(), and is.na() functions to check for finite values, 
# NaN, and NAs within the vector.


### Logical Vectors

# Creating a logical vector indicating integers >= 5
x <- 1:10 >= 5
x
!x  # Return the opposite of the logical vector

# What will this expression create?
y <- 1:10 %% 2 == 0

# In this section, we explore logical vectors in R. We create a logical vector 
# x that indicates whether each integer from 1 to 10 is greater than or equal to 
# 5. We then use the logical negation operator (!) to return the opposite of x. 
# Finally, we create a new logical vector y by applying the modulo operator to 
# the sequence 1:10 and comparing the result to 0, which tests for even numbers.



### Object Attributes

# Working with object attributes
?mtcars
data <- mtcars

# Names
names(data)

# Dimensions
dim(data)

# Class
class(data)

# Length
length(data)

# Metadata (all attributes)
str(data)

# Repeat the process with a different dataset
?airquality
data <- airquality
str(data)

# In this section, we explore object attributes in R. We use the mtcars dataset 
# as an example and access various attributes of the data, such as names, dimensions, 
# class, length, and metadata (using the str() function). We then repeat the process 
# with the airquality dataset to illustrate how attributes can differ between datasets.


## Typecasting / Coercion ------------------------------------------------------------

x <- c(TRUE, FALSE, TRUE)

# Logical to integer/numeric
as.numeric(x)
as.integer(x)

# Logical to character
x <- as.character(x)
str(x)

# Character to numeric (not applicable in this case)
as.numeric(x)

# In this section, we cover the concept of typecasting / coercion in R, which 
# allows us to manually convert objects from one class to another. We demonstrate 
# coercion from logical to integer/numeric and from logical to character. We also 
# attempt to coerce character values to numeric, which may or may not be successful 
# depending on the content of the character object.


## Objects with two dimensions ------------------------------------------------------------

### Matrices

# Creating a matrix
x <- matrix(nrow = 3, ncol = 4)
x

# In this section, we introduce matrices in R. We create a matrix x with 3 rows 
# and 4 columns using the matrix() function. Matrices are two-dimensional objects 
# that can store data in a tabular format.


### Functions for combining vectors into matrices: rbind and cbind
x <- 1:4
y <- 5:8
z <- 9:12

# Stacking vectors on top of one another (binding into rows)
xyz <- rbind(x, y, z)

# Binding vectors side-by-side (binding into columns)
xyz <- cbind(x, y, z)

# In this section, we explore the rbind() and cbind() functions, which allow us 
# to combine vectors into matrices. We create three vectors (x, y, and z) and 
# stack them together using rbind() to form a matrix with rows containing the 
# vectors. We also use cbind() to bind the vectors side-by-side, creating a matrix 
# with columns composed of the vectors.


### Data Frames

# In R, a data frame is a two-dimensional tabular data structure that organizes 
# data into rows and columns, similar to a table in a spreadsheet. It is a 
# commonly used data structure for storing and manipulating structured data. 
# A data frame can be thought of as a collection of vectors, where each vector r
# epresents a column, and the columns are of potentially different data types 
# (such as character, numeric, or logical). This makes data frames suitable for 
# handling heterogeneous data sets with variables of different types. Data frames 
# provide a convenient way to work with structured data, allowing operations such 
# as subsetting, filtering, and applying functions to specific columns or rows. 
# They are widely used in data analysis, statistical modeling, and other 
# data-related tasks in R.

# to create a data frame from scratch or coerce a matrix or set of vectors to 
# a data frame, use the data.frame() function
data.frame(rbind(x, y, z))

# store data frame as an object
df <- data.frame(rbind(x, y, z))

        # notice the environment panel now displays your data frame
        
        # click on the name of the df in the environment panel to view the df
        # as a table in a new tab in the RStudio browser

# In this section, we introduce data frames in R. Data frames are two-dimensional 
# objects similar to matrices but with additional features, such as the ability to 
# store different data types in each column. We use the data.frame() function in 
# combination with rbind() to create a data frame by stacking vectors (x, y, and z) 
# as rows.

## Quick Check Activity #2: ------------------------------------------------------------

# Create an object that stores 2 columns.

# The first column is comprised of numbers 100, 200, 300, 400, 500.

# The second column stores the square of each value in the first column, 
# divided by half of the value in the first column.

# Write code for your solution below:














# Possible solution
x <- c(100, 200, 300, 400, 500)
y <- (x^2) / (x / 2)
df <- cbind(x, y)
df

# Another solution (a student's solution from a previous class)
x <- c(1:5) * 100
y <- (x^2) / (x / 2)
df <- cbind(x, y)
df

# Note: The output of `data.frame(df)` will differ from `df` because a data frame 
# treats columns as separate entities, unlike a matrix.
data.frame(df)


# This section presents a Quick Check exercise involving the creation of a two-column object. 
# The first column contains numbers 100, 200, 300, 400, 500, while the second column 
# stores the square of each value in the first column divided by half of the corresponding 
# value in the first column. We provide two possible solutions and demonstrate that 
# the output of data.frame(df) differs from df due to the different treatment of 
# columns in data frames compared to matrices.

# That's it for the Week 1 Introduction to R section! We covered a wide range of 
# fundamental concepts in R and R Studio. Practice these examples and concepts 
# to strengthen your understanding. Stay tuned for the next section: Data Visualization 
# using ggplot2. Also, in Week 2 we'll practice many of these concepts again and dive 
# deeper into data manipulation with R.
