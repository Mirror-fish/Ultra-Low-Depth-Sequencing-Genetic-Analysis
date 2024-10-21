# encoding=utf-8
# python3

import pandas as pd
import numpy as np

ifile = sys.argv[1]
opath = sys.argv[2]

ss = pd.read_csv(ifile, sep='\t')

snplist:pd.DataFrame = ss[['SNP','effect_allele','other_allele']].copy()
snplist['SNP'] = snplist['SNP'].replace('.',np.nan)
snplist.columns = ['SNP','A1','A2']

snplist = snplist.dropna(subset='SNP')

# 输出
snplist.to_csv(opath, sep='\t',index=False)