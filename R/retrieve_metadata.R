#' Retrieves Meta Data from GENESIS Databases 
#'
#' \code{retrieve_metadata} retrieves meta data.
#'
#' @param tablename name of the table to retrieve.
#' @param genesis to authenticate a user and set the database (see below).
#' @param ... other arguments send to the httr::GET request. 
#'   
#'   
#' @details 
#'  See the package description (\code{\link{wiesbaden}}) for details about setting the login and database. 
#'  
#' @return a \code{data.frame}.
#'
#' @seealso \code{\link{wiesbaden}}
#'
#' @examples 
#' 
#'  \dontrun{
#'  # Meta data contain the explanations to the variable names for the table
#'  # federal election results on the county level. 
#'  # Assumes that user/password are stored in ~/.genesis.json
#' 
#'  metadata <- retrieve_metadata(tablename="14111KJ002", genesis=c(db="regio") )
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_metadata <- function(
	tablename, 
	genesis=NULL, ... ) {

	genesis <- make_genesis(genesis)

	baseurl <- paste(set_db(db=genesis['db']), "ExportService_2010", sep="")

	param <- list(
		method  = 'DatenAufbau',
		kennung  = genesis['user'],
		passwort = genesis['password'],
		namen = tablename,
		bereich = 'Alle',
		sprache = 'de')

	datenaufbau <- GET(baseurl, query  = param, ... )  
	datenaufbau <- content(datenaufbau, type='text/xml', encoding="UTF-8")
	entries <- xml_find_all(datenaufbau, '//merkmale') 

	if ( length(entries)==0  ) return( xml_text(datenaufbau) )
	
	entries <- lapply(entries, function(x) xml_text(xml_find_all(x, './code|./inhalt|./masseinheit')) )
	d <- as.data.frame(do.call(rbind, entries))

	if ( ncol(d)==0 ) return("No results found.")

	colnames(d) <- c("name", "description", "unit")

	return(d)
	}
