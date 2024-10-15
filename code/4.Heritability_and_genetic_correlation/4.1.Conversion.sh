glm_add=$1
name=$2
ofile=$3

# mkdir
mkdir ${ofile}
ofiles=${ofile}/${name}

# glm 2 ss
/share/app/python/3.8.6/bin/python ./toolset/glm_2_ss.py $glm_add ${ofiles}/${name}.ss

# ss 2 ldsc
/share/app/python/3.8.6/bin/python ./toolset/ss_2_ldsc.py ${ofiles}/${name}.ss ${ofiles}/${name}.ldsc

