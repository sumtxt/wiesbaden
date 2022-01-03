make_genesis <- function(genesis){
	if ( is.null(genesis['db']) ) {
		stop("genesis['db'] missing/unrecognized.")
	}
	if ( !(genesis['db'] %in% c("regio", "nrw", "bm", "de", "by", "st")) ){
		stop("genesis['db'] missing/unrecognized.")
	}
	if ( is.na(genesis['user']) | is.na(genesis['password']) ){
		if (genesis['db']=='regio'){
			genesis <- key_user_pw(genesis,"regionalstatistik")
		}
		else if (genesis['db']=='nrw'){
			genesis <- key_user_pw(genesis,"landesdatenbank-nrw")
		}
		else if (genesis['db']=='bm'){
			genesis <- key_user_pw(genesis,"bildungsmonitoring")
		}	
		else if (genesis['db']=='st'){
			genesis <- key_user_pw(genesis,"landesdatenbank-st")
		}	
		else if (genesis['db']=='by'){
			genesis <- key_user_pw(genesis,"landesdatenbank-by")
		}	
		else if (genesis['db']=='de'){
			genesis <- key_user_pw(genesis,"destatis")
		}	else {
			stop("genesis['user']/genesis['password'] is missing.")
		}
	}
	return(genesis)
	}

key_user_pw <- function(genesis,service){
	genesis["user"] <- as.character(key_list(service=service)['username'])
	genesis["password"] <- as.character(key_get(service=service, 
		username=genesis["user"]))
	return(genesis)
	}

# genesis_error_check <- function(xml){
# 	
# 	if ( length(xml)==0 ) {
# 		error <- xml_find_all(xml, './/faultstring/text()')
# 		if ( length(error) !=0 ) stop(as.character(error))
# 		}
# 
# 	if ( length(xml)==1 ){ 
# 		if ( xml_has_attr(xml, 'nil')==TRUE )	{
# 			stop("No results found.") }
# 		}
# 
# 	}

readstr_csv <- function(string,skip=0){
	con <- textConnection(string)
	tab <- read.csv2(con, header=FALSE, stringsAsFactors=FALSE, skip=skip)
	return(tab)
	}

set_db <- function(db){
	if (db=="nrw") return("https://www.landesdatenbank.nrw.de/ldbnrwws/services/")
	if (db=="regio") return("https://www.regionalstatistik.de/genesisws/services/")
	if (db=="de") return("https://www-genesis.destatis.de/genesisWS/web/")
	if (db=="bm") return("https://www.bildungsmonitoring.de/bildungws/services/")
	if (db=="st") return("https://genesis.sachsen-anhalt.de/webservice/services/")
	if (db=="by") return("https://www.statistikdaten.bayern.de/genesisWS/services/")
	stop("DB: Currently not implemented.")
	}

set_db2 <- function(db){
	if (db=="de") return("https://www-genesis.destatis.de/genesis/online")
	if (db=="by") return("https://www.statistikdaten.bayern.de/genesis/online")
	if (db=="regio") return("https://www.regionalstatistik.de/genesis/online/")	
	stop("DB: Currently not implemented.")
	}


get_character_vec <- function(x){ 
	x <- paste(unlist(na.omit(x), use.names=FALSE), collapse="_")
	x <- stri_trans_general(x, "Latin-ASCII")
	x <- str_replace_all(x, " *", "")
	x <- str_replace_all(x, "[^a-zA-Z0-9_]", "")
	return(x)
	}
