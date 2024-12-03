library(RSQLite)
library(stringr)
library(data.table)

#### take an example of one tissue "ctimp_Adipose_Subcutaneous.db"
#### find eQTLs on gene ESR1
############# make inference on causal effects

##disease
gdm <- as.data.frame(fread("pheno_quantitative.csv",header=T))
##indiviual-level genotype matrix on ESR1
traw <- as.data.frame(fread("ESR1.traw",header = T)) 
#the formatted expression data
eqtl <- as.data.frame(fread(paste0("ctimp_Adipose_Subcutaneous.db.txt"),header = T))

#main analysis
snp <- intersect(eqtl$pos, traw$POS)

subeqtl <- eqtl[match(snp,eqtl$pos),]
subtraw <- traw[match(snp,traw$POS),]
print(identical(subeqtl$ref_allele,subtraw$COUNTED))

subeqtl[which(subeqtl$ref_allele!=subtraw$COUNTED),"weight"] <- -subeqtl[which(subeqtl$ref_allele!=subtraw$COUNTED),"weight"]

prs <- t(subtraw[,-c(1:6)]) %*% (subeqtl$weight)

## disease
smp <- intersect(row.names(prs),paste0("0_",gdm$IID))

subprs <- prs[match(smp,row.names(prs)),]
subgdm <- gdm[match(smp,paste0("0_",gdm$IID)),]

#outcome
out <- summary(glm(subgdm$OGLU~subprs,family = "gaussian"))$coefficients
pv <- out[2,4]