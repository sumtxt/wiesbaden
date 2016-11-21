#' Retrieves Meta Data from DESTATIS
#'
#' \code{retrieve_metadata} retrieves meta data.
#'
#' @param dataname name of the table to retrieve.
#' @param user (required) user name. 
#' @param password (required) password. 
#' @param db select database. Default: regio (currently the only option). 
#' 
#'   
#'   
#' @details 
#'  abc
#'  
#' @return a \code{data.frame}.
#'
#' @seealso \code{\link{retrieve_datalist}}
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
retrieve_metadata <- function(
	tablename, 
	user=NULL, 
	password=NULL, 
	db="regio") {

	set_user(user=user, password=password)

	if (db=="regio") { 
		baseurl <- "https://www.regionalstatistik.de/genesisws/services/ExportService_2010"
	}  else { stop("DB: Currently not implemented.\n")}

	param <- list(
		method  = 'DatenAufbau',
		kennung  = user,
		passwort = password,
		namen = tablename,
		bereich = 'Alle',
		sprache = 'de')

	datenaufbau <- GET(baseurl, query  = param) 
	datenaufbau <- content(datenaufbau, type='text/xml')

	entries <- xml_find_all(datenaufbau, '//merkmale') 
	entries <- lapply(entries, function(x) xml_text(xml_find_all(x, './code|./inhalt|./masseinheit')) )
	d <- as.data.frame(do.call(rbind, entries))
	colnames(d) <- c("name", "description", "unit")

	return(d)
	}
