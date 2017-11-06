# (1) Environment Basics
# An environment's purpose is to bind a set of names with a set of values
# You can think of an environment as a set of names
# each name points to an object stored elsewhere in memory

e <- new.env()
e$a <- FALSE
e$b <- "a"
e$c <- 3.14
e$d <- 4:11

# These names point to objects:
# a -> F
# b -> "a"
# c -> 3.14
# d -> 4 5 6 7 8 9 10 11

# The objects on the right hand side don't live in the environment
# so you multiple names can point to the same object
e$a <- e$d

# e$a -> 4:11 <- e$d

# names can also point to different objects with the same values
e$d <- 4:11
# e$d -> 4:11
# e$a -> 411

# If an object has no names pointing to it, then the object gets GC'd

# Every env has a parent. When a variable name is sought, it will look at the current
# env and keeps looking up the hierarchy of parent envs until it can find the name.

# The empty environment is the only environment without a parent environment
# Every environment has the empty environment as an ancestor
# Given an environment, we can't access its child environment

# An environment is similar to a list except :
# 1) every name in a certain environment is unique
list(a = 1, a = 2)
e$a <- 9
e$a <- 10  # overwrite
e$a
# 2) the names in an environment are not ordered
# 3) an environment has a parent
# 4) environments have reference semantics
# - that is, they do not copy-on-modify
# - they're mutable

help(parent.env)

# An environment is made up of 2 components:
# 1) Frame - contains the name-object bindings (behaves like a named list)
help(parent.frame)  # gives you the calling environment (the environment calling the function)
                    # not the frame of the calling environment
# 2) Parent Env

# There are 4 special environments:
# 1) globalenv() - the env in which you currently work
#                - the parent of this env is the last package attached with library() or require()
??globalenv
# 2) baseenv() - the base environment - the env of the base R package. Its parent is the empty env.
??baseenv
# 3) emptyenv() - the ultimate ancestor env, only one without a parent
??emptyenv
# 4) environment() - the current environment (can be used inside functions to get the current env they're in)

# environments form a hierarchy in general, but from the
# user's perspective of loading library/require packages, it is more like a list

help(search)
search() # lists all parents of the global env (the interactive workspace)
# the list is also called the search path because objects in these environments
# can be found from the top-level interactive workspace.

# It returns a character vector that contains one environment for each attached package
# and any other objects that you’ve attach()ed. The elements of the vector are names of the environment

# It also contains a special environment called Autoloads which is used to save memory by only loading
# package objects (like big datasets) when needed. Autoloads sits under base.

# the list is ordered so that
search()[[1]]                # 1 is the globalenv()
search()[[length(search())]] # the last element is the package:base

# you can access an environment on the search list with as.environment()
as.environment(search()[[1]])
ls.str(globalenv())

# The beginning of an R environment looks like:
# emptyenv()
# baseenv()    <--- search()[[length(search())]]
# .
# .
# .
# globalenv()  <--- search()[[1]] <--- you are here  (this is the "top" of the search list)

# loading a package will insert it in between baseenv() and globalenv(), right above globalenv():
library(RUnit)
# emptyenv()
# baseenv()
# .
# .
# .
# RUnit        <--- loaded libs go here
# globalenv()  <--- you are here

# Create a new env: use new.env()
# you can list the variable bindings in an environment with ls()
# you can find the parent environment with parent.env()
help(parent.env)
parent.env(e)   # the default parent provided by new.env() is the environment from
                # which it is called - in this case that's the global environment.
# list all the names in the environment
ls(e)

# the easiest way to modify the bindings in the list is to use $
e$e <- 11
e$e

# by default ls() doesn't show bindings beginning with .
e$.k <- 100
ls(e)
ls(e, all.names = T)  # use all.names to show them

# use ls.str() to view an environment - to show the objects that the names point too as well
str(e)   # not much info on the names and objects (the frame of the environment)
ls.str(e)
ls.str(e, all.names = T)

# In general, given a name, you can extract the value using $, [[, or get/mget
# $ and [[ look only in one environment and return NULL if there is no binding associated with the name.
# get() uses the regular scoping rules and throws an error if the binding is not found.
help(get)
get(".k")    # none found since .k is in e, which is a child of this env
get(".k", envir = e)

e[[".k"]]
e$.k

