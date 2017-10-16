# There are four common types of atomic vectors: 
# logical
# integer
# double (often called numeric)
# character

# There are two other types: complex and raw

# You can instantiate an atomic vector with c(), short for combine
x1_double <- c(1, 2, 3)
x2_double <- c(1, 2.5, 3.14)

x1_int <- c(1L, 2L, 3L)

x1_logical <- c(T, TRUE, F, FALSE)
x2_logical <- c(T == TRUE, F == FALSE, length(x1_1ogical) == 4)

x1_char <- c("hello", "atmomic vectors!")

# Atomic vectors are always flat, even if you try to nest other atomic vectors
