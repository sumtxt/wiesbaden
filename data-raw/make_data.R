library(readr)

# The definition of the GV100 file (width of fields and keys)
# to made made available inside the package environment only

# GV100AD 
##########

GV100ADfwf <- read_csv("./data-raw/GV100ADfwf.csv")
GV100ADkey <- read_csv("./data-raw/GV100ADkey.csv")

GV100ADkey <- GV100ADkey %>% mutate(typ=factor(typ))

GV100ADcol <- cols(
  .default = col_character(),
  satzart = col_integer(),
 	gebietsstand = col_date(format="%Y%m%d"),
 	schluessel = col_integer(),
 	flaeche = col_integer(),
 	bev = col_integer(),
 	bev_m = col_integer()
	)

GV100NADfwf <- read_csv("./data-raw/GV100NADfwf.csv")

GV100NADcol <- cols(
  .default = col_character(),
	gebietsstand = col_date(format="%Y%m%d"),
#	regionsgrundtyp_stand = col_date(),
#	kreistyp_stand = col_date(),
#	arbeitsmarktregion_stand = col_date(),
#	raumordnungsregion_stand = col_date(),
#	regionstyp_stand = col_date(),
#	planungsregion_stand = col_date(),
#	gemeindetypneu_stand = col_date(),
#	verdichtungsraeume_stand = col_date(),
#	verstaedterung_stand = col_date(),
#	zentralitaet_stand = col_date(),
#	reisegebiet_stand = col_date(),
#	bik_stand = col_date(),
	biktyp5 = col_integer(),
	bikstrukturtyp5 = col_integer(),
	bikgroesse7 = col_integer(),
	bikgroesse10= col_integer(),
	regionsgrundtyp = col_integer(),
	kreistyp = col_integer()
	)

gv100 <- list('ad'=list(fwf=GV100ADfwf, key=GV100ADkey, col=GV100ADcol),
							'nad'=list(fwf=GV100NADfwf, col=GV100NADcol))

devtools::use_data(gv100, overwrite=TRUE, internal=TRUE)
