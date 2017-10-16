# tutoRIal
R stuff

## links
- [Creating and Building R packages](https://support.rstudio.com/hc/en-us/articles/200486488?version=1.1.383&mode=desktop)
  - Or use devtools::create()

- [Namespace](http://r-pkgs.had.co.nz/namespace.html#namespace)

- [Compiled code](http://r-pkgs.had.co.nz/src.html#src)
  - In long-running loops, regularly run Rcpp::checkUserInterrupt(). This aborts your C++ if the user has pressed Ctrl + C or Escape in R.
  - [Portable C++ For R](http://journal.r-project.org/archive/2011-2/RJournal_2011-2_Plummer.pdf)

