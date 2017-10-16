#'	
#' Data retrieval client for Federal Statistical Office of Germany
#' 
#' 
#' 
#' Feedback is very welcome! 
#' 
#' 
#' @details
#' \tabular{ll}{
#'		Package: \tab wiesbaden\cr
#'		Type: \tab Package\cr
#'		Version: \tab 0.0.1.0\cr
#'		Date: \tab 2017-01-20\cr
#'		License: \tab  GPL-3\cr
#'		}
#' 
#' To authenticate a user and set the database, supply a vector with user/paswword and database shortcut in this form: 
#' \code{destatis_user <- c(user="ABCDEF", password="XXXXX", db="GHIJK")}
#' 
#' Alternatively if you use Linux or Mac, place a json file named '.genesis.json' in your root directory (~). Use the 
#' \code{\link{save_credentials}} to generate this file. For now, this only works with Linux/Mac. 
#' 
#' 
#' Available databases are "regio" (regionalstatistik.de), "nw" (landesdatenbank.nrw.de), 
#' "de" (www-genesis.destatis.de) and "bm" (bildungsmonitoring.de). 
#' 
#' 
#'
#' @name wiesbaden-package
#' 
#' @docType package
#' @aliases wiesbaden
#' @title Client to access the data from the Federal Statistical Office, Germany
#' @author Moritz Marbach \email{moritz.marbach@gess.ethz.ch}
#' @references 
#'
#' 
#' @import httr 
#' @import xml2
#' @import stringr
#' @import readr
#' @importFrom jsonlite fromJSON 
NULL

