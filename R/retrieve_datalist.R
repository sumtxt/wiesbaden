#' Retrieves List of Tables from GENESIS Databases 
#'
#' \code{retrieve_datalist} retrieves a list of available data tables in a series. 
#'
#' @param tableseries name of series for which tables should be retrieved. 
#' @param genesis to authenticate a user and set the database (see below).
#' @param language retrieve information in German "de" (default) or in English "en" if available. 
#' @param ... other arguments send to the httr::GET request. 
#'   
#'   
#' @details 
#' See the package description (\code{\link{wiesbaden}}) for details about setting the login and database. 
#' To retrieve a list of all available data use tableseries="*" or combine the wildcard character * with a prefix (see below for an example).
#' 
#' @return a \code{data.frame}
#'
#' @seealso \code{\link{retrieve_data}} \code{\link{wiesbaden}}
#'
#' @examples 
#' 
#'  \dontrun{
#'  # Retrieves list of available tables for the table series 14111 
#'  # which contains the federal election results. 
#'  # Assumes that user/password are stored via save_credentials()
#' 
#'  d <- retrieve_datalist(tableseries="14111*", genesis=c(db="regio") )
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_datalist <- function(tableseries, 
	genesis=NULL, language='de', ... ) {

	genesis <- make_genesis(genesis)

	baseurl <- paste(set_db(db=genesis['db']), "RechercheService_2010", sep="")

	param <- list(
		method  = 'DatenKatalog',
		kennung  = genesis['user'],
		passwort = genesis['password'],
		bereich = 'Alle',
		filter = tableseries,
		listenLaenge = '500',
		sprache = language)

	httrdata <- GET(baseurl, query  = param, ... ) 
	xmldata <- content(httrdata, type='text/xml', encoding="UTF-8")
	entries <- xml_find_all(xmldata, '//datenKatalogEintraege') 

	if ( length(entries)==0  ) return( xml_text(xmldata) )

	entries <- lapply(entries, function(x) rev(xml_text(xml_find_all(x, './code|./beschriftungstext'))) )
	d <- as.data.frame(do.call(rbind, entries))

	if ( ncol(d)==0 ) return("No results found.")

	# Cleanup 
	colnames(d) <- c("tablename", "description")
	d$description <- unlist(lapply(str_split(d$description, pattern=",", n=2), function(x) x[2] ))
	d$description <- str_trim(str_replace_all(d$description, "\n", " "))

	if ( nrow(d) == 500 ) warning("The selected series might contain more data. The maximum number of results was retrieved (N=500).\n")
	return(d)
	}