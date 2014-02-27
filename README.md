# CpG-Islander

This script is designed for makeCGI package installation and execution.

The papers about CGI search using HMM can be found here:  
http://www.ncbi.nlm.nih.gov/pubmed/20212320  
http://www.ncbi.nlm.nih.gov/pubmed/19777308  

## Installation process

1. Install "BSgenome" and "Biostrings" Bioconductor packages (if you are in trouble see the instructions below)

2. Download and install makeCGI from the following page: http://rafalab.jhsph.edu/CGI/

You can install it via Tools/Install packages menu of RStudio or run the following commands

    makecgi_directory="changeme"
    setwd(makecgi_directory)
    install.packages("makeCGI_1.2.tar.gz", repos = NULL, type = "source")

## Installing Bioconductor packages

### IF YOUR INTERNET CONNECTION USES PROXY

Replace username, password, proxy ip and port and run following in the terminal:

    export http_proxy=http://username:password@proxy_address:proxy_port/
    export HTTP_PROXY=http://username:password@proxy_address:proxy_port/

If you are using RStudio then restart it

Set proxy and check it

    Sys.setenv(http_proxy="http://username:password@proxy_address:proxy_port/")

Check that proxy set up succeed

    Sys.getenv("http_proxy")

### INSTALL BIOCONDUCTOR PACKAGES

    source("http://bioconductor.org/biocLite.R")
    biocLite()

Install makeCGI dependencies

    biocLite("BSgenome")
    biocLite("Biostrings")
