# Calling functions

# You can specify arguments by position or name
# there is partial matching for names

# args are matched first by exact name, partial name, then by position
f <- function(abcdef, bcde1, bcde2){
  list(a = abcdef , b1 = bcde1 , b2 = bcde2)
}

# by position
str(f(1, 2, 3))

# by exact name ( the others are matched by position )
str(f(1, 2, abcdef = 3))
str(f(1, abcdef = 2, 3))
str(f(abcdef = 1, 2, 3))

# by partial matching (the rest are matched by position)
str(f(1, 2, a = 3))

# ambiguous partial matching
str(f(1, 2, b = 3))
n <- names(formals(f))
n[startsWith(n, "b")]

# Generally, the first one or two args are the most commonly used.
# These are usually matched by position.

# If you are writing code for a package that you want to publish on CRAN,
# you can not use partial matching, and must use complete names

# Named arguments should always come after unnamed arguments when callng functions.
# If a function uses ... (discussed in more detail below),
# you can only specify arguments listed after ... with their full name.

# Calling a function with lists of args
args <- list(1:10, na.rm = T)
# use do.call to call fun with list of args
do.call(mean, args)
# .. is the same as ..
mean(1:10, na.rm = T)

# Default and missing arguments
# you can set default args by using = in the fn def's arg list
f <- function(a = 1, b = 2){
  c(a,b)
}
f()

# default values can be defined in terms of other arguments
g <- function(a = 1, b =  a * 2){
  c(a,b)
}
g()
g(10)

# default arguments can even be set by variables defined inside the scope of the fn

h <- function(a = 1, b = d){
  d <- (a + 1)^2
  c(a, b)
}

# generally considered bad practice since it forces the reader to read the whole source
# to determine the default values of fns
h()
h(10)


# you can determine whether a function is missing or not with missing()
i <- function(a = 1, b = 2){
  c(missing(a), missing(b))
}
i()
i(1)  # match by position from left to right
i(2, 3)
i(b = 1, 1)
i(b = 1, a = 1)

# if a default value of a function is too complicated,
# you can use missing() to conditionally compute it in the body of the function
# this makes it hard to know which args are required and which are optional
# instead, it is good practice to use is.null() and set the default value of an arg to NULL

j <- function(a, b = NULL){
  c(missing(a), missing(b))
}
j()
j(1)
j(b = 9)
j(1, 2)

# Lazy Evaluation
# by default, R function arguments are lazy - they're only evaluated if actually used
f <- function(x){
  10  # here x is not used
}
f(stop("This is an error!"))  # so this stop() won't get evaluated

# to force the evaluation of an argument use force()
f <- function(x){
  force(x)
  10
}
f(stop("error!"))

# force() can be useful when using closures with lapply() or a loop
# note that x is evaluated for each 1:10 in add()
# each call will save a different x to be added with y

add <- function(x){
  function(y) x + y
}
adders <- lapply(1:10, add)
adders[[1]](10)  # add 10 to the first arg (1)
adders[[2]](10)
adders[[10]](10) # add 10 to the last arg (10)

# Default arguments are evaluated inside the function
f <- function(x = ls()){
  a <- 1
  x
}
f() # ls() gives the variables in current scope (environment)
help(ls)
# returns a x

f(ls())  # ls() evaluated in global scope
# returns all in global environment


# An unevaluated argument is called a "promise" (sometimes called a "thunk")
# A promise is made of two parts:
# 1) the expression itself (which can be accessed with substitute())
# 2) the environment where it was created and where it should be evaluated

help("substitute")

# PROMISE (THUNK)
# The first time a promise is accessed the expression is evaluated in the environment where it was created.
# This value is cached, so that subsequent access to the evaluated promise does not recompute the value
# (but the original expression is still associated with the value, so substitute() can continue to access it).

# You can find more information about a promise using pryr::promise_info().
# This uses some C++ code to extract information about the promise without evaluating it, which is impossible to do in pure R code

# Lazy eval happens in if statements - short-circuiting

## && (and)
x <- 0
if (x > 0 && stop("err!")){
  print('shouldnt be here...')
}else{
  print('inside else')
}

## || (or)
if (is.null(NULL) || stop("err!")){
  print("inside if")
} else{
  print("shouldn't be here ...")
}


# implementing binary operators:
`&&` <- function(x, y){
  if (!x) return (F)
  if (!y) return (T)
  F
}
T && F   # evals to TRUE
rm(`&&`)

# you can even override some symbols to be binary ops
`.` <- function(x, y){
  if ((x || y) && !(x && y)){
    return (T)
  }
  F
}

`#` <- function(x, y){
  if ((x || y) && !(x && y)){
    return (T)
  }
  F
}
`.`(T, T)
`#`(T, T)
# but using their infix form doesnt work


# ... (ellipses) - matches any args to fns not otherwise matched
# makes fns flexible but requires users to read the docs for specific needs
#  - API can be flexible but the user may still have to change code
#  -
# arguments after ... must be named
f <- function(a, ..., c){
  list(a, c)
}
f(1, 2, 3)  # err: argument "c" is missing, with no default
f(1, 2, c = 3)

# you can capture the ... with list()
f <- function(name, ...){
  if (name){
    return(names(list(...)))
  }
  list(...)
}
f(F, 1, 2, 3)
f(T, a = 1, b = 2)
f(F, a = stop("i am being evaluated in list!"))

# misspelled args wont be noticed when using ...
sum(1, 2, NA, na.mr = TRUE)

# when using ... ask: when is it better to be explicit than implicit?

# unmatched named args don't get inferred by position if names don't match (partially or fully)
f <- function(t){
  return(t)
}
f(a = 1)  # err unused argument

help(runif)  # uniform distribution

# default args x and y
# x is 2 since 2 is the last value in the expr
# y is 1 (set in x's default expression)
# then sum
f1 <- function(x = {y <- 1; 2}, y = 0) {
  x + y
}
f1()

# default arg x is z which is set in the function body
f2 <- function(x = z){
  z <- 100
  x  # returns z
}
f2()
