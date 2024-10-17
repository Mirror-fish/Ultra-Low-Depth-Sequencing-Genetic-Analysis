#Specify the arguments before excute the code related
#path for bcftools
bcftools=/path_to/bcftools

$bcftools concat \
-f /path_to/GWAS_analysis/completed_BaseVarC_vcf.list \
-Oz \
-o /path_to/GWAS_analysis/final/BaseVarC.vcf.gz


