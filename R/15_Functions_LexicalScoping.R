# Lexical Scoping
# Scoping is the set of rules R uses to look up a value of a symbol

# lexical scoping is implemented automatically at the language level of R
# - looks up values of symbols based on how the function/variable was created
# - determines where to look for variables
x <- 0
rm(x)  # removes a variable from the environment

# 4 basic principles for lexical scoping:
# name masking - soonest scope takes precedence
# funcs vs. variables - same for functions except when var used in context of func
# fresh start - function re-creates its env every time it is called
# dynamic lookup - when to look for values of a function


# (1) name masking
f <- function(){
  x <- 1
  y <- 2
  c(x, y)
}
res <- f()
rm(f)
formals(rm)[1]  # rm takes a variable number of args as the first parameter

# is a name isn't defined inside a function, it will look one level up
x <- 0
f <- function(){
  y <- 9
  c(x, y)
}
f()
rm(x, f)

# the same rules apply if a function is nested inside another function

x <- 0
f <- function(){
  y <- 9

  g <- function(){
    z <- 10
    c(x, y, z)
  }

  g()
}

f()
rm(f, x)  # notice that nested functions dont make it into the environment, only f

# if it can't find a value in the function, the next outer function, ..., the environment, it will look at loaded packages


# the same rule applies to closures
x <- 0
j <- function(x){
  y <- 8

  function(){  # this is the return value of j, a function (with some state (y))
    # x <- 100  this x takes precedence since its scope is closer
    c(y, x)
  }
}
k <- j(9) # k preserves the environment in which it was defined (inside j, which has defined y)
k()
rm(j, k)

# (2) funcs vs. variables
# Finding functions works exactly the same way as finding variables
 l <- function(x) x + 1
 m <- function(){
   # l <- function(x) x**2  this function takes precedence
   l(10)
 }
m()
rm(l, m)

# There is an exception for functions
# If you use a variable they way you would a function,
# then it ignores any non-function variables

n <- function(x) x + 2
g <- function(){
  n <- 10
  n(n)
}
g()
rm(g, n)

# It is good practice to keep variable names different from function names
# reserved function names
c <- 10     # variable named c
c("c" = c)  # collection used in funciton context, with named arg "c" whose value is c (var. 10)


# (3) fresh start - function re-creates its env every time it is called
help(exists)  # look for an R object of the given name and return T if found
j <- function(){
  if (!exists("a"))
    a <- 10
  else
    a <- a + 20
  a
}
j()     # running the first time
j()     # running the second time -> returns 10 again since "a" only exists in the scope of the function
rm(j)   # removing the function from env.

# this can kind of be used to implement private variables

create <- function(x){

  priv <- function(){
    print("boo!")
  }

  h <- function(){
    list(x, priv)  # an "object" with state and methods
  }
  h()
}

thing <- create(100)
thing[[2]]()

# (4) dynamic lookup
# R looks for values when a function is actually run, not when a function is created
# the output of a function can be different depending on the state of the environment outside the function

x <- 0
f <- function() x + 2
f()
x <- 1
f()

# you can use findGLobals to find the external dependencies of a function
codetools::findGlobals(f)   #  + is an external dependency too (its also a function)
                            # It’s never possible to make a function completely
                            # self-contained because you must always rely on
                            # functions defined in base R or other packages.
is.function(`+`)   # you can reference symbols used in R with backticks around the symbol

# you can also manually set the environment of a function
environment(f) <- emptyenv()  # set the environment of function f to an empty env. (doesn't affect current env)
f()
rm(f)

# best to think of nested funcs from inside out
f <- function(x){
  f <- function(x){
    f <- function(x){
      x ^ 2   # returns x squared
    }
    f(x) + 1  # x^2 + 1
  }
  f(x) * 2 # 2 (x^2 + 1)
}
f(10)
