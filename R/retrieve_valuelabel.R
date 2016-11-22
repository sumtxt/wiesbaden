#' Retrieves Value Labels from DESTATIS
#'
#' \code{retrieve_valuelabel} retrieves value labels for variable
#'
#' @param variablename name of the variable 
#' @param valuelabel "*" (default) retrieves all value labels. 
#' @param user (required) user name. 
#' @param password (required) password. 
#' @param db select database. Default: regio (currently the only option). 
#' 
#'   
#'   
#' @details  
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
retrieve_valuelabel <- function(
	variablename, 
	valuelabel="*", 
	user=NULL, 
	password=NULL, 
	db="regio") {

	set_user(user=user, password=password)

	if (db=="regio") { 
		baseurl <- "https://www.regionalstatistik.de/genesisws/services/RechercheService_2010"
	}  else { stop("DB: Currently not implemented.\n")}

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
	colnames(d) <- c("name", "description")

	return(d)
	}

