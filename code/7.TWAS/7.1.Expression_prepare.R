library(RSQLite)
library(stringr)
library(data.table)
library(TwoSampleMR)
#### take an example of one tissue "ctimp_Adipose_Subcutaneous.db"
#### find eQTLs on gene ESR1

#load the required db file we downloaded
filename <- paste0("/path_to/ctimp_Adipose_Subcutaneous.db")

#formatting
sqlite.driver <- dbDriver("SQLite")
db <- dbConnect(sqlite.driver,dbname = filename)
dbListTables(db)
mytable <- dbReadTable(db,"weights")
mytable[c('chr', 'pos','allele')] <- str_split_fixed(mytable$varID, '_', 3)

#Restrict the file to the ESR1 gene we focused on
esr1 <- mytable[mytable$chr == "chr6" & mytable$pos > 151640495 & mytable$pos < 152153274,]

#clump eQTLs
colnames(esr1)[c(2,7,8)] <- c("SNP","chr_name","chrom_start")
esr1$chr_name  <-  gsub("chr","",esr1$chr_name)

clp <- clump_data(esr1, clump_kb = 10000, clump_r2 = 0.2, clump_p1 = 1, clump_p2 = 1, pop = "EUR")
colnames(clp)[c(2,7,8)] <- c("rsid","chr","pos")

#Output the formatted file
write.table(clp,paste0("ctimp_Adipose_Subcutaneous.db.txt"),row.names = F,quote = F,col.names = T)
