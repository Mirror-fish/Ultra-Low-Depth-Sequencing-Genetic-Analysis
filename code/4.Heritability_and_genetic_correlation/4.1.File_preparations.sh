#file prepare
#plink afreq and chr_pos reference files
#path for plink2
plink2=/path_to/plink2
#the input vcf file produced by 'Genotype imputation using STITCH'
stitch_out=/path_to/STITCH.vcf.gz

#afreq
$plink2 \
--freq \
--vcf $stitch_out \
--out /path_to/STITCH_out

#chr_pos reference files
python /path_to/chrpos_2_rs.py
