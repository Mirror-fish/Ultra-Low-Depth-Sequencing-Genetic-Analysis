Python=/path_to/Python3
#plink afreq and chr_pos reference files
#path for plink2
plink2=/path_to/plink2
#the input vcf file produced by 'Genotype imputation using STITCH'
stitch=/path_to/2.Genotype_imputation_using_STITCH/final/STITCH.vcf.gz
freq_out=/path_to/4.Heritability_and_genetic_correlation_analysis/LDSC_ref/STITCH_out

#afreq
$plink2 \
--freq \
--vcf $stitch \
--out $freq_out

#chr_pos reference files
$Python /path_to/4.Heritability_and_genetic_correlation_analysis/chrpos_2_rs.py
