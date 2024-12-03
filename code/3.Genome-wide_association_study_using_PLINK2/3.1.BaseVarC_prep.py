#!/usr/bin/env python
# coding: utf-8
# lilinxuan@genomics.cn
# using to create CMD of basevar process
# v1.3

import os

#Specify the arguments before excute this code
#this is the chunk size, the smaller the size, lower compute resoure required
chunk_size = int('5000000')

#the folder of working
outdir='/path_to/3.Genome-wide_association_study_using_PLINK2'

#the length of each chromosomes, example file was in GRCh38, please change if running on other versions of reference genome
CHR_length='/path_to/2.Genotype_imputation_using_STITCH/CHR.len'

#sample names and bam paths, need to match each other
bamlist='/path_to/2.Genotype_imputation_using_STITCH/bampath.list'

#Reference Genome, should be the same as 01.workflow_bwa.sh
ref_genome='/path_to/Required_reference_data/hg38/hg38.fa.masked.gz'

#the path to path of BaseVarC
Basevar='/path_to/BaseVarC'

######################################
###############working################
######################################
print('Create CMD basevar \nlog file will write at '+outdir+'/createCMD_basevar.log')

chunk_size=int(chunk_size)
chr_len=open(CHR_length ,'r').read().split('\n')[:-1]

finaldir=outdir + '/final'

if os.path.isdir(finaldir) == False:
    os.mkdir(finaldir)

outputdir=outdir + '/output'

if os.path.isdir(outputdir) == False:
    os.mkdir(outputdir)
    log = open(outputdir+'/createCMD_basevar.log','w')
    log.write('mkdir: '+outputdir+'\n')
else:
    log = open(outputdir+'/createCMD_basevar.log','w')

log.write('CHR_length:{0}\noutdir:{1}\nbamlist:{2}\nbin={3}\n'.format(CHR_length,outdir,bamlist,chunk_size))

vcf_path_list=open(outputdir+'/vcf_path_list.list','w')
vcf_path_template=outputdir+ "/{0}/{0}-{1}-{2}.10.vcf.gz"

chr_len_dic={}
for chrm in chr_len:
    chr_ ,len_=chrm.split(' ')
    chr_len_dic[chr_]=int(len_)


cmd="time "+ Basevar +" basetype --input "+ bamlist +" --reference " + ref_genome
cmd=cmd + " --region {0}:{1}-{2} --output "+ outdir+ "/{0}/{0}-{1}-{2}.10 "
cmd=cmd + "--batch 10 --rerun \n"

if os.path.isdir(outdir+ "/bash") == False:
    try:
        os.mkdir(outdir+ "/bash")
        log.write('mkdir: '+outdir+ "/bash"+'\n')
    except:
        print('mkdir ERROR')

bashdir=outdir + "/bash"
for key,value in chr_len_dic.items():
    if os.path.isdir(outputdir+ "/" + key) == False:
        try:
            os.mkdir(outputdir+ "/" + key)
            log.write('mkdir: '+outputdir+ "/" + key+'\n')
        except:
            print('mkdir ERROR')

    CMD_SH = open(bashdir+'/CMD_basevar_'+key+'.sh','w') 
    for i in range(0,100):
        start=1+chunk_size*i
        end=chunk_size*(i+1)
        #eg.bin=300,i=1;start=301,end=600
        if(end>value):#end of chr
            end=value
            CMD_SH.write(cmd.format(key,start,end))
            vcf_path_list.write(vcf_path_template.format(key,start,end)+'\n')
            break
        else:
            CMD_SH.write(cmd.format(key,start,end))
            vcf_path_list.write(vcf_path_template.format(key,start,end)+'\n')
    CMD_SH.close()
            
log.close()
vcf_path_list.close()

print('All file prepared.')
