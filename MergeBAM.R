#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args)!=2){
  message("\n\tError!\n\tUsage: Rscript MergeBAM.R [bams_to_merge.csv] [output_folder]\n")
  quit()
}

csv <- args[1]
OUTFOLDER <- args[2]

MergeSamFiles <- "java -Xmx2g -jar /scratch/Tools/Picard/MergeSamFiles.jar"

SIF = read.delim(csv,as.is=T,header = F,stringsAsFactors = F,sep = ',') 

samplesname <- unique(SIF[,1]) 

for(SAMPLE in samplesname){
  message(paste("\n[",Sys.time() ,"]\t",SAMPLE))
  # Create Merged SAM file
  SAMPLE_folder <- file.path(OUTFOLDER,SAMPLE) 
  dir.create(SAMPLE_folder)
  subset <- SIF[which(SIF[,1]==SAMPLE),]
  INPUT=paste(paste0('INPUT=',subset[,2]),collapse = ' ')
  OUTPUT=paste0('OUTPUT=',file.path(SAMPLE_folder,paste0(SAMPLE,'.bam')))  
  TMP=paste0('TMP_DIR=',file.path(SAMPLE_folder,'tmp_MergeBAM'))
  cmd=paste(MergeSamFiles,INPUT,"VALIDATION_STRINGENCY=LENIENT","CREATE_INDEX=true",TMP,OUTPUT,sep=' ')
  cat(cmd,"\n")
  system(cmd)
}
cat(paste("\n[",Sys.time() ,"]\t","[ DONE ]",'\n'))
