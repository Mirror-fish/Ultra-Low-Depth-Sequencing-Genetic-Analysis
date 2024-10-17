#Specify the arguments before execute the code
#path for plink2
plink2=/path_to/plink2

#the output vcf file of 3.2.Merge.sh
merge_out=/path_to/STITCH_analysis/final/STITCH.vcf.gz

$plink2 \
--freq \
--hardy \
--make-pgen 'vzs' \
--set-all-var-ids chr@:# \
--vcf $merge_out dosage=DS \
--out /path_to/GWAS_analysis/final/STITCH

