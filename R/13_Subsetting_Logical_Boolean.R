# (1) Selecting rows based on a condition
# logical subsetting is prob the most commonly used technique for extracting rows out of a data frame
# you can easily combine conditions from multiple columns

mtcars[mtcars$gear == 5, ]                    # get all rows where gear is 5
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ]  # get all rows where gear is 5 and cyl is 4

# Vector boolean operators: &, |
# Short circuiting scalar operators && and || which are more useful inside if statements.

help(subset)
# subset is a specialized shorthand function for subsetting data frames
subset(mtcars, gear == 5)
subset(mtcars, gear == 5 & cyl == 4)

# (2) Boolean algebra vs. sets (logical & integer subsetting)
# Using set operations is more effective when:
# - you want to find the first (or last) TRUE
# - you have very few TRUEs and very many FALSEs; set representation may be faster and require less storage.
#  which() allows you to convert a boolean rep to an integer rep

help(which)

x <- sample(10) < 4 # assignment allows for logical expressions
x                   # the result is a logical vector
which(x)   # gives the indices of x that evaluate to T (converts boolean rep to integer rep)
           # no base R implementation that converts integer rep to bool rep, but we can easily make one:
help("rep_len")

unwhich <- function(x, n){
  # x is an integer vector that specifies which indices are TRUE
  # n is the length of x
  out <- rep_len(FALSE, n)  # create a logical vector of length n and init with FALSE
  out[x] <- TRUE            # set the boolean vector's TRUE elements
  out
}

unwhich(which(x), 10)

# boolean and set operations
(x1 <- 1:10 %% 2 == 0)  # %% is the mod operator, note the precedence

(x2 <- which(x1))  # putting parens around the assignment evaluates the RHS and assigns to LHS
x2

(y1 <- 1:10 %% 5 == 0)
(y2 <- which(y1))

# INTERSECT
x1 & y1            # vectorwise comparison of logical vectors (1:10 %% 5 == 0) & (1:10 %% 2 == 0)
intersect(x2, y2)  # intersection on integer vectors -> gives indices where intersection is TRUE

# UNION
x1 | y1           # vector-wise comparison of logical vecs
union(x2, y2)     # union of integer vecs -> gives indices where union is TRUE

# SET DIFFERENCE
x1 & !y1          # vec-wise set difference of logical vecs: x1 and not y1
setdiff(x2, y2)   # set diff on integers -> gives indice where set diff is TRUE

# which() will drop NA's in the logical vec
# be careful when using which() with NA's to subset
x <- c(NA, T, F)
which(x)

y <- c(1, 2, 3)
y[x]          # NA 2   logical subsetting with an NA turns the elmt to NA
y[which(x)]   # 2

# ! and -which() are not equivalent
-which(x)
!x
y[-which(x)]  # everything except the second element  (drops NAs)
y[!x]         # NA 3

y <- 1:10 > 11
y
which(y)   # if y is all F, then it returns integer(0)
-which(y) # still integer (0)
!y

# randomly permute the cols of a df
set.seed(21)
df <- data.frame(x = 1: 10,
                 y = letters[1:10],
                 z = 1:10 <= 8)
df[, sample(ncol(df))]

# randomly permute rows and cols
df[sample(nrow(df)), sample(ncol(df))]

# select a random sample of m rows from a df
m <- 4
df[sample(nrow(df), m), ]

# select a random contiguous set of rows from a df
endpts <- sample(nrow(df), 2)
rows <- c(min(endpts):max(endpts))
df[rows, ]

# select a random contiguous set of m rows from a df (assuming nrow(df) > m)
help(order)
m <- 4
random_endpoint <- sample(nrow(df) - m, 1)  # beginning endpoint selected so we can another endpoint at +m
df[random_endpoint : ((random_endpoint + m) - 1), ]  # note the parens are needed

# put columns of a df in alphabetical order
df[, order(names(df))]
