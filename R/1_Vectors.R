
# http://adv-r.had.co.nz/Data-structures.html

# Five basic data types in R
#                      Homogenous                       Heterogenous
#          (elements must all be the same type)
#  (Vector)   1d       Atomic vector                     List
#             2d        Matrix                         Data Frame
#             nd        Array

# more complicated objects are built from these
# R has no scalar types (0 dimensional vectors)

# Finding info about an object:
#  str() - gives a compact, human readable description of any R data structure

# Vectors
#  - can be atomic vectors or lists
x1 <- c()
x2 <- list()

#  Vectors have 3 common properties:
#  note how in R, the 'properties' are retrieved from function calls

len_x1 <- length(x1)      # gives the length of the (atomic) vector
typ_x1 <- typeof(x1)      # gives the type of elements in vector
attr_x1 <- attributes(x1) # gives additional arbitrary metadata

len_x2 <- length(x2)      # gives the length of the list
typ_x2 <- typeof(x2)      # gives the type of list
attr_x2 <- attributes(x2) # gives additional arbitrary metadata

print(c('atomic vector:', len_x1, typ_x1, attr_x1))
print(c('list:', len_x2, typ_x2, attr_x2))

# use is.atomic() || is.list() to test if an object is actually a vector
print(c(is.atomic(x1), is.list(x2)))
print(c(is.atomic(x2), is.list(x1)))

# is.vector() returns TRUE only if the object is a vector with no attributes apart from names
k1 <- list(abc="123")
print( c(is.vector(k1), names(k1)) )
print(is.vector(x2))
