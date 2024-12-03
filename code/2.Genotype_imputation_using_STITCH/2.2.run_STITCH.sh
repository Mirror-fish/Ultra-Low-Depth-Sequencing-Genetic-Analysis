#Specify the arguments before execute the code related
#path for bcftools
bcftools=/path_to/bcftools

##sample names and bam paths, the sample file as 2.1.Create_bash_STITCH.py
sample_namelist=/path_to/2.Genotype_imputation_using_STITCH/bampath.list
bamlist=/path_to/2.Genotype_imputation_using_STITCH/bamid.list

#output folder
outdir=/path_to/2.Genotype_imputation_using_STITCH/output

#Reference Genome, should be the same as 01.workflow_bwa.sh
hg38=/path_to/Required_reference_data/hg38/hg38.fa.masked.gz

#Before starting STITCH, please make sure you have correctly installed STITCH in your environment
#If correctly installed, you can find the STITCH.R in the directory you install STITCH
STITCH_R=/path_to/STITCH.R

######################################
###############working################
######################################

chr_region=$1
chr=$2
start=$3
end=$4

if [ ! -d ${outdir}/${chr}/${chr_region} ]
then mkdir -p ${outdir}/${chr}/${chr_region}
fi

###Specify the arguments before execute!
time /path_to/Rscript $STITCH_R \
--outputdir ${outdir}/${chr}/${chr_region} \
--bamlist $bamlist \
--sampleNames_file $sample_namelist \
--reference $hg38 \
--K 10 --nGen 16000 --nCores 1 \
--regionStart $start --regionEnd $end --chr $chr \
--buffer 250000 
#--niterations 40 \
#--posfile /path_to/${chr}.pos.txt \
#--reference_sample_file /path_to/eas.${chr}.samples \
#--reference_legend_file /path_to/eas.${chr}.legend.gz \
#--reference_haplotype_file /path_to/eas.${chr}.hap.gz


$bcftools index -t ${outdir}/${chr}/${chr_region}/${chr}/${chr_region}/stitch.${chr}.${start}.${end}.vcf.gz

rm -rv  ${outdir}/${chr}/${chr_region}/input \
&& touch  ${outdir}/${chr}/${chr_region}/input.removed
