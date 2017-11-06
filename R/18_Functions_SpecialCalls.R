# Infix Vs Prefix functions

# user-defined functions are mostly prefix
# users can also define infix functions, they must start and end with %

# R has the following pre-defined infix ops:
# %%
# %*%
# %/%
# %in%
# %o%
# %x%
# pre-built infix operators
# : :, ::, :::, $, @, ^, *, /, +, -, >, >=, <, <=, ==, !=, !, &, &&, |, ||, ~, <-, <<-

`%+%` <- function(a, b){
  paste(a, b)
}
"new" %+% "string"

# infix and prefix calls are equivalent, difference is syntactic sugar
`%+%`("new", "string")
# note that when calling the function in prefix form, it must be in backticks ``

# user defined infix function names can be any character (except %)
# a space
`% %` <- function(a, b){
  paste(a, b)
}
"new" % % "string"

# a comma
`%'%`<- function(a, b){
  paste(a, b)
}
"new" %'% "string"

# slashes
# note the escape slash on the back slash
`%/\\%` <- function(a, b){
  paste(a, b)
}
"new" %/\% "string"

# infix operators are composed from left to right
`%~%` <- function(a, b){
  paste("(", a, "%~%" , b,")")
}
"a" %~% "b" %~% "c"

# Note that the infix op || is inly used inside if
NULL || 2
if (NULL || 2){
  print("2")
}

# however, we can use it to evaluate expressions outside of if stmts:
`%||%` <- function(a, b){
  if (!is.null(a)){
    a
  }
  b
}
NULL %||% 2

# REPLACEMENT Functions
# these are functions like class() or names() that allow you to modify state of an object
# these functions have special names when they're defined (`*<-` <- function(x, value)...)
`second<-` <- function(x, value){
  x[2] <- value
  x
}
x <- 1:10
second(x) <- 50
x

# when R sees a replacement function, it makes a copy of the object being modified then returns the modified copy
library(pryr)
help(address)
x <- 1:10
address(x)
second(x) <- 50L
address(x)

# Primitive functions will modify in-place so the object is at the same address (??? this doesn't seem to be the case...)
x <- 1:10
address(x)
x[2] <- 7L
x
address(x)
is.primitive(`[`)

# supplying additional args for replacement functions can be done like so:
`modify<-` <- function(x, position, value){
  x[position] <- value
  x
}
modify(x, 1) <- 10
x

# behind the scenes, R re-arranges the call like so:
# x <- `modify`(x, 1, 10)
# so this is an error:
modify(get("x"), 1) <- 10   # target of assignment expands to a non-language object

# since it expands to the expression:
# get("x") <- `modify`(get("x"), 1, 10)

# combining replacement and subsetting
#
x <- list(a = 1, b = 2, c = 3)
names(x)[2] <- "two"
names(x)
x

# R takes the above and does the following:
# 1) create a temp variable
# `*tmp*` <- names(x)
# 2) subsets the temp variable and sets the value
# `*tmp*`[2] <- "two"
# 3) sets the names(x) with the modified names
# names(x) <- `*tmp`

# get all the replacement functions
b <- ls("package:base")
replacement <- mget(b[endsWith(b, "<-")], inherits = T)
primitives <- Filter(f = is.primitive, replacement)
length(primitives)   # 17 primitive replacement functions
names(primitives)
help(`<<-`)

# valid names for user defined infix functions
# any sequence of characters between % and % (except %)

# an xor infix op
`%my_xor%` <- function(a, b){
  if ((a || b) && ! (a && b)){
    T
  } else{
    F
  }
}  # or just call base R's xor
T %my_xor% F
F %my_xor% T
T %my_xor% T
F %my_xor% F

# create an infix ops for intersect, union, setdiff
# these ops will dicard any duplicate values and apply as.vector to their args

# intersect
`%cap%` <- function(a, b){
 intersect(a, b)
}
1:10 %cap% 5:9

# union
`%cup%` <- function(a, b){
  union(a, b)
}
1:10 %cup% 11:17

# setdiff
`%-%` <- function(a, b){
  setdiff(a, b)
}
1:20 %-% 3:9

# randrep is a replacement function that modifies a value in a random position
set.seed(99)  # setting the seed inside makes the function non-random since the seed
              # is reset inside the function on each call
`randrep<-` <- function(x, value){
  index <- sample(1:length(x), 1)
  x[index] <- value
  x
}
x <- 1:10
randrep(x) <- 33
x
randrep(x) <- 33
x