# Deleting objects
# with a list you can remove an entry by assigning the name/position to NULL
# in environments, assigning to NULL will create a new binding to NULL, instead use rm()
e <- new.env()
e$a <- 1
e$a <- NULL
ls(e, all.names = T)
rm("a", envir = e)
ls(e, all.names = T)
length(c("a")[-1])  # character(0) means empty character vec

# You can determine if a binding exists in an environment with exists().
# Like get(), its default behavior will search the env hierarchy
# you can restrict the search to just the current environment by setting inherits = FALSE

x <- 10                  # this is in globalenv(), e is a child of this env
exists("x", envir = e)   # true since it will search the parent env of e too
exists("x", envir = e, inherits = F) #False, search is restricted to just e


# Comparing environments:
# use identical() not ==
identical(globalenv(), environment())  # is global env the same as the current env? T since I'm calling both.
globalenv() == environment()   # Error == possible only for atomic and list types
list(a = 1) == list(a = 2)  # comparison of these types not impl...
list(1) == list(1)          # comparison of these types not impl...

my_search <- function(envir, seen_base, seen_empty){
  if (identical(envir, emptyenv())){
    return(seen_base & T)   # emptyenv() is the ancestor to all envs

  }else if (identical(envir, baseenv())){
    return (my_search(parent.env(envir), T, F))

  }else{
    return (my_search(parent.env(envir), F, F))
  }
}
my_search(globalenv())

help(parent.env)
help("parent.frame")


# (2) Recursing over Environments
# In general, environments form a tree.
# Understanding pryr::where
# Given a name, where() finds the environment where the name is defined using R's regular scoping rules
help(where)
library(pryr)
search()
# RUnit
# pryr
# GlobalEnv
x <- 5
identical(where("x"), environment())
identical(where("x"), globalenv())
identical(where("mean"), baseenv())

# The definition of where has two arguments
formals(where) #: name to look for as a string, env = parent.fame() to start the search
body(where)

# modify where to find all environments that contain a binding for a name
help(stopifnot)
my_where <- function(name, env = parent.frame(), envs = list()){

  stopifnot(is.list(envs), is.environment(env), is.character(name))
  if (identical(env, emptyenv())){
    envs
  } else {
    if (exists(name, envir = env, inherits = F)){
        my_where(name, parent.env(env), c(envs, env))
    } else {
      my_where(name, parent.env(env), envs)
    }
  }
}

e$x<-55
ls.str(e)

exists("x")  # env = globalenv()
exists("x", env = e)

my_where("x", env = e)
my_where("x")

my_get <- function(name, env = parent.frame()){

  stopifnot(is.character(name), is.environment(env))

  if (identical(env, emptyenv())){
    stop(c(name, " not found"))

  } else if (exists(name, envir = env, inherits = F)){
    get(name, envir = env, inherits = F)

  }else{
    my_get(name, parent.env(env))
  }
}

my_get("x")
my_get("y")
my_get("x", env = e)

# fget: takes name, env and looks for function objects
# Within an environment, variable names are unique
# inherits controls whether the function recurses up the parent or only looks in current env
fget <- function(name, env = parent.frame(), inherits = T){

  stopifnot(is.character(name), is.environment(env))

  if (identical(env, emptyenv())) {
    stop(c("function: ", name, " not found"))

  }else if (exists(name, envir = env, inherits = F)){
    f <- get(name, envir = env, inherits = F)
    if (is.function(f)){
      f
    }

  }else {
    if (inherits) fget(name, parent.env(env), inherits)
    else stop("function: ", name, " not found in given environment")
  }
}

e$g<- function(x){
  x + 1
}
e$g

g <- function(x){
  x + 3
}
fget("g")
fget("g", e)
fget("g", inherits = F)
fget("g", e, inherits = F)
fget("g", as.environment(search()[[2]]))
fget("g", as.environment(search()[[2]]), inherits = F)

body(get)
body(exists)

# write a version of exists (use ls())
my_exists <- function(name, env = parent.frame(), inherits = T){
  stopifnot(is.character(name), is.environment(env), is.logical(inherits))

  if (identical(env, emptyenv())){
    F

  } else {
    res <- Filter(function(x) x == name, ls(env))
    if (length(res) == 1){ # variable names are unique in an env
      T
    }
    else {
      if (inherits) my_exists(name, parent.env(env))
      else F
    }
  }
}
my_exists("x")
my_exists("x", e)

my_exists("x1")
my_exists("x2", e)

my_exists("x", inherits = F)
my_exists("x", e, F)

my_exists("x1", inherits = F)
my_exists("x2", e, F)
