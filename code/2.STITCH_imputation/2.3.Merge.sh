#Specify the arguments before excute the code related
#path for bcftools
bcftools=/path_to/bcftools

$bcftools concat \
-f /path_to/STITCH_analysis/completed_vcf.list \
-Oz \
-o /path_to/STITCH_analysis/final/STITCH.vcf.gz

