### static path for tools and reference on local disk.
### Tools
gatk=/path_to/gatk-4.0.4.0/gatk
java=/path_to/jdk1.8.0_131/bin/java
bwa=/path_to/bwa/0.7.16/bwa
samtools=/path_to/samtools
fastp=./path_to/fastp-0.23.2/fastp

### Reference Genome
hg38=/path_to/Required_reference_data/hg38/hg38.fa.masked.gz

### GATK bundle
gatk_bundle_dir=/path_to/Required_reference_data/gatk-bundle

#Check the sequencing platform
platform=ILLUMINA

#where to perform the analysis, the folder's absolute path
out_path=/path_to/1.Quality_control_and_alignment_of_the_FASTQ_files

######################################################################################
################################### Pipeline #########################################
######################################################################################
### Input
sample_id=$1
fq=$2

### Output
final_outdir=$out_path/final_data/$sample_id
outdir=$out_path/temp_data/$sample_id

if [ ! -d $final_outdir ]
then mkdir -p $final_outdir
fi

if [ ! -d $outdir ]
then mkdir -p $outdir
fi

echo "We're doing the job in $sample_id"
echo "We are calculating $fq"
echo "We are doing $sample_id"
echo "We'll save it in $final_outdir"

### step 0: fastp for QC

time $fastp -i $fq -o $outdir/${sample_id}.clean.fq.gz --qualified_quality_phred=5 --unqualified_percent_limit=50 --n_base_limit=10 \
--adapter_sequence="AAGTCGGAGGCCAAGCGGTCTTAGGAAGACAA" --adapter_sequence_r2="AAGTCGGATCGTAGCCATGTCGTTCTGTGAGCCAAGGAGTTG" \
--disable_trim_poly_g --thread=16 -j $outdir/${sample_id}.json -h $outdir/${sample_id}.html -R $sample_id

### step 1: bwa

echo ""
time $bwa aln -e 10 -t 4 -i 5 -q 0 $hg38 $outdir/${sample_id}.clean.fq.gz > $outdir/${sample_id}.sai && \
    time $bwa samse -r "@RG\tID:${sample_id}\tPL:${platform}\tSM:${sample_id}" $hg38 $outdir/${sample_id}.sai $outdir/${sample_id}.clean.fq.gz | $samtools view -h -Sb - > $outdir/${sample_id}.bam && echo "** bwa done **" && \
    time $samtools sort -@ 8 -O bam -o $outdir/${sample_id}.sorted.bam $outdir/${sample_id}.bam && echo "** bam sorted done **" && \
    time $samtools rmdup $outdir/${sample_id}.sorted.bam $outdir/${sample_id}.sorted.rmdup.bam && echo "** rmdup done **" && \
    time $samtools index $outdir/${sample_id}.sorted.rmdup.bam && echo "** index done **" && touch ${outdir}/bwa_sort_rmdup.finish

if [ ! -f ${outdir}/bwa_sort_rmdup.finish ]
then echo "** [WORKFLOW_ERROR_INFO] bwa_sort_rmdup not done **" && exit
fi

### step 2: gatk

echo ""
time $gatk BaseRecalibrator \
    -R $hg38 \
    -I $outdir/${sample_id}.sorted.rmdup.bam \
    --known-sites $gatk_bundle_dir/dbsnp_138.hg38.vcf.gz \
    -O $outdir/${sample_id}.recal_data.table && echo "** BaseRecalibrator done " && touch ${outdir}/baseRecalibrator.finish

if [ ! -f ${outdir}/baseRecalibrator.finish ]
then echo "** [WORKFLOW_ERROR_INFO] baseRecalibrator not done **" && exit
fi

time $gatk ApplyBQSR \
    -R $hg38 \
    --bqsr-recal-file $outdir/${sample_id}.recal_data.table \
    -I $outdir/${sample_id}.sorted.rmdup.bam \
    -O $outdir/${sample_id}.sorted.rmdup.BQSR.bam && echo "** PrintReads done **" && touch ${outdir}/PrintReads.finish

if [ ! -f ${outdir}/PrintReads.finish ]
then echo "** [WORKFLOW_ERROR_INFO] PrintReads not done **" && exit
fi

### step 3: bam index

time $samtools index $outdir/${sample_id}.sorted.rmdup.BQSR.bam && echo "** bam index done **" && touch ${outdir}/bam_index.finish

if [ ! -f ${outdir}/bam_index.finish ]
then echo "** [WORKFLOW_ERROR_INFO] bam index not done **" && exit
fi

### step 4: bam stats
time $samtools stats $outdir/${sample_id}.sorted.rmdup.BQSR.bam > $outdir/${sample_id}.sorted.rmdup.BQSR.bamstats && echo "** bamstats done **" && touch ${outdir}/bamstats.finish

if [ ! -f ${outdir}/bamstats.finish ]
then echo "** [WORKFLOW_ERROR_INFO] bamstats not done **" && exit
fi

### move to final_dir

mv -f $outdir/${sample_id}.sorted.rmdup.BQSR.bam* $final_outdir && echo "** move2final done **" && touch ${outdir}/move2final.finish
if [ ! -f ${outdir}/move2final.finish ]
then echo "** [WORKFLOW_ERROR_INFO] move2final not done **" && exit 
fi

### clear up
rm -vrf $outdir
