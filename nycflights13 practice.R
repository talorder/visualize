install.packages("tidyverse")
library(tidyverse)
arrange(flights, year, month, day)
library(nycflights13)
arrange(flights, year, month, day)
is.na()
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)
nov_dec <- filter(flights, month %in% c(11, 12))
nov_dec
filter <- nycflights13::flights
# Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)

#Flew to Houston (IAH or HOU)
filter(flights, dest %in% c('IAH', 'HOU'))

#Were operated by United, American, or Delta
filter(flights, carrier %in% c('DL', 'AM', "UN"))
ggplot(data = flights) +
  geom_point(mapping = aes(x = arr_time, y = month))

#Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))

#Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay > 120, dep_delay == 0)

#Departed between midnight and 6am inclusive
filter(flights, dep_time >= 0, dep_time <= 600)

#between() is a shortcut for  x >= left & x<= right; to simplify the last code:
filter(flights, between(dep_time, 0, 600))

#how many flights have missing departure time
filter(flights, is.na(dep_time))
#alternative way
sum(is.na(flights$dep_time))

#5.3 arrange rows with arrange()
#arrange() changes the order of rows
arrange(flights, year, month, day)
