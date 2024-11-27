library(qqman)

gwas_result <- read.table('STITCH.pheno_1.pheno1.glm.linear.add')

manhattan(gwas_result, chr = `#CHROM`, bp = 'POS', p = 'P', snp = 'ID')
qq(gwas_result$P)

