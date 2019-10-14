#' Retrieves Data from GENESIS Databases 
#'
#' \code{retrieve_data} retrieves a single data table.  
#' 
#'
#' @param tablename name of the table to retrieve.
#' @param startyear only retrieve values for years equal or larger to \code{startyear}. Default: "".
#' @param endyear only retrieve values for years smaller or equal to \code{endyear}. Default: "".
#' @param regionalschluessel only retrieve values for a particular regional unit. Default: "".
#' @param genesis to authenticate a user and set the database (see below).
#' @param ... other arguments send to the httr::GET request. 
#' 
#'   
#'   
#' @details 
#' Use \code{\link{retrieve_datalist}} to find the \code{tablename} based on the table series you are interested in. See the 
#' package description (\code{\link{wiesbaden}}) for details about setting the login and database. 
#' 
#'  
#' @return a \code{data.frame}. Value variables (_val) come with three additional variables (_qual, _lock, _err). The exact nature 
#' of these variables is unknown, but _qual appears to indicate if _val is a valid value. If _qual=="e" the value in _val is 
#' valid while if _qual!="e" (then _qual = ("-","/", ".", "x", ... ) ) it is typically zero should/might be set to NA. 
#'  
#' 
#' 
#'
#' @seealso \code{\link{retrieve_datalist}} \code{\link{wiesbaden}}
#'
#' @examples 
#' 
#'  \dontrun{
#'  # Retrieve values for the table 14111KJ002 which contains the 
#'  # federal election results on the county level. 
#'  # Assumes that user/password are stored in ~/.genesis.json
#' 
#'  data <- retrieve_data(tablename="14111KJ002", genesis=c(db="regio") )
#'  }
#' 
#' 
#' 
#' 
#' @export
retrieve_data <- function(
	tablename, 
	startyear = "", 
	endyear = "", 
	regionalschluessel = "", 
	genesis=NULL, ... ) {

	genesis <- make_genesis(genesis)

	baseurl <- paste(set_db(db=genesis['db']), "ExportService_2010", sep="")

	param <- list(
		method  = 'DatenExport',
		kennung  = genesis['user'],
		passwort = genesis['password'],
		namen = tablename,
		bereich = 'Alle',
		format = 'csv',
		werte = 'true',
		metadaten = 'false',
		zusatz = 'false',
		startjahr = as.character(startyear),
		endjahr = as.character(endyear),
		zeitscheiben = '',
		inhalte = '',
		regionalmerkmal = '',
		regionalschluessel = regionalschluessel,
		sachmerkmal = '',
		sachschluessel = '',
		sachmerkmal2 = '',
		sachschluessel2 = '',
		sachmerkmal3 = '',
		sachschluessel3 = '',
		stand = '',
		sprache = 'de')

	httrdata <- GET(baseurl, query  = param, progress(), ... )
	xmldata <- content(httrdata, type='text/xml', options="HUGE", encoding="UTF-8")
	entries <- xml_find_all(xmldata, './/quaderDaten')

	if ( length(entries)==0  ) return( xml_text(xmldata) )

	sstr <- str_split(xml_text(entries), '\nK')

	if ( sstr[[1]][1] == "" ) return("No results found.")

	tabs <- lapply(sstr[[1]], readstr_csv)

	# Construct header 

	DQERH  <- paste("id", tabs[[3]]$V2[2], sep="")
	DQA <- tabs[[4]]$V2[2:nrow(tabs[[4]])]
	DQZ <- tabs[[5]]$V2[2:nrow(tabs[[5]])]
	DQI <- tabs[[6]]$V2[2:nrow(tabs[[6]])]

	DQIexpd <- c("val", "qual", "lock", "err")

	DQIcom <- unlist(lapply(DQI, function(x) paste(x, DQIexpd,sep="_")))

	header <- c(DQERH, DQA, DQZ, DQIcom)

	data <- read_delim(sstr[[1]][7], skip = 1, col_names = header, delim = ';')

	return(as.data.frame(data))
	}
