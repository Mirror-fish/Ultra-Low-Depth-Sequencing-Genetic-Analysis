#Specify the arguments before excute the code related
#path for bcftools
bcftools=/path_to/bcftools

$bcftools concat \
-f /path_to/3.GWAS_analysis/completed_BaseVarC_vcf.list \
-Oz \
-o /path_to/3.GWAS_analysis/final/BaseVarC.vcf.gz


