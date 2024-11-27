#Specify the arguments before excute the code related
#path for bcftools
bcftools=/path_to/bcftools

$bcftools concat \
-f /path_to/2.Genotype_imputation_using_STITCH/completed_vcf.list \
-Oz \
--threads 4 \
-o /path_to/2.Genotype_imputation_using_STITCH/final/STITCH.vcf.gz

