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
#'		Version: \tab 0.0.0.9000\cr
#'		Date: \tab 2016-11-20\cr
#'		License: \tab  GPL-3\cr
#'		}
#' 
#' To authenticate a user and set the database, supply a vector with user/paswword and database shortcut in this form: 
#' \code{destatis_user <- c(user="ABCDEF", password="XXXXX", db="GHIJK")}
#' 
#' Available databases are "regio" (regionalstatistik.de), "nw" (landesdatenbank.nrw.de) and "de" (www-genesis.destatis.de). 
#' 
#' 
#' 
#'
#' @name wiesbaden-package
#' 
#' @docType package
#' @aliases wiesbaden
#' @title Client to access the data from the Federal Statistical Office, Germany
#' @author Moritz Marbach \email{marbach@ipz.uzh.ch}
#' @references 
#'
#' 
#' @import httr 
#' @import xml2
#' @import stringr
NULL

