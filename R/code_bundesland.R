#' Transforms the name of a Bundesland into the Bundesland ID 
#'
#'
#' @param x string (or vector of strings) to be converted into ID
#' 
#' @details The first two digits of the 8 digit Amtlicher Gemeindeschlüssel (AGS) encode  
#' the Bundesland (Bundesland ID). This function converts the name of Bundesland into 
#' the Bundesland ID. 
#'  
#' @return a character vector of valid Bundesland ID
#'
#' @seealso \link{get_bundesland}
#'
#' @examples 
#'  \dontrun{
#'  
#'   code_bundesland( "NRW" )
#' 
#'  }
#' 
#' 
#' 
#' 
#' @export
code_bundesland <- function(string){
	code <- rep(NA,length(string))
	code <- ifelse(str_detect(string, "Sachsen|Saxony"), "14", code) 
	code <- ifelse(str_detect(string, "Schleswig.Holstein"), "01", code) 
	code <- ifelse(str_detect(string, "Hamburg"), "02", code) 
	code <- ifelse(str_detect(string, "Niedersachsen|Lower Saxony"), "03", code) 
	code <- ifelse(str_detect(string, "Bremen"), "04", code) 
	code <- ifelse(str_detect(string, "Nordrhein.Westfalen|NRW|North Rhine.Westphalia"), "05", code) 
	code <- ifelse(str_detect(string, "Hesse"), "06", code) 
	code <- ifelse(str_detect(string, "Rheinland.Pfalz|Rhineland.Palatinate"), "07", code) 
	code <- ifelse(str_detect(string, "Baden.W(ue|ü)rttemberg|BaWü"), "08", code) 
	code <- ifelse(str_detect(string, "Bayern|Bavaria"), "09", code) 
	code <- ifelse(str_detect(string, "Saarland"), "10", code) 
	code <- ifelse(str_detect(string, "Berlin"), "11", code) 
	code <- ifelse(str_detect(string, "Brandenburg"), "12", code) 
	code <- ifelse(str_detect(string, "Mecklenburg.Vorpommern|MeckPom"), "13", code) 
	code <- ifelse(str_detect(string, "Sachsen.Anhalt|Saxony.Anhalt"), "15", code) 
	code <- ifelse(str_detect(string, "Th(ue|ü)ringen|Thuringia"), "16", code) 
	return(code)
	}

