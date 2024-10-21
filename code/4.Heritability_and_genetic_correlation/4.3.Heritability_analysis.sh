#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.3.Heritability_analysis.sh pheno1 /path_to/input

pheno_name=$1
input_path=$2

ofiles=$3

# get_size
sample_size=$(awk 'NR==2{print $2}' ${input_path}/${pheno_name}.ldsc)
echo "${pheno_name}, sample_size: ${sample_size}"

# ldsc 2 munge
/path_to/python2.7 \
/path_to/ldsc-master/munge_sumstats.py \
--sumstats ${input_path}/${pheno_name}.ldsc \
--N $sample_size \
--out ${ofiles}/${name} \
--merge-alleles ${input_path}/${pheno_name}.snplist

# munge 2 h2
/path_to/python2.7 \
/path_to/ldsc-master/ldsc.py \
--h2 ${ofiles}/${name}.sumstats.gz \
--ref-ld-chr /path_to/LDSC/eas_ldscores/ \
--w-ld-chr /path_to/LDSC/eas_ldscores/ \
--out ${ofiles}/${name}.h2
