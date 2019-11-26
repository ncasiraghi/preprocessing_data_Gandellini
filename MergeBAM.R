#!/usr/bin/env Rscript

SIF = read.delim("/CIBIO/sharedCO/Exome_seq/Gandellini/processing/Collect_samples/bam_samples_to_merge.csv",as.is=T) 

OUTFOLDER = "/CIBIO/sharedCO/Exome_seq/Gandellini/MergedBAMs_FINAL"

samplesname = unique(SIF$name) 

for(SAMPLE in samplesname){
  cat(paste("\n[",Sys.time() ,"]\t",SAMPLE,'\n'))
  # Create Merged SAM file
  SAMPLE_folder <- paste(OUTFOLDER,SAMPLE,sep = "/") 
  dir.create(SAMPLE_folder)
  subset <- SIF[which(SIF$name==SAMPLE),]
  INPUT=paste(paste0('INPUT=',subset$bam),collapse = ' ')
  OUTPUT=paste0('OUTPUT=',SAMPLE_folder,"/",paste0(SAMPLE,'.bam'))  
  TMP=paste0('TMP_DIR=',SAMPLE_folder,'/tmp_MergeBAM')
  cmd=paste("java -Xmx2g -jar /scratch/Tools/Picard/MergeSamFiles.jar",INPUT,"VALIDATION_STRINGENCY=LENIENT","CREATE_INDEX=true",TMP,OUTPUT,sep=' ')
  cat(cmd,"\n")
  system(cmd)
}
cat(paste("\n[",Sys.time() ,"]\t","[ DONE ]",'\n'))
