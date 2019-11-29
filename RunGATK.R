#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args)!=2){
  message("\n\tError!\n\tUsage: Rscript RunGATK.R [/path/to/folder_with_merged_BAMs] [output_folder]\n")
  quit()
}

bamfolder.path <- args[1]
oufolder.path <- args[2]

script.path <- "/CIBIO/sharedCO/Exome_seq/Gandellini/preprocessing_data_Gandellini/gatk/gatk_best_practices.sh"
nt <- 20

bamlist <- list.files(bamfolder.path, pattern = "Sample_",full.names = F)

for(i in seq(length(bamlist))) {
  bam <- list.files(file.path(bamfolder.path, bamlist[i]), pattern = ".bam")
  bam.path <- file.path(bamfolder.path, bamlist[i], bam)
  outfolder <- file.path(oufolder.path, bamlist[i])
  cmd <- paste("bash", script.path, bam.path, outfolder, nt)
  system(cmd)
}

