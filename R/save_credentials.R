#' Saves database credentials 
#'
#' \code{save_credentials} saves a set of database credentials using the \code{keyring} package. 
#'
#' @param db database name, either 'nrw', 'regio', 'de' or 'bm'. 
#' @param user your user name. 
#' @param password your password. 
#'   
#' @details  
#'  User/password are stored in Keychain on macOS, Credential Store on Windows or Secret Service API on Linux. 
#'  If a user/password pair for a database already exists, it is silently replaced with the new pair.  
#' 
#' @seealso \code{\link{wiesbaden}}, \code{\link{keyring}} 
#'
#' 
#' 
#' @export
save_credentials <- function(db, user, password){
	if ( !(db %in% c("nrw", "regio", "de", "bm")) ) stop(paste("Database '", db, "' unknown.",sep=""))
	if (db=='regio'){
		key_set_with_value("regionalstatistik", username=user, password=password)
		message("Successfully added credentials.")
	} else if (db=='nrw'){
		key_set_with_value("landesdatenbank-nrw", username=user, password=password)
		message("Successfully added credentials.")
	} else if (db=='bm'){
		key_set_with_value("bildungsmonitoring", username=user, password=password)
		message("Successfully added credentials.")
	}	else if (db=='de'){
		key_set_with_value("destatis", username=user, password=password)
		message("Successfully saved credentials.")
	}	
	}

