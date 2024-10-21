glm_add=$1
name=$2
ofile=$3

# mkdir
mkdir ${ofile}
ofiles=${ofile}/${name}

# glm 2 ss
python /path_to/glm_2_ss.py $glm_add ${ofiles}/${name}.ss

# ss 2 ldsc
python /path_to/ss_2_ldsc.py ${ofiles}/${name}.ss ${ofiles}/${name}.ldsc

# ss 2 ldsc
python /path_to/ss_2_ldsc.py ${ofiles}/${name}.ss ${ofiles}/${name}.snplist