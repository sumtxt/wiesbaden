#' Retrieves Data from GENESIS Databases 
#'
#' \code{retrieve_data} retrieves a single data table.  
#' 
#'
#' @param tablename name of the table to retrieve.
#' @param startyear only retrieve values for years equal or larger to \code{startyear}. Default: "".
#' @param endyear only retrieve values for years smaller or equal to \code{endyear}. Default: "".
#' @param regionalschluessel only retrieve values for particular regional units. See details for more information. Default: "".
#' @param regionalmerkmal key for Regionalklassifikation. See details for more information. Default: "".
#' @param sachmerkmal,sachmerkmal2,sachmerkmal3 key for Sachklassifikation. Default: "".
#' @param sachschluessel,sachschluessel2,sachschluessel3 value for Sachklassifikation. Default: "". 
#' @param inhalte retrieve only selected variables. Default is to retrieve all. 
#' @param genesis to authenticate a user and set the database (see below).
#' @param language retrieve information in German "de" (default) or in English "en" if available. 
#' @param ... other arguments send to the httr::GET request. 
#' 
#'   
#'   
#' @details 
#' Use \code{\link{retrieve_datalist}} to find the \code{tablename} based on the table series you are interested in. See the 
#' package description (\code{\link{wiesbaden}}) for details about setting the login and database. 
#' 
#' The parameter \code{regionalschluessel} can either be a single value (a single Amtlicher Gemeindeschlüssel) or a 
#' comma-separated list of values supplied as string (no whitespaces). Wildcard character "*" is allowed. 
#' If \code{regionalschluessel} is set, the parameter \code{regionalmerkmal} must also be set to GEMEIN, KREISE, 
#' REGBEZ, or DLAND. The same logic applies to the parameter combination \code{sachmerkmal} and \code{sachschluessel*}. 
#' The parameter \code{inhalte} takes a 1-6 character long name of a variable in the table. If choosing multiple variables, 
#' delimit by ",", e.g. "STNW01,STNW02" (no whitespaces).
#' 
#' Limiting the data request to particular years (via the \code{*year} parameters), geographical units (via the \code{regional*} parameters) 
#' attributes (via the \code{sach*} parameters) or selected variables (via the \code{inhalte} parameter) is necessary if the API request 
#' fails to return any data. If you are not able to download the table because of size, inspect the metadata first 
#' (using \link{retrieve_metadata} or \link{retrieve_valuelabel}) and then limit the data request accordingly. See also examples below. 
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
#'  # Assumes that user/password are stored via save_credentials()
#' 
#'  data <- retrieve_data(tablename="14111KJ002", genesis=c(db="regio") )
#' 
#'  # ... only the values for the AfD. 
#'
#'  data <- retrieve_data(tablename="14111KJ002", sachmerkmal="PART04", 
#'    sachschluessel="AFD", genesis=c(db="regio") )
#
#' 
#' # ... or only values from Saxony
#' 
#'  data <- retrieve_data(tablename="14111KJ002", regionalmerkmal="KREISE", 
#'    regionalschluessel="14*", genesis=c(db="regio") )
#' 
#' # Limiting the number of data points is in particular important for 
#' # large tables. For example, this data request fails: 
#' 
#' data <- retrieve_data(tablename="33111GJ005", genesis=c(db='regio'))
#' 
#' # But after limiting the request to one year, the data is returned:
#' 
#' data <- retrieve_data(tablename="33111GJ005", genesis=c(db='regio'), startyear=2019, endyear=2019)
#' 
#' # An alternative strategy is to only request a subset of the variables. 
#' # For example, this data request fails: 
#' 
#' data <- retrieve_data("12711GJ002", genesis=c(db="regio"))
#' 
#' # But when requesting only one instead of all variables, the data is returned: 
#'
#' data <- retrieve_data("12711GJ002", inhalte="BEV081", genesis=c(db="regio"))
#' 
#' 
#' 
#' } 
#' 
#' @export
retrieve_data <- function(
	tablename, 
	startyear = "", 
	endyear = "", 
	regionalmerkmal = "",
	regionalschluessel = "", 
	sachmerkmal = "",
	sachschluessel = "",
	sachmerkmal2 = "",
	sachschluessel2 = "",
	sachmerkmal3 = "",
	sachschluessel3 = "",
	inhalte = "",
	genesis=NULL, language='de', ... ) {

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
		inhalte = inhalte,
		regionalmerkmal = regionalmerkmal,
		regionalschluessel = regionalschluessel,
		sachmerkmal = sachmerkmal,
		sachschluessel = sachschluessel,
		sachmerkmal2 = sachmerkmal2,
		sachschluessel2 = sachschluessel2,
		sachmerkmal3 = sachmerkmal3,
		sachschluessel3 = sachschluessel3,
		stand = '',
		sprache = language)

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

	if ( is.na(sstr[[1]][7]) ) stop("The API has returned a response without data. 
		This might indicate that you requested too much data. Consider only  
		requesting a subset of the data. See package documentation for guidance.")

	data <- read_delim(sstr[[1]][7], skip = 1, col_names = header, delim = ';')

	return(as.data.frame(data))
	}
