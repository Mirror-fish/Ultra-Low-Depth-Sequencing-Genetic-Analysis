#!/usr/bin/env python
# coding: utf-8
# lilinxuan@genomics.cn
# using: python glm_2_ss.py ifile.linear.add ifile.afreq [ofile.ss]
# v1.2 add gene annotation

import pandas as pd
import numpy as np
import re
import sys
import gzip
import linecache as lc

#ifile = 'C:/Users/26026/workshop/20211203_wuhan_NIPT_copy/LDSC-MR/GWAS_GDM_basevar.GDM.glm.logistic.add'
#freqfile = 'C:/Users/26026/workshop/20211203_wuhan_NIPT_copy/LDSC-MR/WholeGenome2.afreq'
#opath = 'C:/Users/26026/workshop/20211203_wuhan_NIPT_copy/LDSC-MR/GDM_Z.ss'

ifile = sys.argv[1]
freqfile = '/hwfssz5/ST_HEALTH/P18Z10200N0124/lilinxuan/workshop/20211118_check_wuhan_MTHFR/output/plink-format/STITCH_21058/WholeGenome2.afreq'
try:
    opath = sys.argv[2]
except:
    opath = ifile + '.ss'

data = pd.read_csv(ifile,sep='\t',dtype=str)

triat,method = re.findall('.+\.([\w%-]+)\.glm\.(\w+).*',ifile)[0]

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

index = pd.read_csv(gzip.GzipFile('/hwfssz5/ST_HEALTH/P18Z10200N0124/lilinxuan/toolset/reference/dbSNP_RS/chrall.arrange.1000genomes.index.gz'),sep='\t',dtype={'LINE':int})
index['CHR:POS'] = "chr"+index['CHR:POS']
index = index.set_index('CHR:POS')['LINE']

rs_index = data['ID'].map(index)
rs_index = rs_index.fillna(0).astype(int)

RS_code = pd.Series(index=rs_index.index, dtype=str)
Gene_anno = pd.Series(index=rs_index.index, dtype=str)
REGION = pd.Series(index=rs_index.index, dtype=str)

for k,i in enumerate(rs_index.index):
    if rs_index[i] == 0:
        RS_code[i] = '.'
        Gene_anno[i] = '.'
        REGION[i] = '.'
        continue
    line_this = lc.getline('/hwfssz5/ST_HEALTH/P18Z10200N0124/lilinxuan/toolset/reference/dbSNP_RS/chrall.arrange.1000genomes',int(rs_index[i]))
    try:
        RS_code[i],Gene_anno[i],REGION[i] = line_this.split('\t')[4:7]
    except:
        print(i)
        RS_code[i],Gene_anno[i],REGION[i] = '.','.','.'
    if k%100000 == 0:
        lc.clearcache()

data['SNP'] = RS_code
data['GENE'] = Gene_anno #v1.2
data['REGION'] = REGION

# output

colname = ['trait','chr','pos','SNP','GENE','REGION','other_allele','effect_allele','eaf','samplesize','beta','se','zsores','pvalue']

if method == 'logistic':
    data['BETA']=np.log(data['OR'].astype(np.float64))
    ofile = data[['TraitName','CHROM','POS','SNP','GENE','REGION','A2','A1','A1_FREQS','OBS_CT','BETA','LOG(OR)_SE','Z_STAT','P']].copy()
else:
    ofile = data[['TraitName','CHROM','POS','SNP','GENE','REGION','A2','A1','A1_FREQS','OBS_CT','BETA','SE','T_STAT','P']].copy()
ofile.columns = colname

from pathlib import Path
print(Path(opath).absolute())

ofile.to_csv(opath,sep='\t',index=False)
