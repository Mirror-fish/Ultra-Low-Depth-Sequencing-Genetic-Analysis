#step2_Gene analysis with SNP p-values
magma=/path_to/magma
g1000=/path_to/Required_reference_data/magma/g1000_eas
#the output of 7.1.MAGMA_annotation.sh
genes=/path_to/example_annotation.genes.annot
#ss file
Phenotype=/path_to/pheno.ss

#use for SNP and pvalue, ncol for samplesize
$magma \
--bfile $g1000 \
--pval $Phenotype use=4,14 ncol=10 \
--gene-annot $genes \
--gene-model multi \
--out GWAS_pheno_example
