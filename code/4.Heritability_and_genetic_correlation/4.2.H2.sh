#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.2.H2.sh pheno1 /path_to/input

pheno_name=$1
input_path=$1

input_path=${input_path}/${pheno_name}

# munge 2 h2
/path_to/python2.7 \
/path_to/ldsc-master/ldsc.py \
--h2 ${input_path}/${pheno_name}.sumstats.gz \
--ref-ld-chr /path_to/eas_ldscores/ \
--w-ld-chr /path_to/LDSC/eas_ldscores/ \
--out ${input_path}/${pheno_name}.h2

