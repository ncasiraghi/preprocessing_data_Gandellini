#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args)!=1){
  message("\n\tError!\n\tUsage: RunBWA_mem.R /path/to/samples.folder\n")
  quit()
}

fastqFolder <- args[1]

number_of_threads <- 20

BWA_mem <- "/usr/bin/bwa mem -M"
ReferenceFasta <- "/elaborazioni/sharedCO/Home_casiraghi/Reference_b37/human_g1k_v37.fasta"

# start processing
SamplesList = list.dirs(fastqFolder,recursive = F)

for(SampleFolder in SamplesList){
  message(SampleFolder)
  setwd(SampleFolder)
  # Paired fastq files
  FastqFiles = sort(list.files(".",pattern = "trimmed.fastq.gz"))
  fastq_R1 = grep(FastqFiles,pattern = "_R1_",value = T) 
  fastq_R2 = grep(FastqFiles,pattern = "_R2_",value = T)
  PairedFastq = as.data.frame(cbind(fastq_R1,fastq_R2),stringsAsFactors = F) 
  for(j in 1:nrow(PairedFastq)){
    PairedFastq$Lane[j] <- grep(unlist(strsplit(PairedFastq$fastq_R1[j],split = "_")),pattern = "^L00[[:digit:]]$",value = T)
  }
  PairedFastq$Lane = as.numeric(gsub(PairedFastq$Lane,pattern = "L00",replacement = ""))
  PairedFastq$SAM = sapply(strsplit(PairedFastq$fastq_R1,split = "\\."),function(x) x[1])
  PairedFastq$SAM = paste0(gsub(PairedFastq$SAM,pattern = "_R1_",replacement = "_"),".sam")
  # Generate RG 
  table=read.table("SampleSheet.csv",header = T,stringsAsFactors = F,sep=",")
  table=table[order(table$Lane),]
  RG_complete <- c()
  for(id in 1:nrow(table)){
    thisLane = table$Lane[id]
    ID=paste0('\\tID:',paste(table$SampleID[id],table$FCID[id],table$Lane[id],sep = "_"))
    PL='\\tPL:Illumina'
    SM=paste0('\\tSM:',table$SampleID[id])
    #DT=paste0('\\tDT:',date)
    BCID=paste0('\\tBCID:',table$Index[id])
    FCID=paste0('\\tFCID:',table$FCID[id])
    LNID=paste0('\\tLNID:',table$Lane[id])
    RG=paste0('\"@RG',ID,PL,SM,BCID,FCID,LNID,'\"')  
    RG_complete <- c(RG_complete,RG) 
  }
  table$ReadGroup <- RG_complete
  # BWA mem
  dir.create("./SAM_mem")
  for(id in 1:nrow(PairedFastq)){
    output = paste0("./SAM_mem/",PairedFastq$SAM[id])
    checkRG <- table$ReadGroup[which(table$Lane==PairedFastq$Lane[id])]
    if(length(checkRG)>0){
      cmd <- paste(BWA_mem,
                   "-t",number_of_threads,
                   "-R",table$ReadGroup[which(table$Lane==PairedFastq$Lane[id])],
                   ReferenceFasta,
                   PairedFastq$fastq_R1[id],
                   PairedFastq$fastq_R2[id],
                   ">",output) 
      cat(cmd,file = "bwa_mem.sh",sep = '\n')
      system("bash bwa_mem.sh")
    }
  }  
}
cat("[ DONE ]\n")

