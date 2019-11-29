## create script for batch processing bams with GATK

script.path <- "/CIBIO/sharedCO/Exome_seq/Gandellini/processing/preprocessing_inputBAM.vMB.sh"
scriptout.path <- "/CIBIO/sharedCO/Exome_seq/Gandellini/processing/process_BAMs_with_GATK.sh"
bamfolder.path <- "/CIBIO/sharedCO/Exome_seq/Gandellini/MergedBAMs_FINAL/"
oufolder.path <- "/CIBIO/sharedCO/Exome_seq/Gandellini/ProcessedBAMs/"
nt <- 20

bamlist <- list.files (bamfolder.path, pattern = "Sample_")

cat("#!/bin/bash", file = scriptout.path, append = F, sep = "\n")
for (i in 1: length(bamlist)) {
  bam0 <- list.files (file.path(bamfolder.path, bamlist[i]), pattern = ".bam")
  bam.path <- file.path(bamfolder.path, bamlist[i], bam0)
  outfolder <- file.path(oufolder.path, bamlist[i])
  cmd <- paste("bash", script.path, bam.path, outfolder, nt)
  cat(cmd, file = scriptout.path, sep = "\n", append = T)
}

