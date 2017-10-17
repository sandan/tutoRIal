# Lists are heterogenous

x <- list(1, 1L, TRUE, 'TRUE')
str(x)
is.list(x)  # TRUE

# but can be homogenous
x <- list(1, 2, 3, 4)
str(x)
is.list(x)  # TRUE

# ranges are not lists, they are atomic vectors
x <- 1:10
str(x)
is.list(x)    # FALSE
is.atomic(x)  # TRUE

# lists are recursive
x <- list(
  list(
    1,2
  ),
  3,
  4,
  c(5, 6, 7)
)
str(x)
is.list(x)   # TRUE
is.recursive(x)  # TRUE

# combine() will combine several lists into one list
x <- c(list(1), list(2))
is.atomic(x) # FALSE
is.list(x)   # TRUE
str(x)        # list of 2: num 1, num 2

# lists are heterogenous, this is essentially an append
x <- c(list(TRUE), list(1))
is.atomic(x)
is.list(x)
str(x)     # list of 2: logi TRUE, num 1

# c() will combine lists and vectors by coercing the vec to a list then combining them
# remember that atomic vectors are coerced to the most flexible type
# so the following list has elements of a single type (double)
x <- c(list(1), c(TRUE, 3))
print(length(x)) # 3
is.atomic(x) # FALSE
is.list(x)   # TRUE
str(x)      # list of 3: num 1, num 1, num 3

# remember 'scalars' are vecs of length 1 ...
x <- c(list(1), 2)
is.atomic(x) # FALSE
is.list(x)   # TRUE
str(x)       # list of 2: num 1, num 2

# vectors are explicitly made into a list by calling as.list()
x <- as.list(c('TRUE', 2L, 3))  # list of characters
length(x)  # 3
is.list(x) # TRUE
str(x)

# ... is not the same as ...
x <- list(c('TRUE', 2L, 3))
length(x)
is.list(x)
str(x)

# ... but it is the same as ... by coercion rules
x <- c(c('TRUE', 2L, 3), list())
length(x)   # 3
is.list(x)  # TRUE
str(x)

# In summary, combine will:
#  c(list(x), list(y))                          -> list(x,y)
#  c(list(x), 'scalar')                         -> list(x, 'scalar')
#  c(list(x), c(y)) -> list(x, as.list( c(y) )) -> list(x, y (coerced))
#  c(c(x), c(y))                                -> c(x, y) flattened
#  c(..., 'scalars', ...)              -> atomic vector of most flexible type

# a list can be turned into an atomic vector by calling unlist()
