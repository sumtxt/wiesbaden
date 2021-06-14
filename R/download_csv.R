#' Download the csv-file of a table 
#'
#' \code{download_csv()} downloads the csv for a table
#'
#' @param tablename name of the table to retrieve.
#' @param startyear only retrieve values for years equal or larger to \code{startyear}. Default: "".
#' @param endyear only retrieve values for years smaller or equal to \code{endyear}. Default: "".
#' @param ... further parameters supplied as URL parameter in the GENESIS database call 
#' @param genesis_db name of the database (default: 'de').
#' @param save write string to a text file (default: TRUE)
#'  
#' @details
#' Downloads the csv file either to the working directory \code{getwd()} or outputs it as a string. 
#' This is an alternative approach to the retrieve_*() functions. This is designed for \url{https://www-genesis.destatis.de/genesis/online} as it does not require a login. It might not work as expected for the other databases.
#' 
#' 
#' @seealso \code{\link{read_header_genesis}}.
#' 
#' 
#' @examples 
#'  \dontrun{
#' 
#'  download_csv("12411-0004.csv")
#'
#'  }
#' 
#' 
#' 
#' 
#' @export
download_csv <- function(tablename, startyear="", endyear="", ..., genesis_db="de", save=TRUE){
	argg <-  eval(substitute(alist(...)))
	baseurl <- set_db2(db=genesis_db)
	param <- list(
		sequenz='tabelleDownload',
		selectionname=tablename,
		startjahr = startyear, 
		endjahr = endyear, 
		format = 'csv')
	param <- c(param,argg)
	httrdata <- GET(baseurl, query  = param) 
	str <- content(httrdata, encoding="windows-1252", as = "text")
	if( save ){
		writeLines(str, file(paste0(tablename,".csv")))
	} else{ return(str) }
	}
