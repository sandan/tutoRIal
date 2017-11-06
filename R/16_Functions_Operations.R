# To understand computations in R:
# 1) Everything that exists is an object
# 2) Everything that happens is a function call

# infix operators like +, control flow operators like for, if, and while,
# subsetting operators like [] and $, and even the curly brace { are functions
# Note that `, the backtick, lets you refer to functions or variables that have otherwise reserved or illegal names

# ARITHMETIC OPS
x <- 10 ; y <- 22   #note the ; used to execute the code on the same line
x + y                     # infix style
`+`(x, y)                 # prefix style

# CONTROL FLOW
for (i in 1:2) print(i)  # infix
`for`(h, 1:2, print(h))  # pre

if (i == 1) print("yes") else print("no")  # you can specify else in the same line, but not on a sep line (w/o braces)
`if`(i == 1, print("yes"), print("no"))

# SUBSET
x[3]       # infix
`[`(x, 3)  # pre

x[[1]]     # infix
`[[`(x, 1) # pre

# BRACES !?
{
  print(1)
  print(2)
}

`{`(print(1), print(2))

# there are occasions when it might be useful to re-define built-ins:
# it allows you to do something that would have otherwise been impossible
# (1) create DSLs
# (2) express new concepts using existing R constructs

# Another application is to reference built in operators
# ... instead of this ...
add <- function(x, y) x + y
sapply(1:10, add, 3)   # sapply = simplify apply
help(sapply)

# ... do this ...  (the actual value of the + operator)
sapply(1:5, `+`, 3)

# ... or this ...  (name of a function, which sapply can handle as input)
sapply(1:5, "+", 3)

formals(sapply)
body(sapply)
# sapply calls match.fun to match the name of the given function


# Another application: combining subsetting with lapply() or sapply()
x <- list(1:3, 4:9, 10:12)
sapply(x, "[", 2)  # get the second element of each double vector
# ... or do it anonymously ...
sapply(x, function(x) x[2])
