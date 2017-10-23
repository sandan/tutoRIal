# Subsetting Matrices and Arrays

# You can susbet higher dimensional structures in three ways:
# with multiple vectors
# with a single vector
# with a matrix

a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a
is.matrix(a[ c(1, 3), ])   # subsetting a matrix gives back a matrix

# supply a 1-d index for each dimension, blank subsetting just means return all
a[1:2, ]  # rows 1 thru 2 and all columns
a[, 1:2] # all rows and cols 1 thru 2

a[c(1, 3), ]  # Rows 1 and 3 and all columns
a[ , c(1, 3)] # all rows and columns 1 and 3

# the 1-d vector can be characters or logical vectors or doubles

# chars
a[ , c("A", "C")]  # All rows and columns A and C
a[c("A", "B"), ]   # Error since no rows have a name

# logical
a[c(F), ]  # recycle - no rows with all columns
a[c(F, T), ] # recycle - even rows with all columns


# this boolean statement is applied to each element of the matrix
a > 3
is.matrix(a > 3)
a[a > 3] # note that the matrix is in column major order
         # this subset gives back a vector not a matrix

is.matrix(a[a > 3])
is.atomic(a[a > 3])
is.vector(a[a > 3])

# doubles
a[c(1.5, 2.5), ]  # rows 1 and 2 with all columns

# negative integers will omit
a[0, -2] # no rows omit column 2 ("B")

# You can subset matrices and arrays with a single vector
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
help(outer)  # outer (cartesian?) product of array x and y with elements given by paste(X_i, Y_i, sep= ",")
vals
vals[c(4, 11, 15)]  # get elements 4, 11 and 15 (in column major order)
                    # this returns a vector of those elements

# Subsetting for higher dimensional data structs
# you can also subset with an integer matrix or character matrix if named,
# each row in the matrix specifies the location of one value
# each column corresponds to a dimension in the array being subsetted

vals <- outer(1:5, 1:5, FUN='paste', sep=', ')
help(matrix)
select <- matrix(ncol = 2, byrow = TRUE, c(  # note how this matrix was made
  1, 2,                                      # the data can come after named args
  3, 1,
  2, 4
))
select
vals[select]

# you would use a 3 column matrix to subset a 3d array
# the rows of the 3 col matrix gives an element in the 3d array

# extracting diagonals from a square matrix
my_diag <- function(sqmat){
  n <- nrow(sqmat)
  x <- 1:n
  indices <- sapply(x, FUN = function(t){ c(t, t) })
  return (matrix(ncol = 2, byrow = TRUE, indices))
}
diag(vals)
vals[my_diag(vals)]
