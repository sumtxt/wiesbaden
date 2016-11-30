#' Retrieves Meta Data from DESTATIS
#'
#' \code{retrieve_metadata} retrieves meta data.
#'
#' @param tablename name of the table to retrieve.
#' @param user (required) user name. 
#' @param password (required) password. 
#' @param db select database. Default: "regio". Other options: "de", "nw", "by". 
#' 
#'   
#'   
#' @details 
#'  Use \code{retrieve_datalist} to find the \code{tablename} based on the series you are interested in. 
#' 
#'  Instead of setting user/password via the function, one can also a vector with user/paswword in this form: 
#'  \code{destatis_user <- c(user="ABCDEF", password="XXXXX")}
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
