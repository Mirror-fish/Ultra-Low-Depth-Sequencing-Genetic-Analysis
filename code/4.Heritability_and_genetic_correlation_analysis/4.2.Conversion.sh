#Python version3
Python=/path_to/Python3
#The python codes provided in github
glm_2_ss=/path_to/4.Heritability_and_genetic_correlation_analysis/glm_2_ss.py
ss_2_ldsc=/path_to/4.Heritability_and_genetic_correlation_analysis/ss_2_ldsc.py
ss_2_snplist=/path_to/4.Heritability_and_genetic_correlation_analysis/ss_2_snplist.py

glm_add=$1
name=$2
ofile=$3

# mkdir
mkdir ${ofile}
ofiles=${ofile}/${name}

# glm 2 ss
$Python $glm_2_ss $glm_add ${ofiles}/${name}.ss

# ss 2 ldsc
$Python $ss_2_ldsc ${ofiles}/${name}.ss ${ofiles}/${name}.ldsc

# ss 2 ldsc
$Python $ss_2_snplist ${ofiles}/${name}.ss ${ofiles}/${name}.snplist
