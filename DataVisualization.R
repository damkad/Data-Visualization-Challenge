#load electricity_consumption_graph
e_consumption <- read.csv("electric_power_consumption.csv", stringsAsFactors = F)
View((e_consumption))
#clean data, convert wide to long
e_consumption <- gather(e_consumption, key = Year, value = `Power consumption`, 5:13)
#view names of columns
names(e_consumption)
#remove only wanted columns
e_consumption <- select(e_consumption, Country.Name, Year, `Power consumption` )
#rename columns
e_consumption <- rename(e_consumption, Country = Country.Name)
#edit all values in column-Year
e_consumption$Year <- gsub( "^(.*)19", "19", e_consumption$Year)
e_consumption$Year <- gsub( "^(.*)20", "20", e_consumption$Year)
e_consumption$Year <- as.numeric(e_consumption$Year)
e_consumption$`Power consumption` <- as.numeric(e_consumption$`Power consumption`)
#remove rows with NA
e_consumption <- drop_na(e_consumption)

#filter cleaned_e_consumption for values equals 2014
filtered_e_consumption <- filter(e_consumption, Year == "2014")
#load the data set that groups countries by region


#filtered_e_consumption <-group_by(filtered_e_consumption,`Power consumption`)
View(head(filtered_e_consumption))
#save filtered data 
#filtered_e_consumption <- write.csv(filtered_e_consumption, "filtered_e2014_consumption.csv")



#this to get population per country
population_data<- read.csv("API_SP.POP.TOTL_DS2_en_csv_v2_315873.csv", stringsAsFactors = F)
colnames(population_data)

population_data <- gather(population_data, key = year, value = population, -c(1:4))
View(head(population_data))
#remove characters from year variable
population_data$year <- str_replace_all(population_data$year, "X", "")
#take away unwanted columns
population_data <- population_data[-c(2:4)]
population_data <- filter(population_data, year == 2014)

elect_cons <- read.csv("filtered_e2014_consumption.csv", stringsAsFactors = F)

colnames(elect_cons)
join_data_1 <- right_join(population_data, elect_cons, c("Country.Name"="Country"))
View(join_data_1)

#check for missing items
index <- which(is.na(join_data_1$population))
View(join_data_1[index,])
#corresponding index name in population data
join_data_2 <- left_join(population_data, elect_cons, c("Country.Name"="Country"))
View(join_data_2)
#country missing in elect_cons data set. As such, we can safely remove row
join_data_1 <- drop_na(join_data_1, population)


join_data_1 <- mutate(join_data_1, "Total Power Consumption"= (Power.consumption * population))

colnames(join_data_1)

join_data_1 <- select(join_data_1, Country.Name, Power.consumption, `Total Power Consumption`) 

#get the region data
geo_data <- read.csv("geo_data.csv", stringsAsFactors = F)
View(head(geo_data))
#view names of variables
names(geo_data)
#select name, country, region, subregion
geo_data <- select(geo_data, name, region, sub.region)
View(geo_data)
#join e_consumption and geo_data by country
e_con_geo <- left_join(join_data_1, geo_data, by = c("Country.Name"="name"))
View(e_con_geo)
#check for missing values, get index for left_join
missing_e_con_geo <- e_con_geo$Country.Name[which(is.na(e_con_geo$region))]
View(missing_e_con_geo)
#join e_consumption and geo_data by name
e_geo_con <- right_join(join_data_1, geo_data, by = c("Country.Name"="name"))
View(e_geo_con)
#check for missing values, get index for right_join
missing_e_geo_con <- e_geo_con$Country.Name[which(is.na(e_geo_con$`Power.consumption`))]
View(missing_e_geo_con)
#comparing the missing values, replace where necessary
join_data_1$Country.Name <- str_replace_all(join_data_1$Country.Name,c("Bolivia"="Bolivia (Plurinational State of)", "Congo, Dem. Rep."="Congo (Democratic Republic of the)", "Congo, Rep."="Congo", "Egypt, Arab Rep."= "Egypt", "Hong Kong SAR, China"="Hong Kong", "Korea, Rep."="Korea (Republic of)", "Korea, Dem. People's Rep."="Korea (Democratic People's Republic of)", "Kyrgyz Republic"="Kyrgyzstan",  "Iran"="Iran (Islamic Republic of)", "Moldova"="Moldova (Republic of)", "North Macedonia"="Macedonia (the former Yugoslav Republic of)", "Slovak Republic"="Slovakia" , "Venezuela, RB"="Venezuela (Bolivarian Republic of)", "Yemen, Rep."="Yemen" ))
geo_data$name <- str_replace_all(geo_data$name,c("Côte d'Ivoire"="Cote d'Ivoire", "Curaçao"="Curacao", "Czechia"="Czech Republic", "Tanzania, United Republic of"="Tanzania", "United Kingdom of Great Britain and Northern Ireland"="United Kingdom", "United States of America"="United States", "Viet Nam"="Vietnam"))
#iran giving issues, single handedly replace iran
join_data_1$Country.Name <- str_replace_all(join_data_1$Country.Name, c("^Iran(.*).*"="Iran (Islamic Republic of)", "^Bolivia(.*)."="Bolivia (Plurinational State of)", "^Moldova(.*)."="Moldova (Republic of)"))

