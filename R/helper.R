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
