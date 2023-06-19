#' Retrieves Meta Data from GENESIS Databases 
#'
#' \code{retrieve_metadata} retrieves meta data.
#'
#' @param tablename name of the table to retrieve.
#' @param genesis to authenticate a user and set the database (see below).
#' @param language retrieve information in German "de" (default) or in English "en" if available. 
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
#'  # Assumes that user/password are stored via save_credentials()
#' 
#'  metadata <- retrieve_metadata(tablename="14111KJ002", genesis=c(db="regio") )
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_metadata <- function(
	tablename, language='de',
	genesis=NULL,
	restapi = FALSE, ... ) {

	genesis <- make_genesis(genesis)
	
	
	if(restapi){
	  
	  baseurl <- paste(set_db(db=genesis['db'], restapi), "metadata/cube", sep="")
	  
	  # listenLaenge: 2500 is the max for this API
	  param <- list(
	    username  = genesis['user'],
	    password = genesis['password'],
	    name = tablename,
	    area = "all",
	    language = language)
	  
	  datenaufbau <- GET(baseurl, query  = param)
	  datenaufbau <- content(datenaufbau, type='application/json', encoding="UTF-8")
	  
	  if (is.null(datenaufbau$Object$Structure$Axis) ) return("No results found.")
	  
	  #Combine Code and Axis and Contents results
	  ax <- as.data.frame(do.call(rbind, datenaufbau$Object$Structure$Axis))[,c("Code", "Content")]
	  ax$Unit <- ""
	 
	  ct <- as.data.frame(do.call(rbind, datenaufbau$Object$Structure$Contents))[,c("Code", "Content", "Unit")]
	  
	  d <- rbind(ax,ct)
	  
	  colnames(d) <- c("name", "description_rest", "unit")
	  
	} else {
	  
	baseurl <- paste(set_db(db=genesis['db']), "ExportService_2010", sep="")

	param <- list(
		method  = 'DatenAufbau',
		kennung  = genesis['user'],
		passwort = genesis['password'],
		namen = tablename,
		bereich = 'Alle',
		sprache = language)

	datenaufbau <- GET(baseurl, query  = param, ... )  
	datenaufbau <- content(datenaufbau, type='text/xml', encoding="UTF-8")
	entries <- xml_find_all(datenaufbau, '//merkmale') 

	if ( length(entries)==0  ) return( xml_text(datenaufbau) )
	
	entries <- lapply(entries, function(x) xml_text(xml_find_all(x, './code|./inhalt|./masseinheit')) )
	d <- as.data.frame(do.call(rbind, entries))

	if ( ncol(d)==0 ) return("No results found.")

	colnames(d) <- c("name", "description", "unit")
	
	}

	return(d)
	}