#repeat joining process and check for missing values
#join e_consumption and geo_data by country
e_con_geo <- left_join(join_data_1, geo_data, by = c("Country.Name"="name"))
View(e_con_geo)
#check for missing values, get index for left_join
missing_e_con_geo <- e_con_geo$Country.Name[which(is.na(e_con_geo$region))]
View(missing_e_con_geo)

#write.csv(e_con_geo, "abc.csv")

#get  percentage of co2 emitted from the combustion of fuel for electricity use 
p_co2 <- read.csv("API_EN.CO2.ETOT.ZS_DS2_en_csv_v2_325186.csv", stringsAsFactors = F)
colnames(p_co2)

p_co2 <- gather(p_co2, key = Year, value = co2, -c(1:4))

p_co2$Year <- gsub("X", "", p_co2$Year)

#filter for year 2014
p_co2_14 <- filter(p_co2, Year == 2014)
p_co2_14 <- drop_na(p_co2_14, co2)
p_co2_14 <- select(p_co2_14, -c(2:4))

#get the total co2 emission 
total_co2 <- read.csv("API_EN.ATM.CO2E.KT_DS2_en_csv_v2_315941.csv", stringsAsFactors = F)
colnames(total_co2)
total_co2 <- gather(total_co2, key= Year, value = total_co2, -c(1:4))
#clean the year variable
total_co2$Year <- gsub("X", "", total_co2$Year)
total_co2 <- select(total_co2, -c(2:4))
#filter for Year 2014
total_co2_14 <- filter(total_co2, Year == 2014)
#remove columns with NA
total_co2_14 <- drop_na(total_co2_14, total_co2)

#join p_co2_14 with total_co2_14
join_p_t <- left_join(p_co2_14, total_co2_14, c("Country.Name"="Country.Name"))
mission_join_p_t <- join_p_t$Country.Name[which(is.na(join_p_t$co2))]
colnames(join_p_t)
#rename columns
colnames(join_p_t) <- c("Country", "Year", "co2", "Year2", "total_co2")
#take out col 2:3
join_p_t <- select(join_p_t, -4)
#add a col to show co2 generated from electricity generated
join_p_t <- mutate(join_p_t, "co2_elect"=round((co2/100)*total_co2, 2))

#write.csv(join_p_t, "co2_elect.csv")

#combine  electricity+geo_data with co2 data

#join data using elect_cons as base

elect_co2 <- left_join(e_con_geo, join_p_t, c("Country.Name"="Country"))
#check for na
missing_elect_co2 <- elect_co2$Country.Name[which(is.na(elect_co2$co2))]
View(missing_elect_co2)
#join data using co2 as base
co2_elect <- right_join(e_con_geo, join_p_t, c("Country.Name"="Country"))
#check for na
missing_co2_elect <- co2_elect$Country.Name[which(is.na(co2_elect$Power.consumption))]
View(missing_co2_elect)

#change missing names
e_con_geo$Country.Name <- str_replace_all(e_con_geo$Country.Name, c("^Bolivia(.*).*"= "Bolivia", "^Congo.*[the].*"="Congo, Dem. Rep.", "^Iran(.*).*"= "Iran", "^Moldova(.*).*"= "Moldova", "^Korea(.*).*"= "Korea, Rep.", "^Venezuela(.*).*"= "Venezuela", "^Macedonia(.*).*"= "Macedonia"))
#change missing names
join_p_t$Country <- str_replace_all(join_p_t$Country, c("Congo, Rep."="Congo", "Egypt, Arab Rep."="Egypt", "^Iran(.*).*"= "Iran", "^Hong Kong(.*).*"= "Hong Kong", "Kyrgyz Republic"="Kyrgyzstan", "Slovak Republic"="Slovakia", "Yemen, Rep."="Yemen", "Venezuela, RB"="Venezuela", "North Macedonia"="Macedonia"))
#repeat joining process
elect_co2 <- left_join(e_con_geo, join_p_t, c("Country.Name"="Country"))
#check for na
missing_elect_co2 <- elect_co2$Country.Name[which(is.na(elect_co2$co2))]
View(missing_elect_co2)

colnames(elect_co2)
data_main <- select(elect_co2, Country.Name, `Total Power Consumption`, co2_elect, region)

#rename columns
data_main <- rename(data_main, country  = Country.Name, total_elect_cons = `Total Power Consumption` ) 
data_main <- drop_na(data_main, co2_elect)
data_main <- drop_na(data_main, region)
#replace countries with long names to short names
data_main$country <- str_replace_all(data_main$country, c("Bosnia and Herzegovina"="Bosnia & Herzegov")) 
#save filtered dataset
#write.csv(elect_co2_tidy, "completed_elect_co2_data.csv")


