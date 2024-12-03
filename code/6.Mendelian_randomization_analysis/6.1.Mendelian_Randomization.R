#exposure .ss data
exposure = read.table("/path_to/5.Mendelian_randomization_analysis/exposure_summaries.txt",header = T)[,1]
#outcome summary statistics
outcome = read.table("/path_to/5.Mendelian_randomization_analysis/outcome_summaries.txt",header = T)

################ work ##################

library(TwoSampleMR)
library(ieugwasr)

#output
r<-data.frame()

for (i in 1:length(exposure)) {
  # Read exposure data
  exp = as.data.frame(fread(exposure[i] ,header = T))
  exp$pvalue = as.numeric(exp$pvalue)
  exp_sig = exp[exp$pvalue < 5e-08 & exp$SNP != ".",] #Please check the significant threshold
  exp_data = format_data(
    exp_sig,
    type = "exposure",
    phenotype_col = "trait",
    snp_col = "SNP",
    beta_col = "beta",
    se_col = "se",
    eaf_col = "eaf",
    effect_allele_col = "effect_allele",
    other_allele_col = "other_allele",
    pval_col = "pvalue",
    samplesize_col = "samplesize"
  )

  #if the internet's not working or you have specified a LD reference panel
  #exp_data <- ld_clump(dat = NULL, clump_kb = 10000, clump_r2 = 0.001, clump_p = 0.99, pop = "EUR", access_token = NULL, bfile = NULL, plink_bin = NULL)
  
  #default clumping method
  exp_data <- clump_data(exp_data, clump_kb = 10000, clump_r2 = 0.2, clump_p1 = 1, clump_p2 = 1)

  for (j in 1:nrow(outcome)) {
    trait = outcome[j,2]
    ncase = outcome[j,3]
    ncontrol = outcome[j,4]
    # Read outcome data
    bbj = as.data.frame(fread(paste0("out/","phenocode-",trait,".tsv.gz"),header = T))
    bbj_slt = bbj[bbj$rsids %in% exp_dat$SNP,]
    bbj_slt$trait = trait
    bbj_slt$ncase = ncase
    bbj_slt$ncontrol = ncontrol
  
    out_dat = format_data(
      bbj_slt,
      type = "outcome",
      phenotype_col = "trait",
      snp_col = "rsids",
      beta_col = "beta",
      se_col = "sebeta",
      eaf_col = "maf",
      effect_allele_col = "alt",
      other_allele_col = "ref",
      pval_col = "pval",
      ncase_col = "ncase",
      ncontrol_col = "ncontrol",
    )
  

    h <- harmonise_data(exp_dat, out_dat)
    
    dat <- mr(h, parameters = default_parameters(), method_list = c("mr_egger_regression", "mr_ivw", "mr_weighted_median"))

    exposure <- dat$exposure
    outcome <- dat$outcome
    method <- dat$method
    nsnp <- dat$nsnp
    b <- dat$b
    se <- dat$se
    pval <- dat$pval
    result_df <- data.frame(exposure, outcome, method, nsnp, b, se, pval)
    r<-rbind(r,result_df)
    result_list[[basename_prefix]] <- result_df

  }
}

write.table(
      x = result_df,
      file = 'Pvalues_file.txt',
      sep = "\t", 
      col.names = TRUE, 
      row.names = FALSE, 
      append = TRUE 
    )