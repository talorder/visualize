#Day 1: see dataset; plotting; adding color; 
#tidyverse is "a collection of open source packages for R" for 'tidy data'
install.packages("tidyverse")
#always have to run tidyverse package upon restarting
library(tidyverse)
#next lets upload the library ggplot2 -- a sample dataset in tidyverse
library(ggplot2)

#mtcars data frame -- "a data frame refers to a collection of variables (in the columns) and observations (in the rows)
mtcars
#our variables include, for instance, miles per gallon (mpg), cylinder (cyl), displacement (in cubic inches) (disp), weight (wt), am (transmission; auto or manual), etc. 
#we can see all of our variables in the chart by typing "mtcars"
#we also see a description of the dataset there

#let's start plotting
#to plot flights, this code will put arr_time on the x-axis and dep_time on the y-axis
ggplot(data = mpg) +
  geom_point(mapping = aes(x = manufacturer, y = displ))

ggplot(data = mtcars) +
  geom_point(mapping = aes(x = car, y = mpg))
mtcar     
mp

#mpg contains observations collected by the US Environmental Protection Agency on 38 models of car
#two ways to view the dataset
#full table
view(mpg)
#a "tibble" or the first 10 lines of the dataset
mpg
#let's start plotting; x will be displ (displacement) and y will be hwy (highway miles per gallon)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
#look at the dataset and choose two variables to plot using what we just learned
#what does the plot tell you?

#dictionary
#ggplot(): sets up the foundation of the graph; it helps define the data you want to use and the overall look of the graph. Once you've done this, you can add more details like different layers, while keeping the basic setup consistent unless you want to change something specifically.
#geom_point: creates scatterplots
#aes: aesthetic; a function to map variables in your dataset to the visual properties of a plot, e.g., color, size, shape, x and y axes, etc. It helps represent your data visually.

#adding color
#ggplot has built in colorschemes; let's make "class" a color
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
#this also creates a legend for us for "class" or car classification

#change size
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
#change shape
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#change size and color
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class, color = class))
#on your own, change size and shape
#look up in the book how to change the names of the x and y axes and legend
#change name of x and y-axes and legend where x = displ, y = highway, and color the plot by class
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) + labs(x = "Displacement", y = "Highway (miles per gallon)", color = "Class")
#add a title
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  labs (x = "Displacement", y = "Highway (miles/gallon)", color = "Class", title = "This is My Title")

