# wiesbaden

# Version 1.2.8 (2022-12-17)

* New Parameter inhalte for retrieve_data 
* Revised help files to include tips on dealing with large tables 

# Version 1.2.6 (2022-02-14)

* Fixed bug in read_gv100() that let to an error when reading UTF-8 files
* Allow to save credentials for databases from Bavaria and Saxony-Anhalt

# Version 1.2.5 (2022-01-03)

* Add connection to databases from Bavaria and Saxony-Anhalt

# Version 1.2.4 (2021-03-15)

* Change to TestService_2010
* More options to supply sachmerkmal 
* Fixed bugs 

# Version 1.2.3 (2020-06-17)

* Fixed bug when using the regionalschluessel parameter in retrieve_data()
* Revised vignette. 


# Version 1.2.2 (2020-02-14)

* Allow to switch language between German and English. 
* Allow to supply sachmerkmal and sachschluessel as parameter 
* Revised the help files.

# Version 1.2.1 (2020-01-26)

* Fixed a bug that leads `keyring` to fail when trying to retrieve the credentials on a Windows machine.
* Fixed some bugs in the package documentation/vignette.
* Anticipating DESTATIS API changes in February, increase the default value to 25000 for the number of retrievable value labels via `retrieve_valuelabel()`.

# Version 1.2.0 (2019-10-14)

* Database usernames and passwords are now stored securely via keyring package instead of a file in the root directory. 

# Version 1.1.1 (2019-10-14)

* Allow to retrieve 2500 value labels when using `retrieve_valuelabel()` (instead of only 500)

# Version 1.1.0 (2019-10-13)

* Added a vignette and revised documentation for some functions.
* `read_header_genesis()` uses `stri_trans_general()` for non-ASCII character replacement 
* All `dplyr` dependency removed and reduced number of dependencies
* Code for `read_gv100()` rewritten using only base functions

# Version 1.0.0

* First release