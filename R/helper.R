readstr_csv <- function(string,skip=0){
	con <- textConnection(string)
	tab <- read.csv2(con, header=FALSE, stringsAsFactors=FALSE, skip=skip)
	return(tab)
	}

set_db <- function(db){
	if (db=="nw") return("https://www.landesdatenbank.nrw.de/ldbnrwws/services/")
	if (db=="regio") return("https://www.regionalstatistik.de/genesisws/services/")
	if (db=="de") return("https://www-genesis.destatis.de/genesisWS/web/")
	stop("DB: Currently not implemented.")
	}