#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.4.Genetic_correlation.sh pheno1 pheno2 /path_to/input

#Python version2
Python=/path_to/Python2
#You can check https://github.com/bulik/ldsc?tab=readme-ov-file#where-can-i-get-ld-scores
#for LD reference score files
LD_ref_path=/path_to/Supporting_data/LDSC/
#ldsc codes, can be found after LDSC installation
ldsc=/path_to/ldsc-master/ldsc.py

pheno_name1=$1
pheno_name2=$2
input_path=$3
ofiles=$4

################ work ##################
#genetic correlation
$Python \
$ldsc \
--rg ${input_path}/${pheno_name1}.sumstats.gz,${input_path}/${pheno_name2}.sumstats.gz \
--ref-ld-chr $LD_ref_path \
--w-ld-chr $LD_ref_path \
--out ${ofiles}/${pheno_name1}_${pheno_name2}
