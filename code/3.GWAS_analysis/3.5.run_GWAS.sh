#Specify the arguments before execute the code
#path for plink2
plink2=/path_to/plink2

$plink2 \
--pfile /path_to/GWAS_analysis/final/STITCH 'vzs' \
--read-freq /path_to/GWAS_analysis/final/STITCH.afreq \
--glm \
--maf 0.05 \
--hwe 1e-6 \
--geno 0.1 dosage \
--pheno ./phenotype_genaral/pheno.csv \
--pheno-name pheno1 \
--pheno-quantile-normalize \
--covar /path_to/GWAS_analysis/final/GWAS_pca_5.eigenvec \
--covar-variance-standardize \
--out /path_to/GWAS_analysis/final/STITCH.pheno_1

$plink2 \
--pfile /path_to/GWAS_analysis/final/STITCH 'vzs' \
--read-freq /path_to/GWAS_analysis/final/STITCH.afreq \
--glm \
--maf 0.05 \
--hwe 1e-6 \
--geno 0.1 dosage \
--pheno ./phenotype_genaral/pheno.csv \
--pheno-name pheno2 \
--pheno-quantile-normalize \
--covar /path_to/GWAS_analysis/final/GWAS_pca_5.eigenvec \
--covar-variance-standardize \
--out /path_to/GWAS_analysis/final/STITCH.pheno_2

for i in `ls /path_to/GWAS_analysis/final/*.linear`; do head $i -n1 >> $i.add && grep 'ADD' $i >> $i.add ; done
for i in `ls /path_to/GWAS_analysis/final/*.logistic.hybrid`; do head $i -n1 >> $i.add && grep 'ADD' $i >> $i.add ; done



