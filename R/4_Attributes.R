# All objects in R can have arbitrary additional attributes used to tore metadata about the object
# Attributes can be thought of as a named list (with unique names)

# Set/Get a specific attribute with attr()
y <- 1:10

attr(y, "my_attribute") <- "This is an atomic vector of doubles"
attr(y, "my_attribute")

# Get a list of all the attributes with attributes()
str(attributes(y))

# structure() returns a new object with modified attributes
structure(1:10, my_attribute = "Another atomic double vector")
# help(structure) - returns a given object with further attributes set

# By default most attributes are lost when modifying a vector
attributes(y[1]) # attributes of the first element in vector y
attributes(sum(y))

# The only attributes kept for the atomic vector are the three most important:
# names() - a character vector giving each element a name
# dimensions (dim()) - used to turn vectors into matrices and arrays
# class() - used to implement the S3 object system

y <- c(T, F, T, F)
# help(names) - set the names of a vector given a character vector of the same length
names(y) <- c("first", "second", "third", "fourth")
names(y)
is.character(names(y)) # names returns a character vector
is.atomic(names(y))

# you can name each element
names(y)[[1]] <- "1st"  # not sure what the indexing means with [[]]
names(y)[2] <- "2nd"    # vs. just []
names(y)

# Naming a vector can be done in 3 ways:
# 1) when creating it (names must be character vectors <name> = <value>)
y <- c('1' = 'a', '2' = 'b', '3' = 'c')
names(y)

# 2) Modify an existing vector in place
y <- 1:3
names(y) <- c("x", "y", "z")
names(y)
# Or using an explicit index
y <- 1:3
names(y)[[1]] <- c("a")
names(y)
is.atomic(names(y))

# 3) Creating a modified copy of a vector
y <- setNames(1:4, c("s", "t", "u", "v"))
names(y)
# help(setNames) returns an object of the sort but with new names assigned

# Names don't have to be unique but it is usful when they are
# missing names for elements will be NA (NA_character_)
y <- 1:2
names(y) <- c('a')
names(y)
is.atomic(names(y)) && is.character(names(y)[2])

# if all names are missing names() just returns NULL
names(1:3)

# You can remove names with unname() or remove names in place with names(x) <- NULL
names(y)
unname(y) # returns a vector y without the names
names(y) # unname doesn't modfy the underlying vector

names(y) <- NULL  # modifies the underlying vector
names(y)

# Factors -  a vector that can contain only predefined values, used to store categorical data
# one important use of attributes is to define Factors
# a factor is an integer vector with two attributes (properties):
# (1) class of "factor" which makes them behave differently from regular integer vectors
# (2) levels - which define the set of allowed values
# These kind of remind me of enums ...
# Useful when you know the possible values a variable may take
x <- factor(c('a', 'b', 'c'))
str(x)
class(x)
mode(x)
levels(x)
names(x)   # NULL
x

# You can't use values that are not in the levels
x[2] <- "d"
x  # a <NA> c
#Warning message:
#In `[<-.factor`(`*tmp*`, 2, value = "d") :
#  invalid factor level, NA generated

is.atomic(x) # TRUE
is.vector(x) # FALSE since it has other attributes besides names
is.character(x) # FALSE
is.integer(x)   # FALSE
is.numeric(x)   # FALSE
typeof(x)       # "integer"
is.factor(x)    # TRUE

# You can't combine factors
x <- c(factor("a"), factor("b"))  # just returns an atomic vector of integers
is.factor(x)
is.integer(x)
is.atomic(x)
levels(x)    # NULL
x

# Use  a factor over a character vec to know which groups contain no observations
sex_char <- c("f", "f", "f")
sex_factor <- factor(sex_char, levels = c("f", "m"))
table(sex_factor)   # shows a count of each category in sex_char

# You can cast a factor to character to get a character vector of levels
x <- factor(c('a', 'b', 'c'))
as.character(x)

# or cast into a numeric to get a vector integers/doubles
as.integer(x)
as.numeric(x)
is.double(as.numeric(x))

# I/O with factors
# Sometime when reading from a file, a column produces a non-numeric vector since there
# is a non-numeric value in the data. R tends to read the column in as a factor.
# To remedy the situation, coerce the factor vector to a character vector, inspect the values, coerce to a double vector.
# or use na.strings() when you can
# It is recommended to cast factors into the appropriate type before manipulating on them as other types
z <- read.csv(text = "value\n12\n1\n.\n9")  # read in a column we think is a numeric but isn't
z
typeof(z)
typeof(z$value)
is.factor(z$value)
class(z$value)
table(z$value)

# the wrong way - try casting input to a numeric vector
as.double(z$value)  # 3 2 1 4 -> not sure why tho
levels(z$value)     # prints them in alphabet order

# the right way - cast to character vector
as.double(as.character(z$value)) # warns us of an NA because of coercion

# or another right way is to change how we read it in
z <- read.csv(text = "value\n12\n1\n.\n9", na.strings = ".") # Coerce '.' -> NA
class(z$value)
is.factor(z$value)
is.double(z$value)
is.integer(z$value)
z$value
