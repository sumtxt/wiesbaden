# wiesbaden

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