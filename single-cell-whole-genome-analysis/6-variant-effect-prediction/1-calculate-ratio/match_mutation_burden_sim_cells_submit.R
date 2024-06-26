# This script takes simulations of mutations produced by SigProfilerSimulator and then produces a new set of simulated cells that are matched to the obesrved cells
# This is necessary because the number of mutations for the simulations produced by SigProfilerSimulator are usually less than the number of observed mutations

# load libraries ----------------------------------------------------------

library(rtracklayer)
library(GenomicRanges)
library(MutationalPatterns)
library(Biostrings)
library(BSgenome.Hsapiens.UCSC.hg19)
library(doParallel)
library(foreach)

# functions ---------------------------------------------------------------

read_simulated_vcfs <- function(filePath, variantType = "ALL") {
  # Read the file
  data <- read.table(filePath, header = FALSE, sep = "\t", stringsAsFactors = FALSE)
  
  # Filter for SNVs or INDELs if specified
  if (variantType == "SNV") {
    data <- data[nchar(data$V4) == 1 & nchar(data$V5) == 1, ]
  } else if (variantType == "INDEL") {
    data <- data[nchar(data$V4) != 1 | nchar(data$V5) != 1, ]
  }
  
  # Initialize vectors for start and end positions
  startPos <- data$V2
  endPos <- data$V2
  
  # Adjust end positions for REF alleles with more than one nucleotide
  for (i in 1:nrow(data)) {
    if (nchar(data$V4[i]) > 1) {
      endPos[i] <- startPos[i] + nchar(data$V4[i]) - 1
    }
    # For single nucleotide REF, startPos and endPos remain the same
  }
  
  # Create GRanges object
  gr <- GRanges(seqnames = data$V1,
                ranges = IRanges(start = startPos, end = endPos),
                REF = DNAStringSet(data$V4),
                ALT = DNAStringSetList(as(data$V5, "SimpleList")),
                matGenClass = data$V9)
  
  seqlevelsStyle(gr) <- "UCSC"
  
  return(gr)
}

# takes multiple simulated samples and creates matched simulated samples by making sure that 
# the number of SNVs and INDELs match the observed sample and 
# that these mutations are located within the regions with sufficient coverage in the observed sample
create_simulated_cells <- function(sim_dir, vcf.obs, bed, num_cells){
  
  # split observed into SNV and INDEL
  vcf_obs.snv <- vcf.obs[unlist(nchar(vcf.obs$REF) == 1) & unlist(nchar(vcf.obs$ALT) == 1),]
  vcf_obs.indel <- vcf.obs[unlist(nchar(vcf.obs$REF) != 1) | unlist(nchar(vcf.obs$ALT) != 1),]
  
  # load simulated files
  vcf_files <- list.files(path = sim_dir,
                          pattern = "\\.vcf$", 
                          full.names = TRUE)
  
  # split observed into SNV and INDEL
  vcf.sim.snv <- lapply(vcf_files, function(x) read_simulated_vcfs(x, variantType = "SNV"))
  vcf.sim.indel <- lapply(vcf_files, function(x) read_simulated_vcfs(x, variantType = "INDEL"))

  # merge simulated vcfs together
  vcf.sim.snv <- unlist(GRangesList(vcf.sim.snv, compress = FALSE))
  vcf.sim.indel <- unlist(GRangesList(vcf.sim.indel, compress = FALSE))
  
  # Filter mutations to keep only those within the regions specified in the bed file
  vcf.sim.snv <- vcf.sim.snv[queryHits(findOverlaps(vcf.sim.snv, bed))]
  vcf.sim.indel <- vcf.sim.indel[queryHits(findOverlaps(vcf.sim.indel, bed))]
  
  # create simulated cells by randomly sampling the mutations to be the same number as those in the observed cells
  simulated_cells <- vector("list", num_cells)
  for (i in 1:num_cells) {
    sampled.snv <- vcf.sim.snv[sample(length(vcf.sim.snv),  length(vcf_obs.snv))]
    sampled.indel <- vcf.sim.indel[sample(length(vcf.sim.indel),  length(vcf_obs.indel))]
    simulated_cells[[i]] <- c(sampled.snv, sampled.indel)
  }
  
  return(simulated_cells)
}

export_GRanges_to_VCF <- function(gr_obj, sample_name) {
  # Convert to data frame
  gr_df <- as.data.frame(gr_obj)
  
  # Convert columns to appropriate types
  gr_df$REF <- as.character(gr_df$REF)
  gr_df$ALT <- unlist(as(gr_df$ALT, "CharacterList"))
  
  # Generate paramRangeID
  gr_df$paramRangeID <- with(gr_df, paste0(seqnames, ":", start, "_", REF, "/", ALT))
  
  # Create VCF header
  vcf_header <- sprintf("##fileformat=VCFv4.3\n#CHROM\tPOS\tID\tREF\tALT")
  
  # Generate VCF body
  vcf_body <- with(gr_df, paste(seqnames, start, paramRangeID, REF, ALT, sep = '\t'))
  
  # Combine header and body and write to file
  vcf_text <- paste(vcf_header, paste(vcf_body, collapse = '\n'), sep = '\n')
  writeLines(vcf_text, sprintf("%s.vcf", sample_name))
}

