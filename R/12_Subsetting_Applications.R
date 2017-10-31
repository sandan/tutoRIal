# Many of these basic techniques are wrapped up into more concise functions (e.g., subset(), merge(), plyr::arrange()),
# but it is useful to understand how they are implemented with basic subsetting.
# This will allow you to adapt to new situations that are not dealt with by existing functions.

# (1) Lookup tables (character subsetting)
x <- c('m', 'f', 'f', 'f', 'u', 'f')
lookup <- c(m = 'Male', f = 'Female', u = NA)  # replace m -> 'Male'
                                               #         f -> 'Female'
                                               #         u -> NA
y <- lookup[x]  # returns a named vector with names 'm', 'f', 'u'
#  and vals 'Male' for elements in x = 'm'
#      vals 'Female' for elements in x = 'f'
#      vals NA for elements in x = 'u'
is.atomic(y)
names(y)
unname(y)   # remove names from a vector/list
            # returns an atomic vec of y w/o the names
y           # unname doesn't modify the state

# we can map things to the same value
c(m = 'Known', f = 'Known', u = 'Unknown')[x]

# any extra names in the lookup that dont match in x are ignored
c(a = '?', m = 'Known', f = 'Known', u = 'Unknown')[x]

# any missing names in the lookup that match x are NA with names NA
w <- c(f = 'Known', u = 'Unknown')[x]
names(w)
is.atomic(w)


# Matching and merging by hand (integer subsetting)
# lookup tables can be more complicated with multiple columns

grades <- c(1, 2, 2, 3, 1)  # vec of int grades
info <- data.frame(
  grade = 3:1,     # 3 2 1
  desc = c("excellent", "good", "poor"),
  fail = c(F, F, T)
)

grades
id <- match(grades, info$grade)  # this will match entries in grades with entries in info$grade in order:
      # 1 -> 3
      # 2 -> 2
      # 3 -> 1
# essentially equivalent to
match(grades, 3:1)
help(match)
id
info
info[id, ]  # subset a data frame's rows according to id and all cols
            # note that duplicate row names are appended with a .n
            # the row names come from the original vec
            # id will pick the 3rd row, then 2nd, then 2nd, then 3rd, then 1st

# rownames and character subsetting
help(rownames)
rownames(info)   # 1 2 3
rownames(info) <- info$grade
rownames(info)   # 3 2 1
info[as.character(grades), ]

# If you have multiple columns to match on, you’ll need to first collapse them to a single column (with interaction(), paste(),
# or plyr::id()). You can also use merge() or plyr::join(), which do the same thing for you
# — read the source code to see how

# (2) Random Samples and bootstrap (integer subsetting)
# You can use integer indices to perform random sampling or bootstrapping of a vector or df
# sample() generates a vector of indices, then subsetting can access the values
df <- data.frame(x = rep(1:3, each = 2), y = 6:1, z = letters[1:6])
unlist(lapply(rep(1:3, each = 3), function(x){x + 0}))

df
help(rep)

# set seed for reproducibility
set.seed(10)
indices <- sample(nrow(df))
df[indices, ]

help(sample)
indices <- sample(nrow(df), 3)  # random sample of 3 numbers from 1:nrow(df)
length(indices) == 3
df[indices, ]

# Select 6 bootstrap replicates  (rep = T means sample with replacement)
indices <- sample(nrow(df), 6, rep = T)
indices
df[indices, ]

# 3) Ordering (integer subsetting)
help(order)
x <- c("b", "c", "a")
order(x)  # takes an input vector and returns an int vec describing how the subsetted vec should be ordered
          # 3 1 2  ... in other words ... 3 -> 1,  1 -> 2,  2 -> 3  (permutation cycle notation)
x[order(x)]

# you can break ties and change the ordering from asc to desc
# by default, missing values are put at the end of the vec
# you can remove them with na.last = NA or put them in front with na.last = FALSE

# Ordering rows and cols of an object
# Randomly reorder rows of a df, reverse cols
df2 <- df[sample(nrow(df)), 3:1]
df2

# sort x col vals in asc order
df2[order(df2$x), ]

# get the col names in alphabetical order
df2[, order(names(df2))]

# More concise, but less flexible, functions are available for sorting vectors, sort(), and data frames, plyr::arrange().

# 4) Expanding aggregated counts (integer subsetting)
# Sometimes you get a data frame where identical rows have been collapsed into one and a count column has been added.
# rep() and integer subsetting make it easy to uncollapse the data by subsetting with a repeated row index:

df <- data.frame(x = c(2, 4, 1), y = c(9, 11, 6), n = c(3, 5, 1))
df
uncollapse <- rep(1:nrow(df), df$n)  # n is the col count, for each row we want to duplicate it by n
df[uncollapse, ]

# 5) Removing columns from data frames (character subsetting)
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[c('x', 'y')] <- NULL
df

# or subset to return only rows you want
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[c("y", "z")]

# if you know which cols you dont want, use set ops
df[setdiff(names(df), "z")]
help(setdiff)
