#Please note that this file requires external parameter
#After specify the arguments, you can run this code as:
#bash 4.1.Conversion.sh /path_to/pheno1.add pheno1 /output_folder

glm_add=$1
name=$2
ofile=$3

# mkdir
mkdir ${ofile}
ofiles=${ofile}/${name}

# glm 2 ss
/path_to/python ./glm_2_ss.py $glm_add ${ofiles}/${name}.ss

# ss 2 ldsc
/path_to/python ./ss_2_ldsc.py ${ofiles}/${name}.ss ${ofiles}/${name}.ldsc

