# Part 2 of Subsetting

# Missing and out of bounds Indices
# [ and [[ differ slightly in behavior when the index is out of bounds (OOB)

# VECTOR
x <- 1:4
x[5]             # NA
str(x[5])        # int NA

x[NA_real_]      # when the index becomes NA
str(x[NA_real_]) # int NA

x[NULL]          # when the index becomes NULL
str(x[NULL])     # int(0)

# LIST
x <- list(1:4)
x[5]
str(x[5])    # list of 1, NULL
x[[5]]       # error

# Operator    	Index	       Atomic    	List
#   [          	 OOB	        NA	    list(NULL)
#   [	           NA_real_	    NA	    list(NULL)
#   [            NULL        	x[0]   	list(NULL)
#   [[        	 OOB         	Error   Error
#   [[	         NA_real_	    Error	  NULL
#   [[	         NULL       	Error  	Error

#If the input vector is named, then the names of OOB, missing, or NULL components will be "<NA>".

mod <- lm(mpg ~ wt, data = mtcars)
plot(mod)
mod$residuals
l <- summary(mod)
l$r.squared
l$adj.r.squared

# Subsetting and Assignment
# All subsetting ops can be combined with assignment to modify selected values of the input vector
x <- 1:5
x[c(1, 2)] <- 2:3
x

# len of the LHS must match len of RHS
x[-1] <- 4:1
x

# duplicate indices are allowed
x[c(1, 1)] <- 3:4
x   # the last number wins when it comes to the same index

# can't combine integer indices with NA
x[c(1, NA)] <- c(1, 2)
x

# But you can combine NA's with T/F vectors where NA = F (for assignment)
# the boolean selectors recycle
x
x[c(T, NA)]   # NA as an index treats the value at NA (with recycling) as NA
x[c(T, NA)] <- 1
x

df <- data.frame(a = c(1, 10, NA))
colnames(df)
df$a[df$a < 5]  # get the column named 'a' from df where vals in 'a' < 5
df$a[df$a < 5] <- 0   # oesn't affect NA in the col
df

# empty subsetting and assigning can preserve the data structure

is.data.frame(mtcars)

# data frame  (preserve mtcars as dataframe) note that mtcars must already exist before you can subset it with [
mtcars[] <- lapply(mtcars, as.integer)
mtcars

# named list (simplify to list)
mtcars <- lapply(mtcars, as.integer)
mtcars

# LISTS and NULL subsetting
x <- list(a = 1, b = 2)
x[["b"]]
x[["b"]] <- NULL # remove named value 'b'
length(x)
x

x <- list(a = 1)
x["b"] <- list(NULL)  # note the list around the NULL
str(x)
x
