################
# Intro to ggplot
# eco-data-sci workshop
# 1/17/2018
################

# We'll be using data for National Parks visitation to practice basic data visualization using ggplot (from the National Park Service at <https://irma.nps.gov/Stats/SSRSReports>).

# Make sure to check out the Ocean Health Index Data Science Training book at <http://ohi-science.org/data-science-training/>, which includes more detail, examples and resources for using ggplot in Chapter 5. 

################
##What is ggplot? 

# ggplot2 is a graphics package specifically built to help you iteratively create customized graphs. It exists solo, or within the *tidyverse* - a collection of data wrangling, visualizing, and presenting packages that play nicely together. 
################

################
##1. Load tidyverse (install if necessary)
################

# If you do NOT have the tidyverse installed, you may need to install it first using **install.packages("tidyverse")**. When you install a package, then it exists in R's brain but is dormant.

# install.packages("tidyverse")

# Then load it to "activate" in R's brain

library(tidyverse)

################
##2. Get the data (np_visit.csv)
################

np_visit <- read_csv("~/github/data-vis/np_visit.csv")

################
##3. Single series scatterplot (Dinosaur National Monument visitors)
################

# First, we'll explore visitation at Dinosaur National Monument.

# Let's make a subset of our data that only contains information for Dinosaur (I'll call my subset dino_nm). We'll use this subset to create our graph. 

dino_nm <- np_visit %>% 
  filter(park_name == "Dinosaur National Monument")

# Take a look at that data frame (View() or just click on the blue circle with arrow next to it in the Environment tab). We'll make a scatterplot of year (x-axis) versus visitors (y-axis).

# How do we make that graph in ggplot?

# To make the most basic graph, you need to tell R three things:

# 1. You're using ggplot
# 2. What data is used to create the graph 
# 3. What type of graph you want to create

# ...everything beyond that is optional customization.

# So code to make the most basic scatterplot for Dinosaur NM might look something like this: 
  
ggplot(data = dino_nm, aes(x = year, y = visitors)) +
  geom_point(color = "blue", pch = 2, size = 3)

# Note that we used the aes() - aesthetics - argument here. Whenever you are referencing a variable in ggplot code, it needs to be within an aes() argument. 

# You'd want to customize that graph - we'll get back to customization later on. For now, focus on the structure of the ggplot code. 

# What if we have more than one series we're trying to plot?


################
##4. Multi-series graph of California National Parks visitation
################

# Make a new subset (I'll store as data frame 'np_ca') that only includes annual visitors in California National Parks, and arrange by park name (alphabetical) then year (increasing). *Note: data wrangling using dplyr and tidyr will be covered in another eco-data-sci workshop.*

np_ca <- np_visit %>% # introduce pipe operator?
  filter(state == "CA" & type == "National Park") %>% 
  arrange(park_name, year)

# Go exploring a little bit. How many parks are there in California, and what are they? 

summary(np_ca) # Useful to see the class of each variable (column)

unique(np_ca$park_name) # If a factor, can use 'levels' - but this is just a character

length(unique(np_ca$park_name)) # To see how many there are

# Now let's make a scatterplot graph (year v. visitors for the 9 California NPs):

ggplot(data = np_ca, aes(x = year, y = visitors)) + # There are (1) and (2)
  geom_point() # This is (3) - what type of graph do you want to create?

# Now you have made a totally hideous and useless graph - but it DOES contain all of the correct data. We just need to figure out how to clean it up a little bit to make it useful.

# How do we do that?

#################
##5. Updating graph characteristics by VARIABLE
#################

# We would like for each CA National Park series to be shown in a different color. We can do that by updating within the geom_point() layer (that's the layer where the points are added...). Since we're referencing a variable (park_name), we'll need to use the aes() argument. Anything that is not variable specified can be added outside of an aes() argument. 

ggplot(data = np_ca, aes(x = year, y = visitors)) + 
  geom_point(aes(color = park_name))

##################
##6. Customization - updating labels and titles
##################

# We customize graphs in ggplot *iteratively* by adding layers (using the plus sign '+') to a base graphic and/or adding arguments within layers.

# Use xlab() and ylab() layers to update x- and y-axis labels, and ggtitle() to add a graph title

# graph + 
# xlab("This is my x-label") +
#  ylab("This is my y-label") +
#  ggtitle("This is my graph title")

ggplot(data = np_ca, aes(x = year, y = visitors)) +
  geom_point(aes(color = park_name)) + 
  xlab("Year") +
  ylab("Annual Visitors") +
  ggtitle("California National Parks Visitation")#  +
  # theme(legend.title=element_blank()) # This is just if you want to remove the legend title

##################
##7. ggplot themes
##################

# One way to make major changes to the overall aesthetic of your graph is using *themes* (that may exist in ggplot, or in other packages that you can load and install like 'ggthemes')

# Some examples to try:
  
#  - theme_bw()
# - theme_minimal()
# - theme_classic()

# Using themes doesn't finalize your graph, but it can give you a better "starting point" for customization.

ggplot(data = np_ca, aes(x = year, y = visitors)) +
  geom_point(aes(color = park_name)) + 
  xlab("Year") +
  ylab("Annual Visitors") +
  ggtitle("California National Parks Visitation") +
  theme_classic()  # +
  #theme(legend.title=element_blank()) # Again, just to remove the legend title (optional)


