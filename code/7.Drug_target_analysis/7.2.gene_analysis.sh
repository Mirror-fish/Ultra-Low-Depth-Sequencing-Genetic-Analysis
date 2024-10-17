#step2_Gene analysis with SNP p-values
magma=/path_to/magma

#use for SNP and pvalue, ncol for samplesize
$magma \
--bfile /path_to/g1000_eas \
--pval /path_to/pheno.ss use=4,14 ncol=10 \
--gene-annot /path_to/example_annotation.genes.annot \
--gene-model multi \
--out GWAS_pheno_example


