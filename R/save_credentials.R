#' Saves database credentials in home folder (only for Linux/Mac)
#'
#' \code{save_credentials} saves a set of database credentials to \code{'~/.genesis.json'} to ease package usage. 
#'
#' @param db database name, either 'nrw', 'regio' or 'de'. 
#' @param user user name. 
#' @param password password. 
#' @param append add credentials to file (default) or overwrite entire file? 
#'   
#' @details  
#'  Attention, user/password are stored in an unencrypted file in \code{'~/.genesis.json'}. 
#'  
#' @return 
#'
#' @seealso \code{\link{wiesbaden}} 
#'
#' 
#' 
#' @export
save_credentials <- function(db, user, password, append=TRUE){
	if ( .Platform['OS.type'] != 'unix') stop("Saving credentials only works for Mac and Linux platforms.")
	if ( !(db %in% c("nrw", "regio", "de")) ) stop(paste("Database '", db, "' unknown.",sep=""))
	new <- data.frame(name=db, user=user, password=password)
 	if ( file.exists('~/.genesis.json') & append==TRUE ){
		cred <- fromJSON(read_file('~/.genesis.json'))
		if ( nrow(cred)== 0 ) stop("Error in retrieving credentials from ~/.genesis.json")
		if ( db %in% cred$name ) stop(paste("Credentials for '", db, "' already saved.",sep=""))
		cred <- rbind(cred,new)
		cred <- toJSON(cred)
	} else {
		cred <- toJSON(new)
	}
	write(cred, "~/.genesis.json")
	if (append==TRUE) { cat("Successfully added credentials.\n") } 
	else { cat("Successfully saved credentials.\n") } 
	}

