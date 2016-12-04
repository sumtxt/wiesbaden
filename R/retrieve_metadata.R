#' Retrieves Meta Data from GENESIS Databases 
#'
#' \code{retrieve_metadata} retrieves meta data.
#'
#' @param tablename name of the table to retrieve.
#' @param user user name (see below).
#' @param password password (see below). 
#' @param db select database, default 'regio' (see below). 
#' 
#'   
#'   
#' @details 
#'  See the package description (\code{\link{wiebaden}}) for details about setting the login and database. 
#'  
#' @return a \code{data.frame}.
#'
#' @seealso \code{\link{wiebaden}}
#'
#' @examples 
#'  \dontrun{
#'  # Meta data contain the explanations to the variable names for the table
#'  # federal election results on the county level. 
#' 
#'  metadata <- retrieve_metadata(tablename="14111KJ002")
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_metadata <- function(
	tablename, 
	user=NULL, 
	password=NULL, 
	db="regio") {

	set_user(user=user, password=password)

	baseurl <- paste(set_db(db=db), "ExportService_2010", sep="")


	param <- list(
		method  = 'DatenAufbau',
		kennung  = user,
		passwort = password,
		namen = tablename,
		bereich = 'Alle',
		sprache = 'de')

	datenaufbau <- GET(baseurl, query  = param) 
	datenaufbau <- content(datenaufbau, type='text/xml', encoding="UTF-8")

	entries <- xml_find_all(datenaufbau, '//merkmale') 
	entries <- lapply(entries, function(x) xml_text(xml_find_all(x, './code|./inhalt|./masseinheit')) )
	d <- as.data.frame(do.call(rbind, entries))
	colnames(d) <- c("name", "description", "unit")

	return(d)
	}
