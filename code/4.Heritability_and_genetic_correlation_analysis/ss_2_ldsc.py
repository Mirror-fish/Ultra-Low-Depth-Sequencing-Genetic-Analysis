import pandas as pd
import numpy as np
from scipy import stats
import sys

data = pd.read_csv(sys.argv[1],sep='\t')

data['tstats'] = data['beta'] / data['se']

keep = data[['SNP','samplesize','tstats','effect_allele','other_allele','pvalue']].copy()

keep = keep.dropna(subset=['tstats','pvalue'])

keep.columns = ['SNP','N','Z','A1','A2','P']

keep.to_csv(sys.argv[2],sep='\t',index=False)