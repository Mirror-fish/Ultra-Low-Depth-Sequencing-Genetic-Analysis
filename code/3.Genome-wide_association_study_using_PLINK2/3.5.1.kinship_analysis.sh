#Specify the arguments before execute the code
#path for plink2
plink2=/path_to/plink2

$plink2 \
--pfile /path_to/GWAS_analysis/final/STITCH 'vzs' \
--read-freq /path_to/GWAS_analysis/final/STITCH.afreq \
--make-king triangle bin\
--out /path_to/GWAS_analysis/final/kinship