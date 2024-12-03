#step3_Gene_set_analysis
magma=/path_to/magma
interactions=/path_to/Required_reference_data/magma/interactions.tsv

#convert the interactions.tsv
cut -f 3,9 $interactions |awk '{if($2!=""&&$1!="") print $_}' - > interactions_sorted && \
sed -i '1d' interactions_sorted && \
sort -k2 interactions_sorted > interactions_sorted

#gene set analysis
$magma \
--gene-results /path_to/GWAS_pheno_example.genes.raw \
--set-annot interactions_sorted col=1,2 \
--out GWAS_pheno_example.drug


