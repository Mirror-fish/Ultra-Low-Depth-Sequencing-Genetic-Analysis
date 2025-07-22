# encoding=utf-8
# python3

# download the dbSNP reference files of each chromsomes from:
# https://ftp.ncbi.nih.gov/snp/organisms/human_9606_b151_GRCh38p7/chr_rpts/

# Please check the input and output and make corresponding modifications before running the code

# directory to the download files
input_path = '/path_to/Supporting_data/dbSNP/'

outfile = '/path_to/4.Heritability_and_genetic_correlation_analysis/LDSC_ref/chrpos.rs.txt'

##########################################################
######################## work ############################
##########################################################

import pandas as pd
import numpy as np
import os

chromosomes = os.listdir(input_path)

all_chrom = []

for file in chromosomes:

	inputfile= input_path + file

	dbSNP_data = pd.read_csv(inputfile ,sep='\t',skiprows=7,header=None)[[0,6,11]]
	
	dbSNP_data = dbSNP_data.replace(' ',np.nan).dropna()
	
	dbSNP_data.columns = ['rs#','chr#','pos']
	
	dbSNP_data['rsID'] = 'rs' + dbSNP_data['rs#'].astype(str)
	dbSNP_data['chrpos'] = 'chr' + dbSNP_data['chr#'].astype(str) + ':' + dbSNP_data['pos'].astype(str)
	
	dbSNP_data = dbSNP_data.drop_duplicates(subset='rsID').drop_duplicates(subset='chrpos')

	all_chrom.append(dbSNP_data)

# Output
pd.concat(all_chrom)[['rsID','chrpos']].to_csv(outfile,sep='\t',index=False)

