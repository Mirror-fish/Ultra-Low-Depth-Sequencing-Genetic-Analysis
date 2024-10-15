#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.2.H2.sh pheno1 /path_to/input

pheno_name=$1
input_path=$1

input_path=${input_path}/${pheno_name}

# get_size
sample_size=$(awk 'NR==2{print $2}' ${input_path}/${pheno_name}.ldsc)
echo "${pheno_name}, sample_size: ${sample_size}"

# ldsc 2 munge
./envs/python27/bin/python2.7 \
./software/ldsc-master/munge_sumstats.py \
--sumstats ${input_path}/${pheno_name}.ldsc \
--N $sample_size \
--out ${input_path}/${pheno_name} \
--merge-alleles /path_to/gwas.snplist #extract from summary statistics 

# munge 2 h2
./envs/python27/bin/python2.7 \
./software/ldsc-master/ldsc.py \
--h2 ${input_path}/${pheno_name}.sumstats.gz \
--ref-ld-chr /path_to/eas_ldscores/ \
--w-ld-chr /path_to/LDSC/eas_ldscores/ \
--out ${input_path}/${pheno_name}.h2

