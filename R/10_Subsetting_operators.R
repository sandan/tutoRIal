# [[  and $

# [[ is similar to [ except it can only return a single value and it allows you to pull elements from a list (non-preserving)
# $ is a useful shorthand for [[ with character subsetting

x <- list(1, 2, "3")
str(x[1])   # list of 1 element
str(x[[1]]) # the actual element in pos 1
str(unlist(x[1])) # unlisting gives the element in pos 1 with [

# unlisting gives atomic vector
is.atomic(unlist(x))
# casting rules apply
is.character(unlist(x))

# [ applied to lists always returns a list, to get contents use [[
# [[ works with character subsetting and named lists
x <- list(a = 1, b = 2)
x[[c("a")]] # is the same as
x[["a"]]
is.list(x['a'])
length(x['a']) == 1

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
mtcars[[c('cyl')]]
colnames(mtcars)

# S3 and S4 objects can override the standard behaviour of [ and [[ so
# they behave differently for different types of objects.
# The key difference is usually how you select between
# simplifying or preserving behaviours, and what the default is.

# Simplifying vs. Preserving
# When you subset a data structure the returned data structure is
# either the same as the data structure (preserving)
# or another simple data structure that reps the output (simplifying)
# in other words, a simplifying subset op can take you out of the data struct

# Omitting drop = FALSE when subsetting matrices and data frames is a common error
# Someone will have a single column df

#             Simplifying         Preserving (non-dropping)
# Vector        x[[1]]              x[1]
# List          x[[1]]              x[1]
# Factor        x[1:4, drop = T]    x[1:4]
# Matrix/Array  x[1, ] or x[, 1]    x[1, , drop = F] or x[, 1, drop = F]
# Data frame    x[, 1] or x[[1]]    x[, 1, drop = F] or x[1]

x <- factor(x = c("m", "f", "m"), levels = c("m", "f"))
x[1:2]
x[c(1, 3), drop = TRUE]
x[c(1, 3), drop = FALSE]
is.factor(x[c(1, 3), drop = TRUE])

df <- data.frame(x = c(1, 2, 3))

# Simplifying
df[[1]]  # integer vec
df[ , 1] # integer vec

#Preserving
df[, 1, drop = F]  # df
df[1]  # df

# Preserving is the same for all data types: you get the same type of output as input
# Simplifying differs for certain data types

# VECTOR
# atomic vector simplification -> returns non-named atomic vec
x <- c(a = 1, b = 2)
x[1]   # returns a named vec with a = 1
x[[1]] # returns a non-named vec with 1

# LIST
# list simplification  -> returns non-named atomic vec
y <- list(a = 1, b = 1)
str(y[1])  # named list with a = 1
y[[1]]     # non-named atomic vec with 1

# FACTOR
# factor simplification  -> returns factor
z <- factor(c('a', 'b'))
z[1]   # factor with 'a' and levels 'a' and 'b'
z[[1]] # same as above

z[1, drop = TRUE] # factor with first element 'a' and only level 'a'
                  # drop = T will drop any levels that are not in the subset of the factor

# Matrix or Array simplification -> non-named matrix or non-named atomic vec
# If any of the dim()'s is 1, drop that dimension
a <- matrix (1:4, nrow = 2)
a
dim(a)

# MATRICES
# A matrix is a matrix and is an array
is.matrix(a)
is.array(a)

# get the first row (result is 1 x 2 matrix/array)
is.matrix(a[1, , drop = F])  # not dropping preserves the data struct
is.atomic(a[1, , drop = T])  # dropping will simplify to an atomic vec
a[1, ]  # drop = T by default

# similarly for col
is.matrix(a[ , 1, drop = F])
is.atomic(a[ , 1, drop = T])
a[ , 1]  # dropping will simplify to an atomic vec

# ARRAYS
# generally for higher dimensions too but it may simplify to a matrix
b <- array(1:12, dim=c(2, 3, 2)) # array of 2 2x3 matrices
dim(b)

# an array is not a matrix but it is an array
is.matrix(b)
is.array(b)

# Simplifying an array gives a matrix
b
b[ , 1, ]
dim(b[ , 1, ]) # 2 2
is.matrix(b[ , 1, ])  # T
is.array(b[ , 1, ])

# Preserving an array gives an array
b[ , 1, , drop = F] # get the first col and all rows for each matrix, keeps the result as an array

is.atomic(b[1:3])   # drop = T by default
b[1:3]              # gives the result back as an atomic vec
b[1:3, drop = F]    # dropping = F doesn't happen here since the subset is a single dimension already
is.atomic(b[1:3, drop = F])

is.atomic(b[[1]])


# DATA FRAME
# data frames simplify to a vector if the output is a single column

df <- data.frame(a = 1:12, b = 1:12)
str(df[1])   # preserve
str(df[ , "a", drop = F])  # preserve

str(df[[1]])    # simplify
str(df[ , "a"]) # simplify, drop = T by default

# The $ operator
# $ is a shorthand opertor, here x$y is equivalent to x[["y, exact = F]]
# it is often used to access variables in a data frame
mtcars$mpg  # simplifying

# common mistake
var <- "cyl"
mtcars$var
# same as the one below
mtcars[["var"]]

# instead use
mtcars[[var]]  # simplifying

# $ vs. [[
# $ does partial matching on the variable name
x <- list(abc = 1)
x$a
x[["a"]] # [[ doesnt


# If you want to avoid this behaviour you can set the global option warnPartialMatchDollar to TRUE.
# Use with caution: it may affect behaviour in other code you have loaded (e.g., from a package)
