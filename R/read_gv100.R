#' Reads the DESTATIS GV100 Format 
#'
#' The GV100 format is used by DESTATIS to publish the German municipality register
#' 
#'
#' @param file path to file 
#' @param stzrt integer to select the administrative level (see details)
#' @param version which GV100 version. If NULL the version is guessed based on the file name. 
#' @param lcl a \code{readr::locale()} specifying the encoding of the file. 
#' 
#'   
#'   
#' @details 
#' The Gemeindeverzeichnis (municipality register) is published 
#'  in a fixed width file refered to as "GV1000 ASCII Format" by 
#'  DESTATIS. The register features the list of municipality and 
#'  higher order administrative units.  
#' 
#' There are two types of files: One feature the administrative 
#' information (\code{version="AD"}) and one with non-administrative 
#' (\code{version="NAD"}). If \code{version=NULL}, read_gv100() guess the 
#' type based on the file name. 
#' 
#' To select a particular administrative 
#'  unit use the stzrt argument (Satzart). For the 
#'  AD version, the following choices are possible: 
#' 
#'  10 - Länder (states)
#'  20 - Regierungsbezirke 
#'  30 - Regionsdaten (only Baden-Württemberg)
#'  40 - Kreise (counties)
#'  50 - Gemeindeverbandsdaten 
#'  60 - Gemeinden (municipalities)
#'  
#' For the NAD version only: 
#' 
#' 	41 - Kreise (counties)
#'  61 - Gemeinden (municipalities)
#'  
#' 
#' @return a \code{data.frame}. 
#'   
#' 
#' @seealso 
#' \url{https://www.destatis.de/DE/ZahlenFakten/LaenderRegionen/Regionales/Gemeindeverzeichnis/Gemeindeverzeichnis.html}
#' \code{\link[readr]{read_fwf}} and \code{\link[readr]{locale}}
#' 
#' 	
#'
#' @examples 
#'  \dontrun{
#'   
#' 		d <- read_gv100("GV100NAD31122016.asc", stzrt=60)
#' 
#'   }
#' 
#' 
#' 
#' @export
read_gv100 <- function(file, stzrt, version=NULL, 
		lcl=locale(encoding="iso-8859-1")){

	if ( str_detect(file, "NAD") ) version = "NAD" else version = "AD"

	if (version=="AD"){
		spec <- gv100$ad 
		spec_fwf <- spec$fwf[spec$fwf$satzart==stzrt,]
		d <- withCallingHandlers(read_fwf(file, spec_fwf,
			locale=lcl, col_types=spec$col), warning = h)
		if (stzrt %in% c(40,50,60)){
			d <- merge(d, spec$key, by="schluessel", all.y=FALSE, all.x=TRUE)
			d$schluessel <- d$typ
			d$typ <- NULL
		}
	} else { 
		spec <- gv100$nad 
		spec_fwf <- spec$fwf[spec$fwf$satzart==stzrt,]
		d <- withCallingHandlers(read_fwf(file, spec_fwf,
			locale=lcl, col_types=spec$col), warning = h)
		}
	as.data.frame(d[d$satzart==stzrt,]) 
	}

# Suppress expected specific warning 
h <- function(w) if( any( grepl( "The following named parsers don't match the column names", w) ) ) invokeRestart( "muffleWarning" )
