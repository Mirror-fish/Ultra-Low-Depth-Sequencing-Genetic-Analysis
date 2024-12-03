library(data.table)
library(ggplot2)

#load the required files
#the interaction file downloaded from DGIdb 
interact <- fread('/path_to/Required_reference_data/magma/interactions.tsv')
#the ATC summary file
db <- fread('/path_to/Required_reference_data/magma/atc_cata.txt')
#the output gsa.out file produced by step 3
file_lines <- readLines('GWAS_pheno_example.drug.gsa.out')

############################### main ######################################
#matching the drug names and formatting
db <- db[apply(db, 1, function(x) nchar(x["ATCCode"]) > 4), ]
db$ATC_class <- gsub('([A-Z][0-9][0-9][A-Z]).*', '\\1',db$ATCCode)

db$Name <- tolower(db$Name)
interact$drug_claim_name <- tolower(interact$drug_claim_name)

db1 <- db[db$Name %in% interact$drug_claim_name,]
db1$drug_id <- interact$drug_concept_id[match(db1$Name, interact$drug_claim_name)]
db1 <- db1[!(db1$drug_id == "") ,]

ff <- as.data.frame(table(db1$ATC_class))
ff <- ff[ff$Freq >= 10,]

db_f <- db1[db1$ATC_class %in% ff$Var1,]

new_file_lines <- file_lines[-(1:4)]
writeLines(new_file_lines, 'formatted_drug.gsa.out')
aso <- fread('formatted_drug.gsa.out')

db_f$association <- aso$P[match(db_f$drug_id, aso$VARIABLE)]
db_f$association <- -log10(db_f$association)
aso$association <- -log10(as.numeric(aso$P))

#AUC calculation
class=as.character(ff$Var1)

pp <- data.frame(ATC_class = NA, AUC = NA, P = NA)

for (i in class) {
  enr = db_f$association[db_f$ATC_class == i]
  enrid = db_f$drug_id[db_f$ATC_class == i]
  other = aso$association[!aso$VARIABLE %in% enrid]
  
  #print(wilcox.test(enr, other))
  
  U = as.numeric(wilcox.test(enr, other)$statistic)
  AUC = (U/(length(enr)*length(other)))
  P = (wilcox.test(enr, other)$p.value)
  OUT = data.frame (ATC_class = i,AUC = AUC, P = P)
  
  pp <- rbind(pp,OUT)
}

pp <- na.omit(pp)
pp$P <- -log10(pp$P)

#ploting the AUC results
pdf('out.pdf',height=20,width=10)

ggplot(pp, aes(x=ATC_class,y=AUC,fill=P))+
  geom_bar(stat = "identity") + 
  scale_fill_gradient(low = "#B8E2A1", high = "#D63E50") +
  theme(text=element_text(size=25), 
        axis.text=element_text(size=17),
        axis.text.x=element_text(angle=90,hjust=1,size=20))+ 
  geom_text(aes(label = formatC(P,format="E",digits = 2)), hjust = 0,size=5)+
  xlab("")+ylab("")+
  scale_y_continuous(limits = c(0,0.9))+
  coord_flip()+
  ggtitle('GDM AUC')

dev.off()

