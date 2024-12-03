#magma_annotation
magma=/path_to/magma
#data required for initializing MAGMA
g1000=/path_to/Required_reference_data/magma/g1000_eas.bim
gene_loc=/path_to/Required_reference_data/magma/NCBI37.3.gene.loc

$magma \
--annotate window=35,10 \
--snp-loc $g1000 \
--gene-loc $gene_loc \
--out example_annotation
