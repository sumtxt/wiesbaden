readstr_csv <- function(string,skip=0){
	con <- textConnection(string)
	tab <- read.csv2(con, header=FALSE, stringsAsFactors=FALSE, skip=skip)
	return(tab)
	}

set_user <- function(user=user, password=password){

	if ( !is.null(user) & !is.null(password) ) return(NULL)

	if ( is.null(user) | is.null(password) ) {
		if ( !is.null(genesis_user) ){
			user <- genesis_user['user']
			password <- genesis_user['password']
			if ( !is.na(genesis_user['db']) ) db <- genesis_user['db']
			return(NULL)
			} 
	} else {
		stop("User/Password missing")
	}

}

set_db <- function(db){
	if (db=="nw") return("https://www.landesdatenbank.nrw.de/ldbnrwws/services/")
	if (db=="regio") return("https://www.regionalstatistik.de/genesisws/services/")
	if (db=="de") return("https://www-genesis.destatis.de/genesisWS/web/")
	stop("DB: Currently not implemented.")
	}