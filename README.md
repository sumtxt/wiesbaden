The package 'wiesbaden' provides functions to directly retrieve data from the Federal Statistical Office of Germany (DESTATIS) in Wiesbaden, that is data from the [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online) and [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online). Access to [landesdatenbank.nrw.de](https://www.landesdatenbank.nrw.de) is also implemented. 

In principle any of the data can be downloaded through [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online), however the retrievable csv files come with multi-line headers that are difficult to process in R. 

The package uses the SOAP XML web service from DESTATIS. A very rough [documentation](https://www-genesis.destatis.de/genesis/online?Menu=Webservice) is available on the DESTATIS website.

The package's approach is heavily inspired by [ReGENESIS](https://github.com/pudo/regenesis) - an (unmaintained) Python library to bulk download all available data on the [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online). 

The package is powered by the amazing [httr](https://github.com/hadley/httr) and [xml2](https://github.com/hadley/xml2) package from [Hadley Wickham](http://hadley.nz/). 

# Setup 

Unfortunately, this package can only be used if the user registered at the respective database website and has a personal login name and password. The register forms are available on the respective websites, for example: [https://www.regionalstatistik.de/genesis/online?Menu=Registrierung](https://www.regionalstatistik.de/genesis/online?Menu=Registrierung). 


# Howto 

THE DESTATIS website allows users to retrieve tables which are grouped in "Statistiken" (statistics) and "Themen" (topics). The package does not retrieve the tables, but instead the underlying raw data which are used to construct the website's tables.

Lets assume we want to download the federal election results on the county level. From the website we see that they are contained in the series '14111'. 

Using the retrieve_datalist() function we download a dataframe of all data tables in this series: 

	library(dplyr)
	library(stringr)

	genesis_user <- c(user="ABCDEF", password="XXXXX", db="regio")

	d <- retrieve_datalist(tableseries="14111")

We then use the str_detect function to filter all data tables that contain the word "Kreise" (county)
in their name. 

	d %>% filter( str_detect(description, "Kreise") ) 

Having identified the data table we want to retrieve, we call the retrieve_data() function

	data <- retrieve_data(tablename="14111KJ002")

The meta data can be obtained via:

	metadata <- retrieve_metadata(tablename="14111KJ002")

