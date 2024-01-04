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
#desc() reorders a column in descending order
arrange(flights, desc(dep_delay))
#How could you use arrange() to sort all missing values to the start? (Hint: use is.na())
head(arrange(flights, desc(is.na(dep_delay))))
#Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)
#Which flights traveled the farthest? Which traveled the shortest?
arrange(flights, desc(distance))
arrange(flights, distance)

#5.4 Select columns with select()
select(flights, year, month, day)
#from
select(flights, year:day)
#except for
select(flights, -(year:day))
# select() with everything() moves variables to the start of the data
select(flights, time_hour, air_time, everything())
#What does the any_of() function do? Why might it be helpful in conjunction with this vector:
#vars <- c("year", "month", "day", "dep_delay", "arr_delay")
#the any_of() function selects variables contained in a variable vector; useful for when you want variable removed
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, any_of(vars))
#select variables that contain the word "time" and are case-sensitive 
select(flights, contains("TIME", ignore.case = FALSE))

#5.5 add new variables with mutate()
view(flights)
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flights_sml, gain = dep_delay - arr_delay, speed = distance / air_time * 60)
#you can refer to columns you just created
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)
#transmute() if you want to only keep new variables
#transmute(flights, gain = dep_delay - arr_delay,hours = air_time / 60, gain_per_hour = gain / hours)

#modular arithmetic helps break integers up into pieces (%/% integer division; %% remainder), e.g.,
#this breaks 517 in dep_time into hour and minute: 5 hour; 17 minute
transmute(flights, dep_time, hour = dep_time %/% 100, minute = dep_time %% 100)

#lead() refer to leading value; and lag() refer to lagging values
(x <- 1:10)
lag(x)
lead(x)

#Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers
#Convert them to a more convenient representation of number of minutes since midnight
flights <- mutate(flights, dep_time_mins = dep_time %/% 100 * 60 + dep_time %% 100, sched_dep_time_mins = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100)
#compare air_time to flight_time if flight_time is arr_time - dep_time
flights %>% mutate(flight_time = arr_time - dep_time) %>%
  select(air_time, flight_time)
#find the 10 most delayed flights
arrange(flights, desc(dep_delay))
arrange(flights, min_rank(desc(dep_delay)), 10)
?sin
#grouped summaries with summarise(); collapses a data frame into a single row
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
#1. group flights by destination
#delays <- flights %>% group_by(dest) %>% 
#2. summarize to compute distance, avg delay, and # of flights
#summarise(count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE))
#3. filter to remove noisy points and Honululu airport, which is almost twice as far away to next closest airport
#filter(count > 20, dest != HNL)
#altogether using piping
delays <- flights %>% group_by(dest) %>% summarise(count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)) %>% filter(count > 20, dest != "HNL")
#plot
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
#a good way to read %>% when reading code is "then"
#na.rm removes missing values prior to computation
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
#5.6.3 Counts whenever you do aggregatation, include count (n()) OR (sum(!is.na(x))) to make sure
#you're not drawing conclusions based on small amnt of data
#planes that have highest average delays (identified by tail number)
ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)
#can get more insight if we draw scatterplot of # of delays vs. avg delay:
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)
#often useful to filter out groups w/smallest # of observations
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

#look at how avg performance of batters in baseball is related to # of times they're at bat
#number of hits/number of attempts
batting <- as_tibble(Lahman::Batting)
view(batting)
batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)
#> 'geom_smooth() using method = 'gam' and formula = 'y ~ s (x, bs = "cs")'

#The root mean squared deviation, or standard deviation sd(x), is the standard measure of spread. 
#The interquartile range IQR(x) and median absolute deviation mad(x) are robust equivalents
#that may be more useful if you have outliers
# Why is distance to some destinations more variable than to others?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))
# When do the first and last flights leave each day?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time))



#6 Workflows: scripts
#Cmd/Ctrl + Shift + N opens up the script panel or New File --> R Script
#Ctrl + Shift + SL Instead of running expression-by-expression, you can also execute the complete script
