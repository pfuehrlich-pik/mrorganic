# madrat based MAgPIE Input Data Library

R package **mrorganic**, version **0.0.3**

[![CRAN status](https://www.r-pkg.org/badges/version/mrorganic)](https://cran.r-project.org/package=mrorganic)  [![R build status](https://github.com/tscheypidi/mrorganic/workflows/check/badge.svg)](https://github.com/tscheypidi/mrorganic/actions) [![codecov](https://codecov.io/gh/tscheypidi/mrorganic/branch/master/graph/badge.svg)](https://app.codecov.io/gh/tscheypidi/mrorganic) 

## Purpose and Functionality

Provides functions for MAgPIE country and cellular input data generation.


## Installation

For installation of the most recent package version an additional repository has to be added in R:

```r
options(repos = c(CRAN = "@CRAN@", pik = "https://rse.pik-potsdam.de/r/packages"))
```
The additional repository can be made available permanently by adding the line above to a file called `.Rprofile` stored in the home folder of your system (`Sys.glob("~")` in R returns the home directory).

After that the most recent version of the package can be installed using `install.packages`:

```r 
install.packages("mrorganic")
```

Package updates can be installed using `update.packages` (make sure that the additional repository has been added before running that command):

```r 
update.packages()
```

## Questions / Problems

In case of questions / problems please contact Jan Philipp Dietrich <dietrich@pik-potsdam.de>.

## Citation

To cite package **mrorganic** in publications use:

Dietrich J (2022). _mrorganic: madrat based MAgPIE Input Data Library_. R package version 0.0.3.

A BibTeX entry for LaTeX users is

 ```latex
@Manual{,
  title = {mrorganic: madrat based MAgPIE Input Data Library},
  author = {Jan Philipp Dietrich},
  year = {2022},
  note = {R package version 0.0.3},
}
```
