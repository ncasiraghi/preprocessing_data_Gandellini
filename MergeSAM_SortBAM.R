#!/usr/bin/env Rscript

# Generate sorted bam file starting from unmerged sam files

args <- commandArgs(trailingOnly = TRUE)
if(length(args)!=1){
  message("\n\tError!\n\tUsage: MergeSAM_SortBAM.R path_to_run_folder\n")
  quit()
}

# i.e. Rscript MergeSAM_SortBAM.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20141210_gandellini/

mainfolder = args[1]
cat(paste("\nSample Folder:",mainfolder),"\n")

available = grep(list.dirs(mainfolder,recursive = F),pattern = 'Sample_',value = T)

for(sample in available){
  cat(paste("\n[",Sys.time() ,"]\t",sample,'\n'))
  # Create Merged SAM file
  dir.create(paste0(sample,'/SAM_mem/Merged'))
  samfiles=list.files(paste0(sample,'/SAM_mem'),pattern = '.sam',full.names = T)
  INPUT=paste(paste0('INPUT=',samfiles),collapse = ' ')
  SAM=paste0('OUTPUT=',sample,'/SAM_mem/Merged/',basename(sample),'.sam')
  TMP=paste0('TMP_DIR=',sample,'/SAM_mem/Merged/tmp_MergeSAM')
  cmd=paste("java -Xmx2g -jar /scratch/Tools/Picard/MergeSamFiles.jar",INPUT,"VALIDATION_STRINGENCY=LENIENT",TMP,SAM,sep=' ')
  system(cmd)  
  # Create sorted BAM file and index BAI
  dir.create(paste0(sample,'/BAM_mem'))
  mergedSAM=paste0(sample,'/SAM_mem/Merged/',basename(sample),'.sam')
  mergedBAM=paste0(sample,'/BAM_mem/',basename(sample),'.bam')
  cmd=paste("samtools view -bhS",mergedSAM,">",mergedBAM,sep = ' ')
  system(cmd)
  index=paste('samtools index',mergedBAM,sep = ' ')
  system(index)
}
cat(paste("[",Sys.time() ,"]\t [ DONE ]\n"))
