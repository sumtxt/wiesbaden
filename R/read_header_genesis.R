#' Read Header of a GENESIS csv 
#'
#' \code{read_header_genesis} reads the header of a GENESIS csv. 
#'
#' @param ... arguments to \code{read_csv2}
#' @param start number of the first line of the header
#' @param lines number of header lines 
#' @param locale default encoding is 'windows-1252'
#' @param replacer a vector that is used as the first K column-names
#' @param clean_letters make proper variable names? (default: TRUE)
#' @param readr_locale definition of locale() to be passed to read_csv2()
#'   
#' @details 
#' To generate valid column names, the function replaces all special characters (e.g. German öüä) with ASCII letters 
#' and removes whitespaces. Multi-line headers are joined but separated with a '_'. 
#' 
#'  
#' @return a \code{vector} of column names.
#'
#' @seealso \code{\link[readr:read_csv2]{read_csv2}}
#'
#' @examples 
#'  \dontrun{
#'   
#'	 library(readr)
#'	 
#'	 download_csv(tablename="12411-0004")
#'	 
#'	 d <- read_header_genesis('12411-0004.csv', start=6, replacer=c("STAG"))
#'	 data <- read_csv2('12411-0004.csv', skip=6, n_max=30-6+1, 
#' 		na="-", locale=locale(encoding="windows-1252") )
#'	 colnames(data) <- d
#'   }
#' 
#' 
#' 
#' 
#' @export
read_header_genesis <- function(..., start, lines=2, readr_locale=locale(encoding="windows-1252"), replacer=NULL, clean_letters=TRUE){
	h <- read_csv2(..., col_names=FALSE, skip=start-1, n_max=lines, col_types=cols( .default = col_character() ), locale=readr_locale )
	if(clean_letters==TRUE){
		h <- apply(h, 2, function(x) get_character_vec(x) )
		} else{
		h <- apply(h, 2, function(x) paste(unlist(na.omit(x), use.names=FALSE), collapse=" "))
		}
	if( !is.null(replacer) ) h[1:length(replacer)] <- replacer
	return(h)
	}
