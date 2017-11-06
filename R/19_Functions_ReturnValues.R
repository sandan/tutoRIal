# The last expression evaluated in a function is the return value
# functions can return a single object, but you can always return a lists of objects
# The easiest functions to reason about are pure functions, these functions have no side effects -
# they dont affect the workspace in anyway, they always map the same input to the same output
# they don't affect the state of the world in any way apart from the value that they return

# modifying an argument of a function doesn't affect the original value
# most R objects have copy on modify semantics
f <- function(x){
  x$a <- 2
  x
}
x <-list(a = 1)
f(x)
x["a"]
x$a

# The exceptions are environment objects and reference classes, these can be modified in place
# Most base R functions are pure, with a few notable exceptions:
#   library() which loads a package, and hence modifies the search path.
#   setwd(), Sys.setenv(), Sys.setlocale() which change the working directory, environment variables, and the locale, respectively.
#   plot() and friends which produce graphical output.
#   write(), write.csv(), saveRDS(), etc. which save output to disk.
#   options() and par() which modify global settings.
#   S4 related functions which modify global tables of classes and methods.
#   Random number generators which produce different numbers each time you run them.

# It’s generally a good idea to minimise the use of side effects,
# and where possible, to minimise the footprint of side effects by separating pure from impure functions

# INVISIBLE values
f1 <- function()  1
f1()  # prints the return value
f1 <- function() invisible(1)
f1()  # doesn't print the return value
x <- f1()  # but it still returns the value
x     # prints the value of 1

# you can force an invisible value to be displayed by wrapping it in parens
(f1())

# the most common function that returns invisibly is <-
a <- 2
(a <- 2)

# so you can actually assign one value to multiple variables
a <- b <- c <- 2
# ... is equivalent to ...
a <- (b <- (c <- 2))


# on.exit()
# functions can trigger behavior to run upon exiting
# the code in on.exit() is run regardless of how the function exits
# this is useful for working with functions that change state, remember to set the state back using on.exit
in_dir <- function(dir, code){
  old_dir <- setwd(dir)   # setwd returns the old wd
  print(old_dir)
  on.exit(setwd(old_dir)) # we set the dir back upon exiting

  invisible(force(code))  # then we force() the code (the force() isn't needed
                          # but it makes it clear that we mean to execute the code)
}
getwd()
(in_dir("~", getwd()))

# Caution: If you’re using multiple on.exit() calls within a function,
# make sure to set add = TRUE. Unfortunately, the default in on.exit() is add = FALSE,
# so that every time you run it, it overwrites existing exit expressions.

help(source) # used to read R code from a file or connection (like URL)
# it has a param called chdir that when T changes to the dir containing file for evaluating
help(sink)   # diverts R output to a connection like file
help("capture.output")
body(capture.output)

# on.exit() is used here to create a simplified version of capture.output
capture.output2 <- function(code) {
  temp <- tempfile()
  on.exit(file.remove(temp), add = TRUE)

  sink(temp)
  on.exit(sink(), add = TRUE)

  force(code)
  readLines(temp)
}
capture.output2(cat("a", "b", "c", sep = "\n"))