export_GRanges_to_VCF_old <- function(gr_obj, sample_name) {
  # Step 1: Convert to data frame
  gr_df <- as.data.frame(gr_obj)
  
  # Step 2: Convert columns to appropriate types
  gr_df$REF <- as.character(gr_df$REF)
  gr_df$ALT <- sapply(gr_df$ALT, function(alt) {
    as.character(alt)[1]
  })
  
  # Step 3: Generate paramRangeID if necessary
  gr_df$paramRangeID <- paste0(gr_df$seqnames, ":", gr_df$start, "_", gr_df$REF, "/", gr_df$ALT)
  
  # Step 4: Create VCF header
  vcf_header <- paste0('##fileformat=VCFv4.3\n',
                       '#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t', 
                       sample_name)
  
  # Step 5: Generate VCF body
  vcf_body <- apply(gr_df, 1, function(row) {
    paste(row['seqnames'], row['start'], row['paramRangeID'], row['REF'], row['ALT'], row['QUAL'], row['FILTER'], '.', '.', '.', sep = '\t')
  })
  vcf_body <- paste(vcf_body, collapse = '\n')
  
  # Step 6: Combine header and body and write to file
  vcf_text <- paste(vcf_header, vcf_body, sep = '\n')
  writeLines(vcf_text, paste0(sample_name, ".vcf"))
}

# load data ---------------------------------------------------------------
setwd("/gs/gsfs0/users/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator_output_burden_matched/")

# sample table
sample_table <- read.table("sample_table_filtered.txt",
                           header = TRUE)
# vcf and bed files
input_table <- read.table("input_table.txt",
                          header = TRUE)
input_table$sample <- sub(".*/(.*?)\\.vcf", "\\1", input_table$vcf)
input_table <- input_table[match(sample_table$sample, input_table$sample),] # match order of sample table

# read in observed vcfs
vcf_obs <- read_vcfs_as_granges(input_table$vcf, sample_table$sample, BSgenome.Hsapiens.UCSC.hg19, type = "all", remove_duplicate_variants = FALSE)

# simulated cells directories
base_path <- "/gs/gsfs0/users/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator_output/<name>/output/simulations/<name>_simulations_GRCh37_ID_96_BED/<name>"
input_table$simulation_dirs <- sapply(input_table$sample, function(name) {
  gsub("<name>", name, base_path)
})

# read in observed coverage
coverage <- lapply(input_table$bed, function(file) import.bed(file))
coverage <- GRangesList(coverage, compress = FALSE)
names(coverage) <- sample_table$sample
for(i in 1:length(coverage)){
  seqlevelsStyle(coverage[[i]]) <- "UCSC"
}
# correct for adjustment for 0 indexing. Know this is correct because all mutations overlap when making this correction
for(i in 1:length(coverage)){
  start(coverage[[i]]) <- start(coverage[[i]]) - 1
}

# create simulated cells --------------------------------------------------
setwd("/gs/gsfs0/shared-lab/vijg-lab/2023-Ronnie/231009_multiple_ENU_analysis/SigProfilerSimulator/cells/SigProfilerSimulator_output_burden_matched/output")

# no_cores <- detectCores() - 1  # Leave one core free for other system processes
# registerDoParallel(no_cores)
# num_simulations <- 10000
# results <- foreach(i = 1:length(input_table$simulation_dirs)) %dopar% {
#   
#   # Create simulated cells
#   print(paste("Creating simulation for", basename(input_table$simulation_dirs)[i]), sep = " ")
#   simulated_cells <- create_simulated_cells(input_table$simulation_dirs[[i]], vcf_obs[[i]], coverage[[i]], num_simulations)
#   names(simulated_cells) <- paste0(basename(input_table$simulation_dirs)[i], "_", 1:num_simulations)
#   
#   # Export each GRanges object in simulated_cells to a VCF file
#   print(paste("Exporting simulated vcfs for", basename(input_table$simulation_dirs)[i]), sep = " ")
#   lapply(seq_along(simulated_cells), function(j) {
#     export_GRanges_to_VCF(simulated_cells[[j]], names(simulated_cells)[j])
#   })
#   
# }
# 
# stopImplicitCluster()

# make the loop within the function parallel
# make the export parallel
num_simulations <- 10000
for(i = 1:length(input_table$simulation_dirs)){

  # Create simulated cells
  print(paste("Creating simulation for", basename(input_table$simulation_dirs)[i]), sep = " ")
  simulated_cells <- create_simulated_cells(input_table$simulation_dirs[[i]], vcf_obs[[i]], coverage[[i]], num_simulations)
  names(simulated_cells) <- paste0(basename(input_table$simulation_dirs)[i], "_", 1:num_simulations)

  # Export each GRanges object in simulated_cells to a VCF file
  print(paste("Exporting simulated vcfs for", basename(input_table$simulation_dirs)[i]), sep = " ")
  lapply(seq_along(simulated_cells), function(j) {
    export_GRanges_to_VCF(simulated_cells[[j]], names(simulated_cells)[j])
  })

}

