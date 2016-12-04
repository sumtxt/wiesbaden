#' Retrieves Value Labels from GENESIS Databases 
#'
#' \code{retrieve_valuelabel} retrieves value labels for variable
#'
#' @param variablename name of the variable 
#' @param valuelabel "*" (default) retrieves all value labels. 
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
#' @seealso \code{\link{retrieve_datalist}} \code{\link{wiebaden}}
#'
#' @examples 
#'  \dontrun{
#'  # Value labels contain for the variable 'NAT' in the table with the 
#'  # federal election results on the county level. 
#' 
#'  metadata <- retrieve_valuelabel(variablename="NAT")
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_valuelabel <- function(
	variablename, 
	valuelabel="*", 
	user=NULL, 
	password=NULL, 
	db="regio") {

	set_user(user=user, password=password)

	baseurl <- paste(set_db(db=db), "RechercheService_2010", sep="")

	param <- list(
		method  = 'MerkmalAuspraegungenKatalog',
		kennung  = user,
		passwort = password,
		namen = variablename,
		auswahl = valuelabel, 
		bereich = 'Alle',
		listenLaenge = '500',
		sprache = 'de')

	datenaufbau <- GET(baseurl, query  = param) 
	datenaufbau <- content(datenaufbau, type='text/xml', encoding="UTF-8")

	entries <- xml_find_all(datenaufbau, '//merkmalAuspraegungenKatalogEintraege') 
	entries <- lapply(entries, function(x) xml_text(xml_find_all(x, './code|./inhalt')) )
	d <- as.data.frame(do.call(rbind, entries))
	colnames(d) <- c(variablename, "description")

	return(d)
	}

