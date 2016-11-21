#' Retrieves Data List from DESTATIS
#'
#' \code{retrieve_datalist} retrieves a list of available data tables in a series
#'
#' @param tableseries name of series for which tables should be retrieved. 
#' @param user (required) user name. 
#' @param password (required) password. 
#' @param db select database. Default: regio (currently the only option). 
#' 
#'   
#'   
#' @details 
#'  abc
#'  
#' @return a \code{data.frame}
#'
#' @seealso \code{\link{retrieve_data}}
#'
#' @examples 
#'  \dontrun{
#'  abc. 
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_datalist <- function(user=NULL, tableseries, password=NULL, db="regio"){

	set_user(user=user, password=password)

	if (db=="regio") { 
		baseurl <- "https://www.regionalstatistik.de/genesisws/services/RechercheService_2010"
	}  else { stop("DB: Currently not implemented.")}

	param <- list(
		method  = 'DatenKatalog',
		kennung  = user,
		passwort = password,
		bereich = 'Alle',
		filter = tableseries,
		listenLaenge = '500',
		sprache = 'de')

	httrdata <- GET(baseurl, query  = param) 
	xmldata <- content(httrdata, type='text/xml')
	
	entries <- xml_find_all(xmldata, '//datenKatalogEintraege') 
	entries <- lapply(entries, function(x) xml_text(xml_find_all(x, './code|./beschriftungstext')) )
	d <- as.data.frame(do.call(rbind, entries))

	# Cleanup 
	colnames(d) <- c("tablename", "description")
	d$tablename <- unlist(lapply(str_split(d$tablename, pattern=",", n=2), function(x) x[2] ))
	d$tablename <- str_trim(str_replace_all(d$tablename, "\n", " "))

	if ( nrow(d) > 500 ) cat("Warning: The selected series might contain more data, 
		but maximum number of results (N=500) was hit.\n")
	return(d)
	}