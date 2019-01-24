#' Download the csv-file of a table 
#'
#' \code{download_csv()} downloads the csv for a table
#'
#' @param tablename name of the table to retrieve.
#' @param genesis_db name of the database (default: 'de').
#'  
#' @details
#' Downloads the csv file to the working directory \code{getwd()}. 
#' This is an alternative approach to the retrieve_*() functions.  
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
download_csv <- function(tablename, genesis_db="de") {
	if(genesis_db=="de"){
	  url <- paste0("https://www-genesis.destatis.de/genesis/online?sequenz=tabelleDownload&selectionname=",
  				tablename,"&format=csv")	
	  download.file(url, '12411-0004.csv')
	} else {
		stop("Currently, download_csv() only works with the db='de'.") 
	}
	}
