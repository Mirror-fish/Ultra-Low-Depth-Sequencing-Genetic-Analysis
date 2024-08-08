#Specify the arguments before execute the code
#path for plink2
plink2=/path_to/plink2

#the output vcf file of 3.2.Merge.sh
merge_out=/path_to/3.GWAS_analysis/final/BaseVarC.vcf.gz

$plink2 \
--pca 5 \
--vcf $merge_out \
--out /path_to/3.GWAS_analysis/final/GWAS_pca_5