# library
library(tidyverse)
library(viridis)

colnames(data_main)
#look out for where value is zero, and take out
index_ <- which(data_main$co2_elect== 0)
data_main <- data_main[-index_,]
#take out 1st and second column
#data <- select(data_main, -c(1:2))
#for another joining another data

a <- min(data_main$co2_elect)
b <- min(data_main$total_elect_cons)
#scale total_elect_cons by 10^8
data_main$total_elect_cons <- data_main$total_elect_cons/10^9
#create a new comparative ratio
data_main <- mutate(data_main, "r co2_elect/total_elect_cons (kt/TWh)"= co2_elect/total_elect_cons)

#x <- ggplot(data_main)+geom_bar(stat="identity", aes(x=country, y=log10(ratio)))



# Set a number of 'empty bar' to add at the end of each group
empty_bar <- 2
nObsType <- 1
to_add <- data.frame( matrix(NA, empty_bar*nlevels(as.factor(data_main$region))*nObsType, ncol(data_main)) )
colnames(to_add) <- colnames(data_main)
to_add$region <- rep(levels(as.factor(data_main$region)), each=empty_bar*nObsType )
data_main <- rbind(data_main, to_add)
data_main <- data_main %>% arrange(region, country)
data_main$id <- rep( seq(1, nrow(data_main)/nObsType) , each=nObsType)


# Get the name and the y position of each label
label_data <- data_main %>% group_by(id, country) %>% summarize(tot=log10(`r co2_elect/total_elect_cons (kt/TWh)`))
#join, add the values of total_co2 and electricity consumption into country name
label_data <- left_join(label_data, data_main, c("country"="country", "id"="id"))
#label_data <- rename(label_data, id = id.x)
label_data$countryname <- paste(label_data$country, round(label_data$`r co2_elect/total_elect_cons (kt/TWh)`, 2),sep = ", ")


number_of_bar <- nrow(label_data)
angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
label_data$hjust <- ifelse( angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)

# prepare a data frame for base lines
base_data <- data_main %>% 
  group_by(region) %>% 
  summarize(start=min(id), end=max(id) - empty_bar) %>% 
  rowwise() %>% 
  mutate(title=mean(c(start, end)))

# prepare a data frame for grid (scales)
grid_data <- base_data
grid_data$end <- grid_data$end[ c( nrow(grid_data), 1:nrow(grid_data)-1)] + 1
grid_data$start <- grid_data$start - 1
grid_data <- grid_data[-1,]

#visualize using bar graph
#ggplot(data_main) + geom_bar(aes(x=as.factor(id), y=log10(`r co2_elect/total_elect_cons (kt/TWh)`), fill=`r co2_elect/total_elect_cons (kt/TWh)`), stat="identity", alpha=0.5) 



# Make the plot
p <- ggplot(data_main) +      
  
  # Add the stacked bar
  geom_bar(aes(x=as.factor(id), y=log10(`r co2_elect/total_elect_cons (kt/TWh)`), fill=`r co2_elect/total_elect_cons (kt/TWh)`), stat="identity", alpha=0.5) +
  scale_fill_viridis() +
  
  # Add a val=100/75/50/25 lines. I do it at the beginning to make sur barplots are OVER it.
  geom_segment(data=grid_data, aes(x = end, y = 0, xend = start, yend = 0), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 1, xend = start, yend = 1), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 2, xend = start, yend = 2), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 3, xend = start, yend = 3), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 4, xend = start, yend = 4), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  
  # Add text showing the value of each 20/15/10/5 lines
  ggplot2::annotate("text", x = rep(max(data_main$id),5), y = c(0, 1, 2, 3, 4), label = c("0", "10", "100", "1000kt/TWh", "10000") , color="grey", size=1 , angle=0, fontface="bold", hjust=1) +
  
  ylim(-0.5,max(label_data$tot, na.rm=T)) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(color = "black", size = 6),
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-1,4), "cm") 
  ) +
  coord_polar() +
  
  # Add labels on top of each bar
  geom_text(data=label_data, aes(x=id, y=tot, label=countryname, hjust=hjust), color="black", fontface="bold",alpha=0.8, size=2, angle= label_data$angle, inherit.aes = FALSE ) +
  
  # Add base line information
  geom_segment(data=base_data, aes(x = start, y = 0, xend = end, yend = 0), colour = "grey", alpha=0.8, size=0.6 , inherit.aes = FALSE )  +
  geom_text(data=base_data, aes(x = title, y = -0.1, label=region), hjust=c(0,0,0,1,1), colour = "black", alpha=0.8, size=1, fontface="bold", inherit.aes = FALSE)

p
# Save at png
ggsave(p, file="output.png", width=10, height=10)

rm(list = ls())
?geom_text
