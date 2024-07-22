#' Reads the DESTATIS GV100 Format 
#'
#' The GV100 format is used by DESTATIS to publish the German municipality register
#' 
#'
#' @param file path to file 
#' @param stzrt integer to select the administrative level (see details)
#' @param version which GV100 version. If NULL the version is guessed based on the file name. 
#' @param encoding encoding of the file
#' @param ... other parameters passed to \code{read_fwf} 
#' 
#'   
#' @details 
#' The Gemeindeverzeichnis (municipality register) is published 
#'  in a fixed width file refered to as "GV1000 ASCII Format" by 
#'  DESTATIS. The register features the list of municipality and 
#'  higher order administrative units. The function is a wrapper  
#'  around \code{\link[readr:read_fwf]{read_fwf}}. 
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
#' Since about 2019, the Gemeindeverzeichnis is using UTF-8 encoding rather 
#' than ISO-8859-1. See also DESTATIS Website: \href{https://www.destatis.de/DE/Themen/Laender-Regionen/Regionales/Gemeindeverzeichnis/_inhalt.html}{GV-ISys}
#'  
#' @return a \code{data.frame}. 
#'   
#' 
#' @seealso \code{\link[readr:read_fwf]{read_fwf}}
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
read_gv100 <- function(file, stzrt, 
		version=NULL, 
		encoding="iso-8859-1", 
		...){

	if ( is.null(version) ) {
		version <- ifelse(str_detect(file, "NAD"), "NAD", "AD")
	} 

	if (version=="AD"){
		
		spec <- gv100$ad 
		spec_fwf <- spec$fwf[spec$fwf$satzart==stzrt,]

	} else {
		
		spec <- gv100$nad 
		spec_fwf <- spec$fwf[spec$fwf$satzart==stzrt,]		

		}

	if(str_to_lower(encoding)=="utf-8"){

		# Workaround: https://github.com/sumtxt/wiesbaden/issues/13
		# "Durch die Aufname der sorbischen Schreibweise in den 
		# amtlichen Gemeindenamen ist es notwendig geworden, die 
		# Daten mit UTF-8 zu kodieren." Latin-2 (ISO8859-2) can 
		# accomodate Sorbian (Latin-1 can not). 
		x <- read_lines(file=file, 
			locale = locale(encoding = "UTF-8"), ...)
		x <- stri_encode(x, from = "UTF-8", to = "ISO8859-2")

		d <- withCallingHandlers(
				read_fwf(
					file=I(x), 
					col_positions=spec_fwf,
					col_types=spec$col, 
					locale = locale(encoding = "iso-8859-2"),
					...), 
			warning = h)

	} else {

		d <- withCallingHandlers(
				read_fwf(
				file=file, 
				col_positions=spec_fwf,
				col_types=spec$col, 
				locale = locale(encoding = encoding),
				...), 
			warning = h)

		}
	
	if (stzrt %in% c(40,50,60) & version=="AD"){
		d <- merge(d, spec$key, by="schluessel", all.y=FALSE, all.x=TRUE)
		d$schluessel <- d$typ
		d$typ <- NULL
		}
	
	d <- d[d$satzart==stzrt,]

	return(as.data.frame(d))
	}

# Suppress expected specific warning 
h <- function(w) if( any( grepl( "The following named parsers don't match the column names", w) ) ) invokeRestart( "muffleWarning" )
