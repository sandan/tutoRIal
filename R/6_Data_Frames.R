# Data Frames
# like lists and matrices

# Under the hood it is a list of equal sized vectors
# each column is an equal sized vector, the df is a list of such columns
help(data.frame)

# Creation
# args provided are a variable number of named elements
# each named variable is a column
df <- data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = FALSE)
df
is.list(df)        # TRUE
is.matrix(df)      # FALSE
is.data.frame(df)  # TRUE
is.atomic(df)      # FALSE
is.array(df)       # FALSE

str(df)  # Has y as a factor column

df <- data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = FALSE)
df
str(df)  # Has y as an atomic column

# API
names(df)    # get col names of df
colnames(df) # same as names
rownames(df) # name of rows, 1:n by default, n = nrow(df)
length(df)   # number of columns in df
ncol(df)     # same as length(df)
nrow(df)     # number of rows


# Coercion
# because data.frame is an S3 class, its type reflects the underlying vector used to build it
typeof(df)
mode(df)
class(df)


# use as.data.frame to coerce an object to a data frame

# vector -> df : df is a single column of len(vec) rows
vec <- c(1, 2, 3, 4)
df <- as.data.frame(vec)
colnames(df)  # default column name is the name of the variable of the vector
str(df)

# list -> df : df has length(lis) columns with 1 row (the elements in the list)
lis <- list(T, 2L, 3.2, '4')
df <- as.data.frame(lis,
                    col.names = c('c1',   # you can provide names to the df
                                  'c2',   # otherwise it just uses the names
                                  'c3',   # of the variables but modified
                                  'c4'))
str(df)
df

# arr -> df : df has ncols(df) = ncols(arr) and nrows(df) = nrows(arr)
arr <- array(1:10, c(2,5,1))
df <- as.data.frame(arr)
colnames(df)
str(df)

# mat -> df : df has ncols = ncol and nrows = nrow
mat <- matrix(1:100, nrow = 20, ncol = 4)
df <- as.data.frame(mat)
colnames(df)
str(df)

# Combining data frames
# use cbind(to, from) to combine columns and rbind(to, from) to combine rows (combine -> concat/append)
df1 <- data.frame(c1 = 1:3, c2 = c(4:6))
df2 <- data.frame(c1 = 8:10, c2 = 12:14)

# append columns of df2 to df1 (appends to right)
# the number of rows must match
cbind(df1, df2)

# append rows to df1 from df2
# number of cols must match
# names of cols must also match to know which col to append data to
rbind(df1, df2)

rbind(df1, data.frame(x = 8:10, y = 12:14))  # err, col names dont match
rbind(df2, data.frame(x = 9:100000))         # err, number of cols don't match

# you can use plyr::rbind.fill() to combine data frames that dont have the same columns

# cbind() ing vectors will not give a data frame, it creates a matrix
x <- cbind(c(1, 2, 3, 4), c(4, 5, 6, 7))
is.matrix(x)
is.data.frame(x)
is.atomic(x)
is.vector(x)
x

# same applies to rbind()
# coercion rules still apply for matrices too
x <- rbind(c(1, 2, 3), c('1', '2', '3'))
is.matrix(x)
is.data.frame(x)
is.atomic(x)
is.vector(x)
x

# if one of the arguments to cbind() is a data frame, then the result is a data frame
x <- cbind(data.frame(x = c(1, 2, 3)), c(3, 4, 5))
is.data.frame(x)
is.matrix(x)
is.atomic(x)
is.vector(x)
x

# same for rbind()
# coercion rules still apply here
# seems to have stringsAsfactors = FALSE here
x <- rbind(data.frame(x = c(1, 2, 3)), c('1'), c('2'))
is.data.frame(x)
is.matrix(x)
is.atomic(x)
is.vector(x)
str(x)
x

# The conversion rules for cbind() are complicated and best avoided by ensuring all inputs are of the same type.

# init df with a matrix (coerced by chr) returned by cbind
x <- data.frame(cbind(1:2, c('a', 'b')))
str(x)

x <- data.frame(cbind(1:2, c('a', 'b')), stringsAsFactors = FALSE)
str(x)

# just do
x <- data.frame(a = 1:2, x = c('a', 'b'), stringsAsFactors = FALSE)
str(x)


# Special Columns
# Since a data frame is a list of vectors, it is possible for a data frame to have a column that is a list
df <- data.frame(x = 1:3)
df$y <- list(1:2, 1:3, 1:4)
df
str(df)

# When a list is given in the constructor of the
# data frame it tries to put each item of the list
# into its own column
data.frame(x = 1:3, y = list(1:2, 1:3, 1:4))

# you can use I() to tell it to treat the list as 1 unit
df <- data.frame(x = 1:3,
           y = I(list(
             1:2,
             1:3,
             1:4))
)

# index into column y of df
df[3, "y"]
df[2, "y"]
df[1, "y"]

# these are all the same reference to column x
df["x"]
df[1]
df$x

# you can also use I() with matrices and arrays
# but the number of rows must match
x <- data.frame(1:10, I(matrix(1:10, nrow = 10)))
str(x)

# in the case of matrices, extra cols in the matrix get appended to the df
x <- data.frame(1:5 , mat = I(matrix(15:24, ncol = 2, nrow = 5)))
x

# not so with arrays, the df has just a single element
x <- data.frame(I(array(1:10, c(5, 2))))
str(x)
x[1]
x

ncol(array(1:10, c(5, 2)))
