The package `wiesbaden` provides functions to directly retrieve data from the Federal Statistical Office of Germany (DESTATIS) in Wiesbaden, that is data from the databases [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online) and [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online). Access to [landesdatenbank.nrw.de](https://www.landesdatenbank.nrw.de) as well as [bildungsmonitoring.de](https://www.bildungsmonitoring.de/bildung/online/logon) is also implemented. 

In principle any of the data can be downloaded through the respective websites as a `csv` file, however the retrievable csv files come with multi-line headers that are difficult to process in R. While the package also helps with this task, its primary function is to provide users with the ability to retrieve the data from the website's underlying database (the GENESIS database). 

The package uses the SOAP XML web service from DESTATIS. A very rough [documentation](https://www-genesis.destatis.de/genesis/online?Menu=Webservice) is available on the DESTATIS website.

The package's approach is heavily inspired by [ReGENESIS](https://github.com/pudo/regenesis) - an (unmaintained) Python library to bulk download all available data on the [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online). 

The package is powered by the amazing [httr](https://github.com/hadley/httr) and [xml2](https://github.com/hadley/xml2) package from [Hadley Wickham](http://hadley.nz/). 

# Before Using 

Unfortunately, this package can only be used if the user registered at the respective website and has a personal login name and password. To access [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online) using this package one has to register as premium customer which costs 500 Euros annually (250 Euros for students). For the other database the registration is free, see for example: [https://www.regionalstatistik.de/genesis/online?Menu=Registrierung](https://www.regionalstatistik.de/genesis/online?Menu=Registrierung). 


# Directly Retrieve Data 

On all three supported websites, users can retrieve data tables that are grouped in "Statistiken" (statistics) and "Themen" (topics). The package does not retrieve the tables, but instead the underlying raw data which are used to construct the website's tables.

Lets assume we want to download the federal election results on the county level. From the website we see that they are contained in the series '14111'. 

Using the retrieve_datalist() function we download a dataframe of all data tables in this series: 

	library(dplyr)
	library(stringr)

	genesis <- c(user="ABCDEF", password="XXXXX", db="regio")

	d <- retrieve_datalist(tableseries="14111", genesis=genesis)

To retrieve a list of all available data use retrieve_datalist(tableseries="*", genesis=genesis). 

We then use the str_detect function to filter all data tables that contain the word "Kreise" (county)
in their name. 

	d %>% filter( str_detect(description, "Kreise") ) 

Having identified the data table we want to retrieve, we call the retrieve_data() function

	data <- retrieve_data(tablename="14111KJ002", genesis=genesis)

The meta data can be obtained via:

	metadata <- retrieve_metadata(tablename="14111KJ002", genesis=genesis)

# Read csv GENESIS Tables 

In conjuction with the `readr` package, the `wiesbaden` package also helps to import `csv` tables from all websites and construct valid column names. 

	require(readr)
	url <- 'https://www-genesis.destatis.de/genesis/online?sequenz=tabelleDownload&selectionname=12411-0004&format=csv'
	download.file(url, '12411-0004.csv')

	d <- read_header_genesis('12411-0004.csv', start=6, replacer=c("STAG"))
	data <- read_csv2('12411-0004.csv', skip=6, n_max=30-6+1, na="-")
	colnames(data) <- d

