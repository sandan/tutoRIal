# (3) Function environments

# most environments are created by the use of functions
# 4 types of environments associated with a function:
# (1) enclosing env - env where the fn was created
#  - every fn has one and only one enclosing env
#  - use environment()

# (2) binding env - binding a function to a name
#  - this is the env where <- was called to bind the fn to a name
#  - use where()

# (3) execution env - ephemeral execution environment
#  - stores variables created during function execution
#  - parent.env(environment()) for fns defined inside fns

# (4) calling env - the env where the function was called
#  - every execution env is associated with a calling environment
#  - use parent.frame()

# there can be 0, 1 or many of (2), (3), and (4)

# (1) The enclosing environment
# When a fn is created it gains a reference to the environment where it was made - the enclosing env
# It is used for lexical scoping. It determines how the function finds values

y <- 1
f <- function(x, y){
  x + y
}
environment(f) #determine the enclosing environment of f
identical(environment(f), globalenv())


# (2) binding environments
# functions dont have names (they get bound to names with <-)
# the binding envs of a fn are all the envs which have a binding to it

# the binding env and enclosing env of the function above are the same
# ex:
e <- new.env()
e$h<-f            # f and h both point to the function, the fn has two binding envs (one in e and the other in globalenv())
environment(e$h)  # the enclosing environment is still the same for the fn (never changes even if it gets moved to a different env)
# The binding env determines how we find the fn

# The distinction between binding environment( how we find a function ) and the enclosing env( how the fn finds values )
# is important for package namespaces

# Package Namespace
# Namespaces are implemented using environments
# functions dont have to live in their enclosing environments

# ex:
environment(sd) # the enclosing environment of sd
where("sd")     # the binding environment of sd

# the definition of sd uses var
body(sd)
sd(1:10)
# if we define our own var function, it won't affect sd()
var <- function(x, na.rm = T) 100
sd(1:10)

# this works bc every package has two environments associated with it:
# (1) namespace environment - contains all fns (including internal)
#                           - has a parent env that is a special imports env that contains bindings to all the fns the package needs
# (2) package environment - contains every publicy accessible function and is placed on the search path

# every exported function in a package is bound to the package environment (where we can find the fn)
# but enclosed by the namespace environment   (where the fn finds its values)
search()  # package:stats is below the globalenv()
# so the sd() fn looks for var() in its enclosing env() and possibly above, not the globalenv() where I've defined var()

# What about for S3 methods?
# suppose package A defines methods for a class called "foo"
# and package B defines methods for a class called "foo"
# how will it know which "foo" to use? the methods themselves can always be used with package::
# if we want to allow users to implement certain S3 methods, how do we do so if those methods are defined in both packages?
# see https://github.com/hadley/adv-r/issues/864

# (3) Execution Environments
g <- function(x){
  if (!exists("a", inherits = F)){
    message("Defining a ...")
    a <- 1
  } else {
    a <- a + 1
  }
  a
}
g(10)
g(10)

# The function wil re-define "a" every time it is called (fresh-start principle)
# each time a function is called a new env is called to host the execution
# The parent of the execution environment is the enclosing environment of the function (not the binding environment)
# once execution completes, the environment is thrown away

h <- function(x){
  a <- 2          # the execution env of h defines a and x and assigns those names values
  x + a           # note that the x in the enclosing env is not used for the val of the arg x
                  # however, if a reference occurs in a fn that isn't an arg, it will looks in its parent.frame() env (like smalltalk)
}
y <- h(1)         # execution environment goes away

# function closures and execution environments
# a function A defined inside another function B has its enclosing environment the execution environment of the function B
# this makes the execution environment of B non-ephemeral

plus <- function(x){
  function(y) y + x
}

# a function factory that returns another function instantiated with args in the factory
plus_one <- plus(1)
help("environment") # gets the enclosing environment of funcion
identical(parent.env(environment(plus_one)), environment(plus))
environment(plus_one)  # this is the execution environment of plus()
where("plus_one")
ls.str(environment(plus_one))
identical(environment(plus), globalenv())
search()  # doesn't show excution environments of functions

# (4) calling environments
h <- function() {
  x <- 10
  function() {
    x
  }
}
i <- h()
x <- 20
i()   # should be 10 since the enclosing environment of i is h,
      # which defines x in an execution env which is a child of the enclosing env (globalenv())
# x is 10 in the env where h() is defined (enclosing env)
# x is 20 in the env where h() is called (calling env)

# we can access the calling environment of a function using parent.frame()
# parent.frame()

help("parent.env")    # the parent env of an env
help("parent.frame")  # calling env of a function

# they may be the same but they're different in general
parent.env(e)
parent.frame(e)  # invalid n value (?)

f2 <- function(){
  x <- 10
  function(){
    def <- get("x", environment())  # 10 ( the execution env of f2)
    cll <- get("x", parent.frame()) # 20 (the calling env of execution env of f2)
    list(defined = def, called = cll)
  }
}
g2 <- f2()
x <- 20
str(g2())

# fns will look for variables in a sequence of parent frames if no variable is found
x <- 0
y <- 10

# each fn's execution env has two parents:
f <- function(){  # enclosing env() is globalenv()
  x <- 1          # calling env is globalenv()
  g()
}

g <- function(){ # enclosing env() is globalenv()
  x <- 2         # calling env is f()
  # y <- 10
  h()
}

h <- function(){ # enclosing env() is globalenv()
  x <- 7         # calling env is g()
  x + y
}

f()  # 10 + 7

# the scoping rules of R only uses the enclosing env to look for variables,
# so if you uncomment the line in f() and rm(y) from globalenv()
# we get an error (object 'y' not found) since y is not in the enclosing env() of h
# the scoping rules don't look at parent.frame() execution envs
rm(y)


# looking up variables in the calling env rather than the enclosing env is called dynamic scoping.
# (see non-standard evaluation)
