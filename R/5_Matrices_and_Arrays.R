# From the Attributes section:
# The only attributes kept for the atomic vector are the three most important:
# names() - a character vector giving each element a name
# dimensions (dim()) - used to turn vectors into matrices and arrays
# class() - used to implement the S3 object system

# We've gone over names()/factors()/levels() in 4_Attributes

# Adding a dim attribute to an atomic vector allows it to behave like a multi-dimensional array (array with matrix elements)
# starting to think of adding attributes to objects like mix-ins for classes or inheritance
# A special case of the array is the matrix which has 2 dimensions
# dim() will change the class

# 1) matrices are created with matrix()
a <- matrix(1:15, ncol = 3, nrow = 5)
class(a)
is.matrix(a)
a

# 2) arrays are created with array()
b <- array(1:12, c(2, 3, 2))  # array of 2x3 matrix elements, of length 2
class(b)
is.array(b)
b

# single dimensional array with 10 elements
is.atomic(array(1:3, 10))  # FALSE
is.vector(array(1:3, 10))  # FALSE
is.array(array(1:3, 10))   # TRUE
is.matrix(array(1:3, 10))  # FALSE

# array of 5 1x1 matrices
array(1:5, c(1, 1, 5))

# array of 1 1x5 matrix
array(1:5, c(1, 5, 1))

# array of 1 5x1 matrix
array(1:5, c(5, 1, 1))

# 3) modify an object in place by setting dim
c <- 1:6
is.atomic(c)  # TRUE
is.vector(c)  # TRUE
class(c)      # integer
dim(c)
length(dim(c))

dim(c) <- c(3, 2)  # 3 x 2 matrix
dim(c)
length(dim(c))

c
is.matrix(c)  # TRUE
is.array(c)   # TRUE
class(c)      # matrix
is.atomic(c)  # TRUE
is.vector(c)  # FALSE

# length() generalizes to nrow() and ncol() for matrices
nrow(a)
is.integer(nrow(a))

ncol(a)
length(a)

# length() generalizes to dim() for arrays
nrow(b)
ncol(b)
length(b)
dim(b)

# names() generalizes to rownames() and colnames() for matrices
rownames(a) <- c("X", "Y", "Z", "A", "B")
colnames(a) <- c("Austin", "Boston", "Cambridge")
names(a)   # NULL
rownames(a)
colnames(a)
a
# Austin Boston Cambridge
# X      1      6        11
# Y      2      7        12
# Z      3      8        13
# A      4      9        14
# B      5     10        15

# dimnames() for arrays
dimnames(b) <- list(
  c("row1", "row2"),
  c("col1", "col2", "col3"),
  c("[1]", "[2]"))
b

# c() generalizes to cbind() and rbind() for matrices (doesn't modify the underlying object)
c
x <- cbind(c, c)   # bind the matrix to itself column wise (concat column wise)
x
is.matrix(x)
is.integer(x)    # was made from 1:6
dim(x)

x <- cbind(c, c(8,9,10))   # add a single column to the matrix
is.matrix(x)
dim(x)
is.double(x)
x

# The same coercion rules apply to cbind and rbind as c()
x <- cbind(c, c('8', '9', '10'))
is.matrix(x)
is.character(x)

x <- cbind(c, c(T, F, T))
is.matrix(x)
is.logical(x)

# If the dimensions dont match up then a warning is thrown
# the result truncates the values to bind instead of expanding the object
c

#      [,1] [,2]
#[1,]    1    4
#[2,]    2    5
#[3,]    3    6

cbind(c, c(1,2,3,4))

#      [,1] [,2] [,3]
#[1,]    1    4    1
#[2,]    2    5    2
#[3,]    3    6    3
#Warning message:
#  In cbind(c, c(1, 2, 3, 4)) :
#  number of rows of result is not a multiple of vector length (arg 2)

# rbind follows WLOG

# Vectors are 1 dimensional
# you can also have 1 dimensional matrices (single row or single column)
# or arrays with a single dimension

# use str to reveal the differences or is.matrix() and is.vector()
# Note that is.atomic() can be TRUE for both atomic vectors and matrices
str(1:19)
str(matrix(1:19, ncol = 19))
str(matrix(1:19, nrow = 19))
str(array(1:3, 10))

# You can also test the length of the dim()
c <- 1:10
dim(c)
# vs.
dim(matrix(1:10, ncol = 10))
# vs.
dim(array(1:3, 10))
length(dim(array(1:24, c(2, 3, 2, 2))))

# You can use dim() on lists() to create a multi-dimensional list of objects
x <- list(1:3, T, "abc", 3.14)
dim(x) <- c(2, 2)
x
is.atomic(x)  # FALSE
is.matrix(x)  # TRUE
is.array(x)   # TRUE
is.list(x)    # TRUE
is.vector(x)  # FALSE

