#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.4.Genetic_correlation.sh pheno1 pheno2 /path_to/input

pheno_name1=$1
pheno_name2=$2
input_path=$3
ofiles=$4

#genetic correlation
./envs/python27/bin/python2.7 \
./software/ldsc-master/ldsc.py \
--rg ${input_path}/${pheno_name1}.sumstats.gz,${input_path}/${pheno_name2}.sumstats.gz \
--ref-ld-chr /path_to/eas_ldscores/ \
--w-ld-chr /path_to/eas_ldscores/ \
--out ${ofiles}/${pheno_name1}_${pheno_name2}

