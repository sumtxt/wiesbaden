## Test environments
* local OS X install, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a resubmitted (new) release.
* I fixed everything except: 

	* "If there are references describing the methods in your package, please add these in the description field of your DESCRIPTION file in the form..." : There is no reference that could be included 

	* All examples wrapped in \dontrun{} as all functions require personal login information. 
