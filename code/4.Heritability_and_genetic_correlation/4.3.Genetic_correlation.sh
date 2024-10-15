#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.3.Genetic_correlation.sh pheno1 pheno1 /path_to/input

pheno_name1=$1
pheno_name2=$1
input_path=$1

input_path=${input_path}/${pheno_name}

# get_size
sample_size=$(awk 'NR==2{print $2}' ${input_path}/${pheno_name}.ldsc)
echo "${pheno_name}, sample_size: ${sample_size}"

# ldsc 2 munge
./envs/python27/bin/python2.7 \
./software/ldsc-master/munge_sumstats.py \
--sumstats ${input_path}/${pheno_name1}.ldsc \
--N $sample_size \
--out ${input_path}/${pheno_name1} \
--merge-alleles /path_to/gwas.snplist #extract from summary statistics 

./envs/python27/bin/python2.7 \
./software/ldsc-master/munge_sumstats.py \
--sumstats ${input_path}/${pheno_name2}.ldsc \
--N $sample_size \
--out ${input_path}/${pheno_name2} \
--merge-alleles /path_to/gwas.snplist #extract from summary statistics 

#genetic correlation
./envs/python27/bin/python2.7 \
./software/ldsc-master/ldsc.py \
--rg ${pheno_name1}.sumstats.gz,${pheno_name2}.sumstats.gz \
--ref-ld-chr /path_to/eas_ldscores/ \
--w-ld-chr /path_to/eas_ldscores/ \
--out ${input_path}/${pheno_name1}_${pheno_name2}

