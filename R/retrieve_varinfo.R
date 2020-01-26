#' Retrieves further information on a variable from GENESIS Databases
#'
#' \code{retrieve_varinfo} retrieves further information.
#'
#' @param variablename name of the variable 
#' @param genesis to authenticate a user and set the database (see below).
#' @param ... other arguments send to the httr::GET request. 
#'   
#' @details  
#'  See the package description (\code{\link{wiesbaden}}) for details about setting the login and database. 
#'  
#' @return a \code{data.frame}.
#'
#' @seealso \code{\link{retrieve_datalist}} \code{\link{wiesbaden}}
#'
#' @examples 
#' 
#'  \dontrun{
#'  # Variable information 'AI2105' (Anteil der Empfänger von Arbeitslosengeld II im Alter 
#'  # von 15 bis 24 Jahren an der Bevölkerung gleichen Alters)
#'  # Assumes that user/password are stored via save_credentials()
#'  
#'  metadata <- retrieve_varinfo(variablename="AI2105", genesis=c(db="regio") )
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_varinfo <- function(
	variablename, 
	genesis=NULL, ... ) {

	genesis <- make_genesis(genesis)

	baseurl <- paste(set_db(db=genesis['db']), "ExportService_2010", sep="")

	param <- list(
		method  = 'MerkmalInformation',
		kennung  = genesis['user'],
		passwort = genesis['password'],
		name = variablename,
		bereich = 'Alle',
		sprache = 'de')

	datenaufbau <- GET(baseurl, query  = param, ... ) 
	datenaufbau <- content(datenaufbau, type='text/xml', encoding="UTF-8")
	entries <- xml_find_all(datenaufbau, '//MerkmalInformationReturn') 

	if ( length(entries)==0  ) return( xml_text(datenaufbau) )
	
	entries <- lapply(entries, function(x) xml_text(xml_find_all(x, './code|./information')) )
	d <- as.data.frame(do.call(rbind, entries))

	if ( ncol(d)==0 ) return("No results found.")
	
	colnames(d) <- c(variablename, "description")

	return(d)
	}


