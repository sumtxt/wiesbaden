#'	
#' Data retrieval client for Federal Statistical Office of Germany
#' 
#'
#' 
#' To authenticate a user and set the database, supply a vector with user/password and database shortname in this form: 
#' \code{destatis_user <- c(user="your-username", password="your-password", db="database-shortname")}
#' 
#' Alternatively, store the credentials on your computer using the \code{\link{save_credentials}} function. 
#' 
#' Available databases are regionalstatistik.de (shortname: "regio"), landesdatenbank.nrw.de ("nrw"), 
#' www-genesis.destatis.de ("de") and bildungsmonitoring.de ("bm"). 
#' 
#' 
#'
#' @name wiesbaden-package
#' 
#' @docType package
#' @aliases wiesbaden
#' @title Client to access the data from the Federal Statistical Office, Germany
#' @author Moritz Marbach \email{moritz.marbach@gess.ethz.ch}
#'
#' 
#' @import httr 
#' @import xml2
#' @importFrom keyring key_set_with_value key_list key_get
#' @importFrom stringr str_detect str_split str_replace_all str_trim
#' @importFrom readr read_csv read_csv2 read_fwf read_delim read_file locale cols col_character
#' @importFrom stringi stri_trans_general
#' @importFrom stats na.omit
#' @importFrom utils read.csv2
#' @importFrom jsonlite fromJSON toJSON
NULL

