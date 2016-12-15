#' Read Header of a GENESIS csv 
#'
#' \code{read_header_genesis} reads the header of a GENESIS csv. 
#'
#' @param ... arguments to \code{read_csv2}
#' @param start number of the first line of the header
#' @param lines number of header lines 
#' @param locale default encoding is 'windows-1252'
#' @param replacer a vector that is used as the first K column-names
#' 
#'   
#' @details 
#' To generate valid column names, the function replaces all special characters (e.g. German öüä) with ASCII letters 
#' and removes whitespaces. Multi-line headers are joined but separated with a '_'. 
#' 
#'  
#' @return a \code{vector} of column names.
#'
#' @seealso \code{\link{read_csv2}}
#'
#' @examples 
#'  \dontrun{
#'   
#'	 require(readr)
#'	 
#'	 url <- 'https://www-genesis.destatis.de/genesis/online?sequenz=tabelleDownload&selectionname=12411-0004&format=csv'
#'	 download.file(url, '12411-0004.csv')
#'	 
#'	 d <- read_header_genesis('12411-0004.csv', start=6, replacer=c("STAG"))
#'	 data <- read_csv2('12411-0004.csv', skip=6, n_max=30-6+1, na="-", locale=locale(encoding="windows-1252") )
#'	 colnames(data) <- d
#'   }
#' 
#' 
#' 
#' 
#' @export
read_header_genesis <- function(..., start, lines=2, readr_locale=locale(encoding="windows-1252"), replacer=NULL){
	h <- read_csv2(..., col_names=FALSE, skip=start-1, n_max=lines, col_types=cols( .default = col_character() ), locale=readr_locale )
	h <- apply(h, 2, function(x) get_character_vec(x) )
	if( !is.null(replacer) ) h[1:length(replacer)] <- replacer
	return(h)
	}
