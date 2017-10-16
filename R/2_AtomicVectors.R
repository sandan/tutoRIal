# There are four common types of atomic vectors:
# logical
# integer
# double (often called numeric)
# character

# There are two other types: complex and raw

# You can instantiate an atomic vector with c(), short for combine
x1_double <- c(1, 2, 3)
x2_double <- c(1, 2.5, 3.14)
print(typeof(x1_double))

x1_int <- c(1L, 2L, 3L)

x1_logical <- c(T, TRUE, F, FALSE)
x2_logical <- c(T == TRUE, F == FALSE, length(x1_1ogical) == 4)

x1_char <- c("hello", "atmomic vectors!")

# Atomic vectors are always flat, even if you try to nest other atomic vectors
print( c(x1_double, x2_double) )

# Missing values are specified with NA, which is a logical vector if length 1
print(length(NA))
print(typeof(NA))
str(NA)

# You can create NA's of a specific type:

#  NA_real_
print(typeof(NA_real_))
print(length(NA_real_))

#  NA_integer_
print(typeof(NA_integer_))
print(length(NA_integer_))

#  NA_character_
print(typeof(NA_character_))
print(length(NA_character_))

# Types and tests for atomic vectors
# We mentioned using typeof but you can use the is* functions to be more specific:
#  is.character
#  is.double
#  is.integer
#  is.logical
#  or more generally, is.atomic() (for atomic vectors)
# call help(lapply) or help(sapply) for docs on ?apply funcs, basically map
sapply(list(x1_double, x1_int, x1_logical, x1_char), is.atomic) # note that list() is used here not c() else, they get flattenned
sapply(list(x1_double, x1_int, x1_logical, x1_char), is.character)
sapply(list(x1_double, x1_int, x1_logical, x1_char), is.double)
sapply(list(x1_double, x1_int, x1_logical, x1_char), is.integer)
sapply(list(x1_double, x1_int, x1_logical, x1_char), is.logical)

# There is also is.numeric() which tests for "numberliness" of a vector.
# returns TRUE for doubles/ints
sapply(list(x1_double, x1_int, x1_logical, x1_char), is.numeric)

# Coercion rules for atomic vectors
# NA is coerced to the type of element in a vector
#  All elements of an atomic vector must be of the same type
# attempting to combine different types into an atomic vector will coerce data.
# The coercion is to the most flexible type:
# (least flexible) logical
#                   integer
#                   double
# (most flexible) character
sapply(
  list(
    c(T, F),   # logical + logical -> logical
    c(T, 1L),  # logical + integer -> integer
    c(T, 1),      # logical + double -> double
    c(T, 'str')), # logical + char -> char
  typeof)

sapply(
  list(
    c(1L, 2L),     # integer + integer -> integer
    c(1L, 2.4),    # integer + double -> double
    c(1L, 'chr')), # integer + char -> char
  typeof)

sapply(
  list(
    c(3.14, 1),      # double + double -> double
    c(3.14, 'tok')), # double + char -> char
  typeof)

# When a logical is coerced to an integer or double TRUE == 1 and FALSE == 0
# Most mathematical functions will coerce to a double or integer
x <- c(T, F, T)
sum(x)
mean(x)

# most logical ops coerce to a logical
c(1 & 0, 2 | 0, any(1 == T))
# help(any)
any(c(1 & 0, 2 | 0, any(1 == T)))

# explicit coercion of atomic vectors can be called with:
#  as.numeric()
#  as.integer()
#  as.double()
#  as.logical()
#  as.character()
as.character(c(1,2,3))
as.numeric(c("TRUE", "FALSE"))
as.integer("TRUE")
as.double(c(1L, 2L))
as.logical("TRUE")
as.logical("FALSE")
as.logical("MAYBE?")
as.logical("T")
as.logical(c(NA, "TRUE"))
