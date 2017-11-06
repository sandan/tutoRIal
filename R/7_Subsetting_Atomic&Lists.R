# 3 subsetting operators ([, [[, $)
# 6 types of subsetting
# differences between vectors, lists, factors, matrices, and data frames
# subsetting with assignment


# Data Types

# Atomic vectors and the [ operator
 x <- c(2.1, 4.2, 3.3, 5.4)

 # using indices with c()
 x[c(3, 1)]   # get elements at positions 3 and 1 (in that order)
 x[c(1, 3)]

 x[order(x)]  # get the elements of the vec in order
 help(order)  # allows you to specify an order (permutation)

 # duplicated indices yield duplicated values
 x[c(1, 1, 2)]

 # indexing with doubles silently truncate to ints
 x[(c(1.2, 1.5, 2, 2.5))]

 # negative integers omit the elements at the specified positions
 omit <- -c(3, 1)  # the - in front of the atomic vec distributes
 x[omit]  # get the elems in pos 2, 4 , and 5

 # can't mix positive indices and negative
 x[c(-1, 1)]

 # logical vectors can be used to select elements where the logical value is TRUE
 x[c(T, F, F, T)]

 l <- x > 3 # boolean statements with a vec give back a logical vec applying to each elem
 is.logical(l)
 is.atomic(l)
 x[l]  # the same as x[x > 3]

 # if the logical vec is shorter than the vector being subsetted, it gets "recycled" to the same length
 # this means the logical vec gets appended with itself until it is long enough (truncates if not divisible)
x[c(T)]   # -> x[c(T, T, T, T)]

z <- x[c(F)] # -> x[c(F, F, F, F)]
class(z)
typeof(z)
is.atomic(z)
is.vector(z)
length(z)
str(z)

# Alternate elements
x[c(F, T)]   # -> x[c(F, T, F, T)]
x[c(T, F)]   # -> x[c(T, F, T, F)]
x[c(T, F, T)]# -> x[c(T, F, T, T)]

# missing values in the index yield missing values in the output
x[c(NA, T)]

# no index given to [ just returns the original vec
x[]

# if the vector is named you can use character vecs
y <- c(a = 2.1, b = 4.2, c = 3.3, d = 5.4)
# or equivalently, the more idiomatic R way
y <- setNames(x, letters[1:4])
y
y[c("a", "c")]
y[c("c", "a")]  # order matters
# you can repeat char names to repeat indices
# names are matched exactly

# Lists are subsetted the same way with [
