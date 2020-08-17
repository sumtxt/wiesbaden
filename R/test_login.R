#' Tests Login in GENESIS Databases 
#'
#' \code{test_login} tests if the login works. 
#' 
#'
#' @param genesis to authenticate a user and set the database (see below).
#' @param ... other arguments send to the httr::GET request. 
#' 
#'  
#' @return a \code{string} with the server return message. 
#'  
#' 
#'
#' @examples 
#' 
#'  \dontrun{
#' 
#'  test_login(genesis=c(db="regio") )
#' 
#'  }
#' 
#' 
#' 
#' 
#' @export
test_login <- function(genesis=NULL, ... ) {

	genesis <- make_genesis(genesis)

	baseurl <- paste(set_db(db=genesis['db']), "TestService_2010", sep="")

	param <- list(
		method  = 'logonoff',
		kennung  = genesis['user'],
		passwort = genesis['password'])

	httrdata <- GET(baseurl, query  = param, ... )
	xmldata <- content(httrdata, type='text/xml', encoding="UTF-8")

	return(xml_text(xmldata))
	}
