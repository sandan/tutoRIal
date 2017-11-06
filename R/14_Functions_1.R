# Dependencies: pryr
# Function Components
# Functions are objects

# 3 main components
# body(): body of function (no comments/formatting)
# formals(): arguments to function
# environment(): "map" of where the function is located

sessionInfo()
library(RUnit)

# Example: examining functions more in-depth from RUnit
help(checkEquals)
formals(checkEquals)
body(checkEquals)
environment(checkEquals)

# Functions have classes and types
class(checkEquals)
typeof(checkEquals)
mode(checkEquals)

class(print)   # function
typeof(print)  # closure
mode(print)    # function
length(print)  # 1 ?

# Like all objects in R, functions can possess any number of attributes
attributes(print)

# You can also add attributes to a function
x <- function(y){
  (y**y)/sqrt(y)
}
class(x) <- "thingy"

print.thingy <- function(thingy){
  print("my thingy")
}

print(x)

# srcref: like body() but with comments + formatting
help(srcref)
srcref(checkEquals)
body(print)
print

# Primitive Functions
# Some functions are written in C and thus have no formals(), body(), environment()
# These functions are called with .Primitive() and are only in base R
# operate at a low level, more efficient, have different rules for argument matching
body(sum)         # NULL
formals(sum)      # NULL
environment(sum)  # NULL
mode(sum)      # function
typeof(sum)    # builtin
class(sum)     # function
length(sum)    # 1 ?
sum      # .Primitive("sum")

is.function(sum)
is.primitive(sum)
is.function(is.function)
is.primitive(is.function)
is.primitive(print)

# ls(), mget(), Filter()
help(ls)
ls()  # show the variables and datasets user has defined
      # useful with browser() for debugging
help(browser)
ls("package:base") # shows the functions defined in base R

help(mget) # search by name for objects (0 or more)
# These functions look to see if each of the name(s) x have
# a value bound to it in the specified environment.
# If inherits is TRUE and a value is not found for x in the specified environment,
# the enclosing frames of the environment are searched until the name x is encountered.

# get a list of the functions from the base R package
objs <- mget(ls("package:base"), inherits = T)
is.list(objs)
names(objs)
# mget returns a named list of elements in package:base
# The value of the list is a list of metadata about the object with that name in package:base

# not all elements in the list of functions are functions...
length(lapply(objs, is.function))                           # total: 1213
length(which(as.logical(lapply(objs, is.function))))        # total: 1202
non_funcs <- which(!as.logical(lapply(objs, is.function)))  # total: 11
objs[non_funcs]
length(objs)

# Another way is to use Filter()
help("Filter")
help(Negate)

funs <- Filter(is.function, objs)
is.list(funs)
length(funs)  # 1202

# using Filter with Negate, !is.function doesn't work
non_funs <- Filter(Negate(is.function), objs)
non_funs
length(non_funs)

# which base function(s) has the most arguments
funcs <- Filter(is.function, mget(ls("package:base"), inherits = T))  # filter functions from base
lens <- Map(length,       # get the length of each character vector in the list
            Map(formals,  # this results in a list of character vectors
                funcs))   # map funcs to their list of args

max_args <- Reduce(max, lens)    # reduce the list to the maximum arglen
answr[answr == max_args]          # find elements in the list equal to maximum arglen
# Answer: scan with 22 arguments

which(lens == max_args)          # where is scan in the list of funcs?
funcs[937]                        # at 937, this is a list of metadata about the scan func

length(formals(names(funcs[937])))
#... or since we already know the function...
length(formals(scan))
help(scan)   # read data into a vec or list from a console (stdin) or file

# How many base functions have no arguments?
length(lens[lens == 0])  # 225
# these functions have formals() evaluate to NULL (length(NULL) == 0)
Map(is.primitive, funcs[lens == 0])  # not all of them are primitive
# find all primitive functions that have length(formals()) == 0
prims <- Filter(is.primitive, funcs[lens == 0])
length(prims)   # 183

# primitive functions have NULL environments, so printing them shows no environment
length(Map(is.null, Map(environment, prims)))

# histogram of function arguments
hist(unlist(lens[lens > 0]))

# Get a list of functions from the TDR package
#  - How many are there? Create a histogram of lengths of body/ formals()
#  - how many are replacement functions?
#  - how many are user defined operators?
#  - how many call SQL?
#  - how many are backend specific?
#  - how many are pure? impure?
