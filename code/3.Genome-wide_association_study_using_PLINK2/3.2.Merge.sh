#Specify the arguments before excute the code related
#path for bcftools
bcftools=/path_to/bcftools

$bcftools concat \
-f /path_to/3.Genome-wide_association_study_using_PLINK2/completed_BaseVarC_vcf.list \
-Oz \
-o /path_to/3.Genome-wide_association_study_using_PLINK2/final/BaseVarC.vcf.gz


