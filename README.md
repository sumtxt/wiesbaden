# wiesbaden 

<!-- badges: start -->
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/wiesbaden)](https://cran.r-project.org/package=wiesbaden)
[![Downloads](http://cranlogs.r-pkg.org/badges/wiesbaden)](https://CRAN.R-project.org/package=wiesbaden)
[![Downloads](http://cranlogs.r-pkg.org/badges/grand-total/wiesbaden)](https://CRAN.R-project.org/package=wiesbaden)
<!-- badges: end -->

> [!CAUTION]
The Federal Statistical Office of Germany (DESTATIS) will discontinue the API currently used by this R package, which means the package will stop working for [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online) in mid-2025. The APIs for the other databases—[regionalstatistik.de](https://www.regionalstatistik.de/genesis/online), [bildungsmonitoring.de](https://www.bildungsmonitoring.de/bildung/online/logon), and [landesdatenbank.nrw.de](https://www.landesdatenbank.nrw.de)—will also be shut down in the near future. **There are no plans to update this package to support the new API**, so users are encouraged to switch to the R package [`restatis`](https://correlaid.github.io/restatis/). 

Since 2016 the R package `wiesbaden` provides functions to directly retrieve data from databases maintained by the Federal Statistical Office of Germany (DESTATIS) in Wiesbaden. The package uses the SOAP XML web service from DESTATIS [(PDF Documentation)](https://www-genesis.destatis.de/genesis/online?Menu=Webservice). 

Access to the following databases is implemented: 

* [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online) 
* [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online)
* [bildungsmonitoring.de](https://www.bildungsmonitoring.de/bildung/online/logon) 
* [landesdatenbank.nrw.de](https://www.landesdatenbank.nrw.de) 
* ~~statistikdaten.bayern.de~~ (data retrieval API disabled)
* ~~genesis.sachsen-anhalt.de~~ (data retrieval API disabled)
* ~~statistik.sachsen.de~~ (API disabled)
* ~~ergebnisse.zensus2022.de~~ (not implemented)

Note, to access any of the databases using this package, you need to register on the respective website to get a personal login name and password. The registration is free.

### Installation 

You can install the package directly from CRAN: 

```R
install.packages("wiesbaden")
```

Or install the latest version from Github using:  

```R	
remotes::install_github("sumtxt/wiesbaden", force=TRUE)
```


### Usage 

The package helps with retrieving the data cubes which are used to construct the data tables available as `csv` files via the web application of each database. The data cubes are long format data tables that are much easier to process as compared to the `csv` files. For details on how to use the package: [Getting Started
with wiesbaden](https://sumtxt.github.io/wiesbaden/articles/wiesbaden.html).

The package also helps with importing the [German municipality register files](https://www.destatis.de/DE/ZahlenFakten/LaenderRegionen/Regionales/Gemeindeverzeichnis/Gemeindeverzeichnis.html) via the function `read_gv100()`. For more information see the help file of this function. 

Users that wish to work with the `csv` files might find the `download_csv()` and `read_header_genesis()` in this package helpful. The former can be used to automate downloads and the latter facilitates importing downloaded files. Users might also wish to check the R package `destatiscleanr`  [github.com/cutterkom/destatiscleanr](https://github.com/cutterkom/destatiscleanr).


### FAQ 

* Does this package work with a proxy? _Yes. Set the proxy globally before calling any package command, e.g.:_ 

	```R	
	httr::set_config(httr::use_proxy(
			"your.proxy", port = 1234, auth = "basic"))

	data <- retrieve_data(tablename="14111KJ002", 
			genesis=c(db="regio"))
	```	


### Similar and Complementary Packages 

* The R package `destatiscleanr` [github.com/cutterkom/destatiscleanr](https://github.com/cutterkom/destatiscleanr) provides functions to help importing `csv` files downloaded via the web application.

* The R package `restatis` [correlaid.github.io/restatis/](https://correlaid.github.io/restatis/) provides similar functions to access [genesis.destatis.de](https://www-genesis.destatis.de/genesis/online), [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online) and the [Zensus 2022](https://ergebnisse.zensus2022.de/datenbank/online/).

* The R package `bonn` [github.com/sumtxt/bonn](https://github.com/sumtxt/bonn) provides functions to retrieve data from the [INKAR](https://www.inkar.de/) database maintained by the Federal Office for Building and Regional Planning (BBSR) in Bonn.

* The R package `AGS` [github.com/sumtxt/ags](https://github.com/sumtxt/ags) provides functions to work with the [Amtlicher Gemeindeschlüssel (AGS)](https://de.wikipedia.org/wiki/Amtlicher_Gemeindeschl%C3%BCssel), e.g. construct time series of statistics for Germany's municipalities and districts.

* The Python packages [github.com/WZBSocialScienceCenter/gemeindeverzeichnis](https://github.com/WZBSocialScienceCenter/gemeindeverzeichnis) and [rohablog.wordpress.com/2011/11/22/gv100-parser-python/](https://rohablog.wordpress.com/2011/11/22/gv100-parser-python/) provide functions to read the GV100 format. 

* The node.js package [https://github.com/yetzt/node-gv100json](https://github.com/yetzt/node-gv100json) provides functions to read the GV100 format. 

* The Python package [github.com/pudo/regenesis](https://github.com/pudo/regenesis) provides a function to bulk download data from [regionalstatistik.de](https://www.regionalstatistik.de/genesis/online). 


