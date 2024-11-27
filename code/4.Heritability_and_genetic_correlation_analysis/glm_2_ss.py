#!/usr/bin/env python
# coding: utf-8
# lilinxuan@genomics.cn
# using: python glm_2_ss.py ifile.linear.add ifile.afreq [ofile.ss]
# v1.2 add gene annotation
#outputs of the previous step
index = pd.read_csv('/path_to/4.Heritability_and_genetic_correlation_analysis/LDSC_ref/chrpos.rs.txt',sep='\t')
freqfile = '/path_to/4.Heritability_and_genetic_correlation_analysis/LDSC_ref/STITCH_out.afreq'

##########################################################
######################## work ############################
##########################################################
import pandas as pd
import numpy as np
import re
import sys
import gzip
import linecache as lc

ifile = sys.argv[1]

try:
    opath = sys.argv[2]
except:
    opath = ifile + '.ss'

data = pd.read_csv(ifile,sep='\t',dtype=str)

try:
    triat,method = re.findall('.+\.([\w%-]+)\.glm\.(\w+).*',ifile)[0]
except IndexError:
    triat = 'unknown'
    if 'OR' in data.columns:
        method = 'logistic'
    else:
        method = 'linear'

if method not in ['linear','logistic']:
    raise ValueError('Invalid glm method: '+method)

freq = pd.read_csv(freqfile,sep='\t',dtype=str)
freq = freq.set_index('ID')

data['A1_is_ALT'] = data['A1'] == data['ID'].map(freq['ALT'])
data['ALT_FREQS'] = data['ID'].map(freq['ALT_FREQS'])

data['A1_FREQS'] = 1-data['A1_is_ALT']+(2*data['A1_is_ALT']-1)*data['ALT_FREQS'].astype('float')

data['A2'] = pd.concat([data[data['A1_is_ALT']]['REF'],data[data['A1_is_ALT']==False]['ALT']])

data['TraitName'] = triat
#data['TraitName2'] = triat

data['CHROM'] = data['ID'].map(lambda x:x.split(':')[0])
data['POS'] = data['ID'].map(lambda x:x.split(':')[1])

#replace_rs

# 读取chrpos和rsID的对应关系

chrpos_2_rs = index.set_index('chrpos')['rsID']

# 假定原来的chrpos，位于ID列

data['SNP'] = data['ID'].map(chrpos_2_rs)
data['SNP'].fillna('.')

# output

colname = ['trait','chr','pos','SNP','other_allele','effect_allele','eaf','samplesize','beta','se','zsores','pvalue']

if method == 'logistic':
    data['BETA']=np.log(data['OR'].astype(np.float64))
    ofile = data[['TraitName','CHROM','POS','SNP','A2','A1','A1_FREQS','OBS_CT','BETA','LOG(OR)_SE','Z_STAT','P']].copy()
else:
    ofile = data[['TraitName','CHROM','POS','SNP','A2','A1','A1_FREQS','OBS_CT','BETA','SE','T_STAT','P']].copy()
ofile.columns = colname

from pathlib import Path
print(Path(opath).absolute())

ofile.to_csv(opath,sep='\t',index=False)
