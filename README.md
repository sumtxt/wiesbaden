The package `wiesbaden` provides `R` functions to directly retrieve data from the the databases [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online) and [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online) maintained by the Federal Statistical Office of Germany (DESTATIS) in Wiesbaden. Access to [landesdatenbank.nrw.de](https://www.landesdatenbank.nrw.de) as well as [bildungsmonitoring.de](https://www.bildungsmonitoring.de/bildung/online/logon) is also implemented. 

This package can only be used after a registration on the respective website to obtain a personal login name and password. The registration is free for all databases except [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online). 

Data from these database can also be retrieved via the webinterface, however the retrievable `csv` files come with multi-line headers that are difficult to process in R. While the package also helps with this task, its primary function is to provide users with the ability to retrieve the data from the website's underlying GENESIS database. 

The package uses the SOAP XML web service from DESTATIS. A very rough [documentation](https://www-genesis.destatis.de/genesis/online?Menu=Webservice) is available on the DESTATIS website.

The package's approach is heavily inspired by [ReGENESIS](https://github.com/pudo/regenesis) - an (unmaintained) Python library to bulk download all available data on [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online). 



# Retrieve Data from the Database 

Users can retrieve data tables that are grouped in "Statistiken" (statistics) and "Themen" (topics). The package does not retrieve the tables, but instead the underlying raw data which are used to construct the website's tables.

Lets assume we want to download the federal election results on the county level. From the website we see that they are contained in the series '14111'. 

Using the retrieve_datalist() function we download a dataframe of all data tables in this series: 

	library(dplyr)
	library(stringr)

	genesis <- c(user="ABCDEF", password="XXXXX", db="regio") 

The genesis function allows currently to access four databases: 
- `db="regio"` for data from [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online),    
- `db="nrw"` for data from [landesdatenbank.nrw.de](https://www.landesdatenbank.nrw.de),
- `db="bm"` for data from [bildungsmonitoring.de](https://www.bildungsmonitoring.de/bildung/online/logon), 
- `db="de"` for data from [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online) 

To retrieve a list of all available data use `retrieve_datalist(tableseries="*", genesis=genesis)`: 

	d <- retrieve_datalist(tableseries="14111", genesis=genesis) 

We then use the str_detect function to filter all data tables that contain the word "Kreise" (county)
in their name. 

	d %>% filter( str_detect(description, "Kreise") ) 

Having identified the data table we want to retrieve, we call the retrieve_data() function

	data <- retrieve_data(tablename="14111KJ002", genesis=genesis)

The meta data can be obtained via:

	metadata <- retrieve_metadata(tablename="14111KJ002", genesis=genesis)

# 

# Read DESTATIS files 

The `wiesbaden` package also helps to import `csv` tables exported from the GENESIS via their web interfaces and construct valid column names. 

	require(readr)
	url <- genesis_url(tablename="12411-0004.csv")
	download.file(url, '12411-0004.csv')

	d <- read_header_genesis('12411-0004.csv', start=6, replacer=c("STAG"))
	data <- read_csv2('12411-0004.csv', skip=6, n_max=30-6+1, na="-")
	colnames(data) <- d

Furthermore, the function  `read_gv100()` allows to parse the GV100 files of the German municipality register available [here](https://www.destatis.de/DE/ZahlenFakten/LaenderRegionen/Regionales/Gemeindeverzeichnis/Gemeindeverzeichnis.html): 

	d <- read_gv100("GV100NAD31122016.asc", stzrt=60)

Similar functions for reading the GV100 format exist for Python [github.com/WZBSocialScienceCenter/gemeindeverzeichnis](https://github.com/WZBSocialScienceCenter/gemeindeverzeichnis) and node.js/JSON [https://github.com/yetzt/node-gv100json](https://github.com/yetzt/node-gv100json). But see also this Python code from 2011: [rohablog.wordpress.com/2011/11/22/gv100-parser-python/](https://rohablog.wordpress.com/2011/11/22/gv100-parser-python/). 


# Notes

The functions `get_bundesland()`, `code_bundesland()` have been migrate to the package `ags` available at [github.com/sumtxt/ags](https://github.com/sumtxt/ags) which provides functions to work with the Amtlicher Gemeindeschlüssel (AGS). 


