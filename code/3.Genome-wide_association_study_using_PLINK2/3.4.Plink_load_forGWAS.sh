#Specify the arguments before execute the code
#path for plink2
plink2=/path_to/plink2

#the output vcf file of 2.3.Merge.sh
merge_out=/path_to/2.Genotype_imputation_using_STITCH/final/STITCH.vcf.gz

$plink2 \
--freq \
--hardy \
--make-pgen 'vzs' \
--set-all-var-ids chr@:# \
--vcf $merge_out dosage=DS \
--out /path_to/3.Genome-wide_association_study_using_PLINK2/final/STITCH

