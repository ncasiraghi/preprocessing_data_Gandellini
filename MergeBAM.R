#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args)!=2){
<<<<<<< HEAD
  message("\n\tError!\n\tUsage: Rscript MergeBAM.R [bams_to_merge.csv] [output_folder]\n")
=======
  message("\n\tError!\n\tUsage: MergeBAM.R /path/to/samples.folder\n")
>>>>>>> c669e747b0823b74ed06443093371bdac29e76aa
  quit()
}

csv <- args[1]
<<<<<<< HEAD
OUTFOLDER <- args[2]

MergeSamFiles <- "java -Xmx2g -jar /scratch/Tools/Picard/MergeSamFiles.jar"

SIF = read.delim(csv,as.is=T,header = F,stringsAsFactors = F,sep = ',') 
=======
OUTFOLDER <- args[1]

MergeSamFiles <- "java -Xmx2g -jar /scratch/Tools/Picard/MergeSamFiles.jar"

SIF = read.delim(csv,as.is=T,sep = ',') 
>>>>>>> c669e747b0823b74ed06443093371bdac29e76aa

samplesname <- unique(SIF[,1]) 

for(SAMPLE in samplesname){
<<<<<<< HEAD
  message(paste("\n[",Sys.time() ,"]\t",SAMPLE))
=======
  message(paste("\n[",Sys.time() ,"]\t",SAMPLE,'\n'))
>>>>>>> c669e747b0823b74ed06443093371bdac29e76aa
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
