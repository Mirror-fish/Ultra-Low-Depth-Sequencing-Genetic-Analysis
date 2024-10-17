#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.3.Genetic_correlation.sh pheno1 pheno1 /path_to/input

pheno_name1=$1
pheno_name2=$1
input_path=$1

input_path=${input_path}/${pheno_name}

#genetic correlation
./envs/python27/bin/python2.7 \
./software/ldsc-master/ldsc.py \
--rg ${pheno_name1}.sumstats.gz,${pheno_name2}.sumstats.gz \
--ref-ld-chr /path_to/eas_ldscores/ \
--w-ld-chr /path_to/eas_ldscores/ \
--out ${input_path}/${pheno_name1}_${pheno_name2}

