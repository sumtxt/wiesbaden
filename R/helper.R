
make_genesis <- function(genesis){
	if ( is.null(genesis['db']) ) {
		stop("genesis['db'] missing/unrecognized.")
	}
	if ( !(genesis['db'] %in% c("regio", "nrw", "bm", "de")) ){
		stop("genesis['db'] missing/unrecognized.")
	}
	if ( is.na(genesis['user']) | is.na(genesis['password']) ){
		if ( .Platform['OS.type'] == 'unix' & 
			file.exists('~/.genesis.json') ){
				cred <- fromJSON(read_file('~/.genesis.json'))
				cred <- subset(cred, name==genesis['db'])
				if ( nrow(cred)!= 1 ) stop("Error in retrieving credentials from ~/.genesis.json")
				genesis["user"] <- as.character(cred['user'])
				genesis["password"] <- as.character(cred['password'])
		} else {
			stop("genesis['user']/genesis['password'] is missing.")
		}
	}
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
	if (db == "bm") return("https://www.bildungsmonitoring.de/bildungws/services/")
	stop("DB: Currently not implemented.")
	}


# Source: https://stackoverflow.com/questions/17517319/r-replacing-foreign-characters-in-a-string
to_plain <- function(s) {
   old1 <- "šžþàáâãäåçèéêëìíîïðñòóôõöùúûüýŠŽÞÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝ"
   new1 <- "szyaaaaaaceeeeiiiidnooooouuuuySZYAAAAAACEEEEIIIIDNOOOOOUUUUY"
   s1 <- chartr(old1, new1, s)
   old2 <- c("œ", "ß", "æ", "ø")
   new2 <- c("oe", "ss", "ae", "oe")
   s2 <- s1
   for(i in seq_along(old2)) s2 <- gsub(old2[i], new2[i], s2, fixed = TRUE)
   return(s2)
   }

get_character_vec <- function(x){ 
	x <- paste(unlist(na.omit(x), use.names=FALSE), collapse="_")
	x <- to_plain(x)
	x <- str_replace_all(x, " *", "")
	x <- str_replace_all(x, "[^a-zA-Z0-9_]", "")
	return(x)
	}

genesis_url <- function(tabelle) {
  return(
    paste0("https://www-genesis.destatis.de/genesis/online?sequenz=tabelleDownload&selectionname=",
           tabelle,
           "&format=csv")
  )
}
