# Run this script to convert makeCGI results to BED and to create CGI plots
# Use "result" folder  create by makeCGI as the script argument
#
# To start script execution run 
#Rscript CpG2BED.R "makegci_directory/result"
# in the terminal
#
# To create plot make sure that ggplot2 is installed

#Clear environment
rm(list = ls())

#Define function for RDA to BED conversion
rda2bed <- function(rdafile, concat = F, verbose = F) {
  print(paste('Analyzing file:', rdafile))
  #Load file for processing
  load(rdafile)
  print(paste('Number of observations loaded for the current file:', nrow(cgi))) 
  
  bed <- data.frame(cgi$chr, cgi$start, cgi$end, cgi$length)
  if (concat) {
    filename = 'result.bed'
  } else {
    filename = paste(rdafile, '.bed', sep = '')
  }
  
  #Write bed file
  write.table(bed, file = filename, append = concat, 
              quote = F, sep = '\t', row.names = F, col.names = F)
  #In verbouse mode create additional table with full data
  if (verbose) {
    write.table(cgi, file = paste(filename, '.full'), append = concat, 
                quote = F, sep = '\t', row.names = F, col.names = T)
    createplot(cgi, rdafile)
  }
  
  #Print summary
  CGI <- nrow(cgi)
  GF <- findGF(cgi)
  
  print(paste(rdafile, 'HMM CGI:', CGI, 'Gardiner-Garden and Frommer:', GF))
}

#Create CGI plot 
createplot <- function(cgi, title) {
  library(ggplot2)
  #Create borders
  gccut <- data.frame(x=c(0, 1), y=c(0.5, 0.5))
  
  cgi$GardinerFrommer <- cgi$obsExp > 0.6 & cgi$pctGC > 0.5
  cgi$GFminLength <- cgi$length > 200
  
  #Plot Gardiner-Garden and Frommer compilant CGI (without length)
  p <- qplot(pctGC, obsExp, data=cgi,
             xlab = 'GC content', ylab = 'Observerd/Expected', 
             colour = GardinerFrommer, xlim=c(0.3, 0.9), ylim=c(0, 2.5)) 
  #Save to file
  ggsave(filename=paste(title, '.png', sep = ''), plot=p) 
  
  #Plot Gardiner-Garden and Frommer compilant CGI (length only)
  p1 <- qplot(length, data=cgi, geom="histogram", binwidth=50, colour = GFminLength)
  ggsave(filename=paste(title, '_length.png', sep = ''), plot=p1) 
  
  #Plot Gardiner-Garden and Frommer compilant CGI (with length)
  p <- qplot(pctGC, obsExp, data=cgi,
             xlab = 'GC content', ylab = 'Observerd/Expected', 
             colour = GardinerFrommer & GFminLength, xlim=c(0.3, 0.9), ylim=c(0, 2.5)) 
  #Save to file
  ggsave(filename=paste(title, 'GGF_length.png', sep = ''), plot=p) 
}

#Find number of CGI that conform to Gardiner-Garden and Frommer definition
findGF <- function(cgi) {
  GCandOE <- nrow(subset(cgi, obsExp > 0.6 & pctGC > 0.5 & length > 200))
  return (GCandOE)
}

#Separate CGI file by separate files by contig
splitcgi <- function(rdafile) {
  print(paste('Analyzing file:', rdafile))
  #Load file for processing
  load(rdafile)
  
  cgiall <- data.frame(cgi)
  
  contigs <- levels(cgiall$chr)
  for (contig in contigs) {
    cgi <- cgiall[cgiall$chr==contig,]
    save(cgi, file=paste(
      sub('.rda', '', rdafile, ignore.case = T), 
      contig,
      'rda',
      sep = '.'
    ))
  }  
}

##  EXECUTE SCRIPT  ##
#Get command line arguments and working directory from it
args <- commandArgs()

#Check arguments length and 
if (length(args) >= 6) {
  #Get data folder
  
  #CONFIGURATION
  datafolder <- args[6]
  #Or set datafolder manually
  #datafolder <- 'makecgi/results'  
  #CONFIGURATION END
  
  if (file.exists(datafolder)) {
    print(paste('Analyzing CGI results file in the folder', datafolder))
  } else {
    print(paste('Can\'t open the folder specified:', datafolder))
    q()
  }  
} else {
  print('Pease specify working directory name as the script argument')
  q()
}

#Get CGI result files in the folder
files <- list.files(path = datafolder, pattern = '^CGI.*\\.rda$')

setwd(datafolder)

#Perform conversion
for (file in files) {
  rda2bed(file, verbose = T)
}