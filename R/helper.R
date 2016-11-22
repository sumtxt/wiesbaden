readstr_csv <- function(string,skip=0){
	con <- textConnection(string)
	tab <- read.csv2(con, header=FALSE, stringsAsFactors=FALSE, skip=skip)
	return(tab)
	}

set_user <- function(user=user, password=password){

	if ( !is.null(user) & !is.null(password) ) return(NULL)

	if ( is.null(user) | is.null(password) ) {
		if ( !is.null(destatis_user) ){
			user <- destatis_user['user']
			password <- destatis_user['password']
			return(NULL)
			} 
	} else {
		stop("User/Password missing")
	}

}
