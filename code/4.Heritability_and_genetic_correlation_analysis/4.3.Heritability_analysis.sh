#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.3.Heritability_analysis.sh pheno1 /path_to/input

#Python version2
Python=/path_to/Python2
#You can check https://github.com/bulik/ldsc?tab=readme-ov-file#where-can-i-get-ld-scores
#for LD reference score files
LD_ref_path=/path_to/Supporting_data/LDSC/
#ldsc codes, can be found after LDSC installation
munge_sumstats=/path_to/ldsc-master/munge_sumstats.py
ldsc=/path_to/ldsc-master/ldsc.py

pheno_name=$1
input_path=$2

ofiles=$3

################ work ##################
# get_size
sample_size=$(awk 'NR==2{print $2}' ${input_path}/${pheno_name}.ldsc)
echo "${pheno_name}, sample_size: ${sample_size}"

# ldsc 2 munge
$Python \
$munge_sumstats \
--sumstats ${input_path}/${pheno_name}.ldsc \
--N $sample_size \
--out ${ofiles}/${name} \
--merge-alleles ${input_path}/${pheno_name}.snplist

# munge 2 h2
$Python \
$ldsc \
--h2 ${ofiles}/${name}.sumstats.gz \
--ref-ld-chr $LD_ref_path \
--w-ld-chr $LD_ref_path \
--out ${ofiles}/${name}.h2
