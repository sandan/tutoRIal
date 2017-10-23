# [[  and $

# [[ is similar to [ except it can only return a single value and it allows you to pull elements from a list
# $ is a useful shorthand for [[ with character subsetting

x <- list(1, 2, 3)
str(x[1])   # list of 1 element
str(x[[1]]) # the actual element in pos 1
str(unlist(x[1])) # unlisting gives the element in pos 1 with [

# [ applied to lists always returns a list, to get contents use [[
# [[ works with character subsetting and named lists
x <- list(a = 1, b = 2)
x[[c("a")]] # is the same as
x[["a"]]

# since we are getting back a single element, this won't work
x[[c("a", "b")]]  # out of bounds error

# unless we can recurse into the element being chosen
b <- list(a = list(b = list(c = list(d = 1))))
b[[c("a", "b", "c", "d")]]  # recursively walk down list
                            # kind of like doing b[["a"]][["b"]][["c"]][["d"]]
b[["a"]][["b"]][["c"]][["d"]]

# because data frames are lists of columns (vecs), you can use [[ to extract a column from data frames
mtcars[1]  # data frame with 1 column (of 1 variable)
mtcars[[1]]# vec of doubles

# you can also get the column back by name
mtcars[["cyl"]]  # vec of doubles

# S3 and S4 objects can override the standard behaviour of [ and [[ so
# they behave differently for different types of objects.
# The key difference is usually how you select between
# simplifying or preserving behaviours, and what the default is.

# Simplifying vs. Preserving
# When you subset a data structure the returned data structure is
# either the same as the data structure (preserving)
# or another simple data structure that reps the output (simplifying)

# Omitting drop = FALSE when subsetting matrices and data frames is a common error
# It will work for your test cases but then someone

#             Simplifying       Preserving
# Vector        x[[1]]            x[1]
# List          x[[1]]            x[1]
# Factor        x[1:4, drop = T]  x[1:4]
# Array         x[1, ] or x[, 1]  x[1, , drop = F] or x[, 1, drop = F]
# Data frame    x[, 1] or x[[1]]  x[, 1, drop = F] or x[1]

x <- factor(x = c("m", "f", "m"), levels = c("m", "f"))
x[1:3]
x[1:3, drop = FALSE]

# Preserving is the same for all data types: you get the same type of output as input
