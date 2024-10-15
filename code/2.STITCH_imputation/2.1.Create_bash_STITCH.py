#!/usr/bin/env python
# coding: utf-8
# lilinxuan@genomics.cn
# stitch for imputation
# v2.0

import os

#Specify the arguments before excute this code
#this is the chunk size, the smaller the size, lower compute resoure required
chunk_size = int('5000000')

#the folder of working
outdir='/path_to/STITCH_analysis'

#sample names and bam paths, need to match each other
sample_namelist='/path_to/STITCH_analysis/bampath_4659.list'
bamlist='/path_to/STITCH_analysis/bamid.list'

#the length of each chromosomes, example file was in GRCh38, please change if running on other versions of reference genome
CHR_length='/path_to/STITCH_analysis/CHR.len'

#the path to the STITCH code
STITCH_script ='/path_to/STITCH_analysis/2.2.run_STITCH.sh'


######################################
###############working################
######################################
#Check if file exist
flag=8*os.path.isfile(bamlist)+4*os.path.isfile(sample_namelist)+2*os.path.isfile(CHR_length)
if flag== 14:
    print("\nUsing file:\nbamlist: "+bamlist +'\nsample_name: '+sample_namelist+'\nCHR.len: '+CHR_length)
else:
    raise ValueError('Some required file (bamlist, sample namelist, etc.) does not exist, please check.')

#mkdir
output_path = outdir + '/output/'

print('\nlog file will write at '+output_path+'/2.1.Create_bash_STITCH.log')

if os.path.isdir(output_path) == False:
    os.mkdir(output_path)
    log = open(output_path+'/2.1.Create_bash_STITCH.log','w')
    log.write('mkdir: '+output_path+'\n')
else:
    log = open(output_path+'/2.1.Create_bash_STITCH.log','w')

log.write('chr_len_path:{0}\noutdir:{1}\nbamlist:{2}\nbin={3}\n'.format(CHR_length,output_path,bamlist,chunk_size))

sh_path = outdir + '/bash/'
if os.path.isdir(sh_path) == False:
    os.mkdir(sh_path)
    log.write('mkdir: '+sh_path+'\n')
else:
    pass

#Create the bash files
chr_len=open(CHR_length ,'r').read().split('\n')[:-1]
chr_len_dic={}
for chrm in chr_len:
    chr_ ,len_=chrm.split(' ')
    chr_len_dic[chr_]=int(len_)

for key,value in chr_len_dic.items():
    if (key == 'chrY')|(key == 'chrM'):
        continue
        #Notice: We ignored chromosome Y and Mitochondrial genome, since the imputation on these genomes are complex
    else:
        sh_this=open(sh_path+key+'.sh','w')

    for i in range(0,1000):#We regulated the number of chunks on a single chromsome with < 1000
        start=1+chunk_size*i
        end=chunk_size*(i+1)
        if(end>value):#end of chr
            sh_this.write(
                f'bash {STITCH_script} {key}_{start}_{end} {key} {start} {value}'
            )
            break
        else:
            sh_this.write(
                f'bash {STITCH_script} {key}_{start}_{end} {key} {start} {end}\n'
            )
    sh_this.close()
log.close()

print('All file prepared.')