###################
##8. ggplot geoms (types of graphics)
###################

# We just made a few scatterplot graphs. But what if we wanted to make a line graph? Then do we have to start over? No...as long as the *type* of data is compatible with the new geom that you choose, then all you'd have to change is that layer. 

# Notice all of the types of geoms that exist when you start typing it in. And there are even other packages with **more** geom types that you can get. 

ggplot(data = np_ca, aes(x = year, y = visitors)) +
  geom_line(aes(color = park_name)) + 
  xlab("Year") +
  ylab("Annual Visitors") +
  ggtitle("California National Parks Visitation") +
  theme_classic() +
  theme(legend.title=element_blank())


# Keep in mind that the type of graph you're trying to create needs to be compatible with the data you're telling it to use. 

# For example, if I want to make a histogram of visitation, then I couldn't give it both an x- and y- quantitative variable (since the y-axis on a histogram is always just the frequency of events within a bin). So a histogram only asks for one variable. A boxplot typically has one categorical variable and one quantitative variable. For example: 


ggplot(data = np_ca, aes(x = park_name, y = visitors)) +
  geom_boxplot(aes(fill = park_name)) # And you'd obviously want to customize (e.g. x-axis labels)

ggplot(data = np_ca, aes(x = park_name, y = visitors)) +
  geom_jitter(aes(color = park_name), width = 0.1, alpha = 0.4) +
  coord_flip() # Flips x- and y-variable visually

# ...and then you can continue to customize.

# Example customization: 

ggplot(data = np_ca, aes(x = park_name, y = visitors)) +
  geom_jitter(aes(color = park_name), 
              width = 0.1, 
              alpha = 0.4) +
  theme_bw() +
  ylab("Annual Visitors") +
  xlab("") +
  ggtitle("California NP Annual Visitors (1904 - 2016)") +
  coord_flip() +
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 45, hjust = 1))

# You can also *combine* different types of compatible graphs. For example, you can create a graph with lines and points by using both geom_line and geom_point. 

# Using the Dinosaur National Monument subset we created (dino_nm):

ggplot(data = dino_nm, aes(x = year, y = visitors)) +
  geom_point() +
  geom_line() +
  geom_smooth() # Use 'span' argument to update "wiggliness" in loess smoothing


####################
##9. faceting
####################

# Considering our CA National Parks Visitation, what if we wanted each National Park to exist in its own graphics space? Would we need to create a new graph for each? No - we can use facet_wrap to split up the graph by a variable that we pick (here, park_name). 

ggplot(data = np_ca, aes(x = year, y = visitors)) + 
  geom_point() + 
  xlab("Year") +
  ylab("Annual Visitors") +
  theme_bw() +
  ggtitle("California National Parks Visitation") +
  facet_wrap(~park_name)

####################
##10. Bar plots
####################

# First, let's make a subset only of data for visitor counts from 2016 for all of the National Parks and National Monuments in the original np_visit dataset. I'll call my subset 'visit_16'.

visit_16 <- np_visit %>% 
  filter(year == 2016) %>% 
  filter(type == "National Park" | 
           type == "National Monument")

# So we have 134 parks that are designated as either National Parks or National Monuments.

# We can use geom_bar() in ggplot to *count* and display (as a bar) the number of times a certain outcome or character string appears in a column. 

# Here, we'll create a bar graph showing how many NPs and NMs had recorded visitors in 2016. Note that you do NOT give it the counts - that's what geom_bar does for us.

ggplot(visit_16, aes(x = type)) +
  geom_bar()

# What if we would like to know where (in what region) each of these exist? We can use the fill() argument to create a stacked bar graph, where the different colors indicate counts within each region.

ggplot(visit_16, aes(x = type)) +
  geom_bar(aes(fill = region)) +
  theme_bw()

# Just a couple more things. The graph we just made shows the actual counts as a stacked bar graph. We might just be interested in the *proportions* of each monument type that exist in each region, or we might like an "unstacked" version. 

# Use the position argument to adjust geom_bar appearance. Set to "fill" if you want proportions shown (so all bars will be from 0 to 1), and "dodge" to have bars appear side-by-side for each group.

# *Note that updating the position doesn't automatically correct the y-axis label, as you'll see below.*
  
#   Using position = "fill":

ggplot(visit_16, aes(x = type)) +
  geom_bar(aes(fill = region), position = "fill") +
  theme_bw() +
  ylab("Proportion")

# Using position = "dodge": 

ggplot(visit_16, aes(x = type)) +
  geom_bar(aes(fill = region), position = "dodge") +
  theme_bw()

###################
##11. Exporting your gg-graphs
###################

# To export a hi-res version of your beautiful graph, make sure that you store your graph (assign it a name...we haven't been doing that so far).
                                                                                         
# I'll copy and paste the code for the bar graph I made above, and store it as 'park_graph'.

park_graph <- ggplot(visit_16, aes(x = type)) +
  geom_bar(aes(fill = region), position = "dodge") +
  theme_bw()

# Then use ggsave() to export, including the size (width = , height = ) and resolution (dpi = ) as desired.

ggsave("my_park_graph.png", park_graph, width = 5, height = 5, dpi = 300)
