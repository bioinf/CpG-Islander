# Load installed makeCGI library
library(makeCGI)

# Set working directory. Create rawdata folder and put your FASTA files with "fa" extension there
setwd('~')

# Set up default parameters
.CGIoptions = CGIoptions()

# Specify that input is txt (*.fa)
.CGIoptions$rawdat.type="txt"
# Change species
.CGIoptions$species="Hsapiens"

#Start analysis
makeCGI(.CGIoptions)
