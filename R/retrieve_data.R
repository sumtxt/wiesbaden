#'  Retrieves Data from DESTATIS
#'
#' \code{retrieve_data} retrieves a single data table from DESTATIS 
#'
#' @param tablename name of the table to retrieve.
#' @param startyear only retrieve values for years equal or larger to \code{startyear}. Default: 1990.
#' @param endyear only retrieve values for years smaller or equal to \code{endyear}. Default: 2016.
#' @param user (required) user name. 
#' @param password (required) password. 
#' @param db select database. Default: regio (currently the only option). 
#' 
#'   
#'   
#' @details 
#' 	Use \code{retrieve_datalist} to find the \code{tablename} based on the series you are interested in. 
#' 
#'  Instead of setting user/password via the function, one can also set a vector with user/paswword in this form: 
#'  \code{destatis_user <- c(user="ABCDEF", password="XXXXX")}
#'  
#' @return a \code{data.frame}. Value variables (_val) come with three additional variables (_qual, _lock, _err). The exact nature 
#' of these variables is unknown. 
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
retrieve_data <- function(
	tablename, 
	startyear = 1900, 
	endyear = 2016, 
	user=NULL, 
	password=NULL, 
	db="regio") {

	set_user(user=user, password=password)

	if (db=="regio") { 
		baseurl <- "https://www.regionalstatistik.de/genesisws/services/ExportService_2010"
	}  else { stop("DB: Currently not implemented.\n")}

	param <- list(
		method  = 'DatenExport',
		kennung  = user,
		passwort = password,
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
		regionalschluessel = '',
		sachmerkmal = '',
		sachschluessel = '',
		sachmerkmal2 = '',
		sachschluessel2 = '',
		sachmerkmal3 = '',
		sachschluessel3 = '',
		stand = '',
		sprache = 'de')

		httrdata <- GET(baseurl, query  = param, progress()); cat("\n")
		xmldata <- content(httrdata, type='text/xml', options="HUGE", encoding="UTF-8")
		sstr <- xml_text(xml_find_all(xmldata, './/quaderDaten'))
	
		sstr <- str_split(sstr, '\nK')
		tabs <- lapply(sstr[[1]], readstr_csv)

		# Construct header 

		DQERH  <- paste("id", tabs[[3]]$V2[2], sep="")
		DQA <- tabs[[4]]$V2[2:nrow(tabs[[4]])]
		DQZ <- tabs[[5]]$V2[2:nrow(tabs[[5]])]
		DQI <- tabs[[6]]$V2[2:nrow(tabs[[6]])]

		DQIexpd <- c("val", "qual", "lock", "err")

		DQIcom <- unlist(lapply(DQI, function(x) paste(x, DQIexpd,sep="_")))

		header <- c(DQERH, DQA, DQZ, DQIcom)

		data <- readstr_csv(sstr[[1]][7], skip=1)
		colnames(data) <- header

		return(data)
		}
