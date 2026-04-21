setwd("/gs/gsfs0/users/rcutler/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/dnds/full_output")
#setwd("/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/10-dnds-ratio")

# libraries ---------------------------------------------------------------
library(dndscv)
library(MutationalPatterns)
library(BSgenome.Hsapiens.UCSC.hg19)
library(dplyr)
library(stringr)
library(tidyr)
library(foreach)
library(doParallel)

dir.create("/gs/gsfs0/users/rcutler/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/dnds/full_output/tempdir")
Sys.setenv(TMPDIR = "/gs/gsfs0/users/rcutler/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/dnds/full_output/tempdir")

options(future.globals.maxSize = 5000 * 1024^2)  # Increase to 5 GB (50 cores with 350G memory)

# functions ---------------------------------------------------------------
grlist_to_dataframe_parallel <- function(gr_list) {
  no_cores <- detectCores() - 1
  registerDoParallel(cores = no_cores)
  
  df_list <- foreach(i = seq_along(gr_list), .combine = rbind, .packages = 'GenomicRanges') %dopar% {
    gr <- gr_list[[i]]
    
    # Directly create the dataframe with only necessary columns
    df <- data.frame(
      sampleID = names(gr_list)[i],
      chr = as.character(seqnames(gr)),
      pos = start(ranges(gr)),
      ref = mapply(function(x) toString(x), gr$REF),
      mut = mapply(function(x) toString(x), gr$ALT),
      stringsAsFactors = FALSE
    )
    
    return(df)
  }
  
  # No need for additional post-processing, return combined dataframe
  return(df_list)
}

# load eseential genes ----------------------------------------------------
essential.expressed.genes <- readRDS("essential.expressed.genes.RDS")

# load simulated mutations ------------------------------------------------
# sim_snv <- readRDS("sim_snv.RDS")
# # sim_snv <- sim_snv[c(1, 1001, 2, 1002)]
# sim_snv <- GRangesList(sim_snv)
# seqlevelsStyle(sim_snv) <- "NCBI"
# sim_snv <- grlist_to_dataframe_parallel(sim_snv)
# 
# sim_indel <- readRDS("sim_indel.RDS")
# # sim_indel <- sim_indel[c(1, 1001, 2, 1002)]
# sim_indel <- GRangesList(sim_indel)
# seqlevelsStyle(sim_indel) <- "NCBI"
# sim_indel <- grlist_to_dataframe_parallel(sim_indel)
# 
# sim_all_df <- rbind(sim_snv, sim_indel)
# 
# saveRDS(sim_all_df, "sim_all_df.RDS")

sim_all_df <- readRDS("sim_all_df.RDS")
sim_all_df <- sim_all_df[,c(5,1:4)]

# split into groups
control <- sim_all_df[grepl("C", sim_all_df$sampleID),]
enu <- sim_all_df[!grepl("C", sim_all_df$sampleID),]

# run global dnds for each simulation (X1000) ---------------------------------------------------------
no_cores <- detectCores() - 1
registerDoParallel(cores = no_cores)

# Preallocate lists to store results
control.res.list <- vector("list", length = 1000)
enu.res.list <- vector("list", length = 1000)

# Variables need to be explicitly exported
variables_to_export <- c("control", "enu", "expressed.genes")

# Specifying all packages that are used inside the parallel loop
required_packages <- c("dndscv", "GenomicRanges", "dplyr", "stringr")

# Parallel loop
results <- foreach(i = c(1:1000), .export = variables_to_export, .packages = required_packages) %dopar% {
  control_res <- tryCatch({
    dndscv(mutations = control[grepl(paste0("_", i, ".vcf"), control$sampleID),],
           max_muts_per_gene_per_sample = Inf,
           max_coding_muts_per_sample = Inf,
           gene_list = essential.expressed.genes,
           refdb = "hg19",
           outp = 1)
  }, error = function(e) {
    # If an error occurs, return NA or any other suitable placeholder
    NA
  })
  
  enu_res <- tryCatch({
    dndscv(mutations = enu[grepl(paste0("_", i, ".vcf"), enu$sampleID),],
           max_muts_per_gene_per_sample = Inf,
           max_coding_muts_per_sample = Inf,
           gene_list = expressed.essential.expressed.genesgenes,
           refdb = "hg19",
           outp = 1)
  }, error = function(e) {
    # If an error occurs, return NA or any other suitable placeholder
    NA
  })
  
  # Return both results for this iteration
  list(control_global_dnds = control_res, enu_global_dnds = enu_res)
}

# Extract and assign results
control.res.list <- lapply(results, `[[`, "control_global_dnds")
enu.res.list <- lapply(results, `[[`, "enu_global_dnds")

saveRDS(control.res.list, "control.dnds.essential.RDS")
saveRDS(enu.res.list, "enu.dnds.essential.RDS")