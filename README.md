# Provide soil organic carbon and biomass data

R package **mrorganic**, version **0.5.0**

[![CRAN status](https://www.r-pkg.org/badges/version/mrorganic)](https://cran.r-project.org/package=mrorganic)  [![R build status](https://github.com/tscheypidi/mrorganic/workflows/check/badge.svg)](https://github.com/tscheypidi/mrorganic/actions) [![codecov](https://codecov.io/gh/tscheypidi/mrorganic/branch/master/graph/badge.svg)](https://app.codecov.io/gh/tscheypidi/mrorganic) [![r-universe](https://pik-piam.r-universe.dev/badges/mrorganic)](https://pik-piam.r-universe.dev/builds)

## Purpose and Functionality

mrorganic supports downloading and preparing soil organic carbon
    and biomass data for further scientific work.


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

## Tutorial

The package comes with a vignette describing the basic functionality of the package and how to use it. You can load it with the following command (the package needs to be installed):

```r
vignette("mrorganic") # Generating SOC and biomass data with mrorganic
```

## Questions / Problems

In case of questions / problems please contact Jan Philipp Dietrich <dietrich@pik-potsdam.de>.

## Citation

To cite package **mrorganic** in publications use:

Dietrich J, Führlich P (2023). _mrorganic: Provide soil organic carbon and biomass data_. R package version 0.5.0, <https://github.com/tscheypidi/mrorganic>.

A BibTeX entry for LaTeX users is

 ```latex
@Manual{,
  title = {mrorganic: Provide soil organic carbon and biomass data},
  author = {Jan Philipp Dietrich and Pascal Führlich},
  year = {2023},
  note = {R package version 0.5.0},
  url = {https://github.com/tscheypidi/mrorganic},
}
```
