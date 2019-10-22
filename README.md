# Data-Visualization-Challenge
The Data Visualization Challenge shows the variation of CO2 emission from Electricity (kt) to Power Consumption (TWh) for the year 2014  for different countries spanning across all continents

Electricity Power Consumption (kWh per capital) was gotten from World Bank Databank. http://api.worldbank.org/v2/en/indicator/EG.USE.ELEC.KH.PC?downloadformat=csv
The data was tidied and filtered for year 2014.

Population of the People (nos) was gotten from World Bank Databank. http://api.worldbank.org/v2/en/indicator/SP.POP.TOTL?downloadformat=csv
The data was tidied and filtered for year 2014.

To obtain the Total Power Consumption TWh, the Electricity Power Consumption was multiplied with the Population for individual countries

The geo_data indicating country regions was gotten from World Bank Databank.

The total power consumption kWh was joined to the geo_data by common variable (country) to obtain the regions per country

The total CO2 Emission from electricity generation and heating (-a percentage of total fuel combustion) per country was gotten from World bank databank. http://api.worldbank.org/v2/en/indicator/EN.CO2.ETOT.ZS?downloadformat=csv. 
The data was filtered for year 2014

The total CO2 Emissions (kt) per country was gotten from World Bank Databank. 
http://api.worldbank.org/v2/en/indicator/EN.CO2.ETOT.ZS?downloadformat=csv
The data was filtered for year 2014

To get the CO2 Emission (kt) gotten directly from electricity generation, the percentage CO2 Emitted by Electricity and heating was multiplied by the total CO2 Emission

A new factor, r is introduced which is the ratio of CO2 emission from electricity and heating(kt) to the Electricity Power Consumption(TWh).
This factor was used as a basis for estimating how countries generate clean energy for electricity consumption.
The values obtained from r has a wide variation as a result of the mix between extremely different economies i.e low income countries and high income countries. As such, a logorithm to base 10 was used to scale the r-variables.


Furthermore, over 140 countries was analyzed. As such, to maximize the use of space, a circular bar graph was used for data visualization.
Grouping each data sets according to regions, and subsequently according to countries.

From the graph it can be deduced: 
1. In Africa, Ethiopia has the lowest r-value (1.87kt/TWh) and Libya has the highest r value (2,631.37kt/TWh). 
2. In America, Costa Rica has the lowest r-value (89.46kt/TWh) and Curacao has the highest r value (5,165kt/TWh). 
3. In Asia, Tajikstan has the lowest r-value (18kt/TWh) and Iraq has the highest r value (2,397.02kt/TWh). 
4. In Europe, Albania has the lowest r-value (24.96kt/TWh) and Estonia has the highest r value (1,722.17kt/TWh). 
5. In Oceania, New Zealand has the lowest r-value (201.99kt/TWh) and Estonia has the highest r value (891.89kt/TWh).  
