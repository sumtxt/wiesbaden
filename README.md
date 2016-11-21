The package 'wiesbaden' provides functions to directly retrieve data from the Federal Statistical Office of Germany (DESTATIS) in Wiesbaden. 

For now, it only works with the [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online) Website. Support for [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online) will soon be implemented. 

In principles any of the data can be downloaded through the website, however the retrievable csv files come with multi-line headers that are difficult to process in R. 

The package uses the SOAP XML web service from DESTATIS. A rough documentation is available on their website [here](https://www-genesis.destatis.de/genesis/online?Menu=Webservice). 

The package's approach is heavily inspired by [ReGENESIS](https://github.com/pudo/regenesis) - an (unmaintained) Python library to bulk download all available data on the [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online). 

The package is powered by the amazing [httr](https://github.com/hadley/httr) and [xml2](https://github.com/hadley/xml2) by [Hadley Wickham](http://hadley.nz/). 

# Setup 

Unfortunatly, this package can only be used if the user registered on [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online) and has a personal login name and password. Register here: [https://www.regionalstatistik.de/genesis/online?Menu=Registrierung](https://www.regionalstatistik.de/genesis/online?Menu=Registrierung). 


# Howto 

THE DESTATIS website allows users to retrieve tables which are group in "Statistiken" (statistics) and "Themen" (topics). The  package does not retrieve the tables, but instead the underlying raw data which are used to construct the website's tables.

Lets assume we want to download the federal election results on the county level. From the website we see that they are contained in the series '14111'. 

Using the retrieve_datalist() function we download a dataframe of all data cubes in this series: 

	d <- retrieve_datalist(tableseries="14111")

We then use the str_detect function to filter all data cubes that contain the word "Kreise" (county)
in their name. 

	d %>% filter( str_detect(tablename, "Kreise") ) 

The same result can be achieved when filter the codes based on the fifth letter. All data cubes on the municipality 
level contain the letter "K". 

Having identified the data cube we want to retrieve, we call the retrieve_data() function

	data <- retrieve_data(tablename="14111KJ002")

The meta data can be obtained via:

	data <- retrieve_metadata(tablename="14111KJ002")

