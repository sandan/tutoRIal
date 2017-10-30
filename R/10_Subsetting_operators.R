# [[  and $

# [[ is similar to [ except it can only return a single value and it allows you to pull elements from a list (non-preserving)
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
# Someone will have a single column df

#             Simplifying       Preserving
# Vector        x[[1]]            x[1]
# List          x[[1]]            x[1]
# Factor        x[1:4, drop = T]  x[1:4]
# Matrix/Array         x[1, ] or x[, 1]  x[1, , drop = F] or x[, 1, drop = F]
# Data frame    x[, 1] or x[[1]]  x[, 1, drop = F] or x[1]

x <- factor(x = c("m", "f", "m"), levels = c("m", "f"))
x[1:2]
x[c(1, 3), drop = TRUE]

df <- data.frame(x = c(1, 2, 3))
df[[1]]  # integer vec
df[ , 1] # integer vec

df[, 1, drop = F]  # df
df[1]  # df

# Preserving is the same for all data types: you get the same type of output as input
# Simplifying differs for certain data types

# atomic vector simplification -> returns non-named atomic vec
x <- c(a = 1, b = 2)
x[1]   # returns a named vec with a = 1
x[[1]] # returns a non-named vec with 1

# list simplification  -> returns non-named atomic vec
y <- list(a = 1, b = 1)
str(y[1])  # named list with a = 1
y[[1]]     # non-named atomic vec with 1

# factor simplification  -> returns factor
z <- factor(c('a', 'b'))
z[1]   # factor with 'a' and levels 'a' and 'b'
z[[1]] # same as above

z[1, drop = TRUE] # factor with first element 'a' and only level 'a'
                  # drop = T will drop any levels that are not in the subset of the factor

# Matrix or Array ->
a <- matrix (1:4, nrow = 2)
a[1, , drop = F]
