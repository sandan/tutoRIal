# Data frames posess characteristics of both lists and matrices
# if you subset with a single vector, they behave like lists
# if you susbet with two vectors, they behave like matrices

df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df

df[df$x == 2, ] # all columns with rows where col x = 2
df[c(1, 3), ]   # all columns with rows 1 and 3
df[c(T, F), ]   # all columns with odd rows

# Selecting columns
df[c("x", "z")]    # vector with column names
df[ , c("x", "z")] # matrix index form

# Subsetting a single column
# list subsetting gives back a data frame
df[c("x")]
df["x"]

# matrix subsetting simplifies the return value to a vector
df[ , "x"]
df[ , c("x")]
str(df[ , "x"])
is.list(df[ , "x"])
is.atomic(df[ , "x"])
is.vector(df[ , "x"])

# Subsetting S3 objects
# these objects are made up of atomic vectors, arrays, lists,
# so you can always pull apart an S3 object using the techniques described above

# S4 objects
# There are two additional subsetting operators that are needed for S4 objects: @ (equivalent to $)
# and slot() (quivalent to [[ ). See the OO field guide.

mtcars
is.data.frame((mtcars))  # TRUE
mtcars[mtcars$cyl == 4, ]  # all rows where cyl col is 4
mtcars[1:4, ]    # get the first 4 rows
mtcars[mtcars$cyl <= 5, ]  # all rows where cyl col is <= 5
mtcars[(mtcars$cyl == 4) | (mtcars$cyl == 6),  ]  # all rows where cyl is 4 or 6

x <- 1:5
x[NA] # gives 5 NA's since NA is logical by default so it is recycled to be of length 5

x <- outer(1:5, 1:5, FUN = "*")
x
upper.tri(x)    # gives a logical matrix back with the upper triangular part TRUE and others FALSE
x[upper.tri(x)] # gives a vector of elements in the matrix where the element is in a TRUE position

mtcars[1:20]  # throws an err since there aren't that many cols to index
mtcars[1:20, ]# get all columns and rows 1 thru 20
length(mtcars)# 11
nrow(mtcars)  # 32

df[c(1), c(1)] <- NA
df
df[is.na(df)] <- 0 # this sets the NA entries of the df to 0
df
