# Environments power scoping, understanding them will help with lexical scoping (see 15_Functions_LexicalScoping)
library(pryr)
#Environment Basics
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

address(e)

# The objects on the right hand side don't live in the environment
# so you can multiple names can point to the same object
e$a <- e$d

# names can also point to different objects with the same values
e$d <- 4:11

# If an object has no names pointing to it, then the object gets GC'd

# Every env has a parent. When a variable name is sought, it will look at the current
# env and keeps looking up the hierarchy of parent envs
# until it can find the name.

# The empty environment is the only environment without a parent environment
# Every environment has the empty environment as an ancestor
# Given an environment, we can't access its child environment

# An environment is similar to a list except :
# 1) every name in a certain environment is unique
# 2) the names in an environment are not ordered
# 3) an environment has a parent
# 4) environments have reference semantics

help(parent.env)
help(parent.frame)  # gives you the calling environment (the environment calling the function)

# An environment is made up of 2 components:
# 1) Frame - contains the name-object bindings (behaves like a named list)
# 2) Parent Env

# There are 4 special environments:
# 1) globalenv() - the env in which you currently work
#                - the parent of this env is the last package attached with library() or require()
??globalenv
# 2) baseenv() - the base environment - the env of the base R package. Its parent is the empty env.
??baseenv
# 3) emptyenv() - the ultimate ancestor env, only one without a parent
??emptyenv
# 4) environment() - the current environment

# search() lists
help(search)
search() # lists all parents of the global env (the interactive workspace)
# the list is also called the search path because objects in these environments
# can be found from the top-level interactive workspace.
# It contains one environment for each attached package and any other objects that you’ve attach()ed.
# It also contains a special environment called Autoloads which is used to save memory by only loading
# package objects (like big datasets) when needed.

# you can access an environment with as.environment()
as.environment("package:RUnit")

# The beginning of an R environment looks like:
# emptyenv()
# baseenv()
# globalenv()  <--- you are here

# loading a package will insert it in between baseenv() and globalenv(), right above globalenv():
# emptyenv()
# baseenv()
# RUnit   <--- call library(RUnit) first
# pryr    <--- call library(pryr) second
# globalenv()

# to create a new env, use new.env()
# you can list the variable bindings in an environment with ls()
# you can find the parent environment with parent.env()

parent.env(e)  # # the default parent provided by new.env() is environment from
# which it is called - in this case that's the global environment.
ls(e)

# the easiest way to modify the bindings in the list is to use $
e$e <- 11
e$e

# by default ls() doesn't show bindings beginning with .:
e$.k <- 100
ls(e)
ls(e, all.names = T)  # use all.names to show them

# use ls.str() to show the objects that the names point too as well
ls.str(e)


# In general, given a name, you can extract the value using $, [[, or get/mget
# $ and [[ look only in one environment and return NULL if there is no binding associated with the name.
# get() uses the regular scoping rules and throws an error if the binding is not found.
help(get)

help(parent.env)
help("parent.frame")
