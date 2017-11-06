f <- function(a) g(a)
g <- function(b) h(b)
h <- function(c) i(c)
i <- function(d) "a" + d
f(10)

help(recover)
help("dump.frames")
help(traceback)
help(where)
help(browser)

help(message)
help(warning)

# try(), tryCatch(), withCallingHandlers()
success <- try(1 + 1)
class(success)  # the class of the last statement in the code block
fail <- try("a" + "b")
class(fail)
