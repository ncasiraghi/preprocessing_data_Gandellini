#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = T)

if(length(args)!=1){
  message("\n\tError!\n\tUsage: trimmomatic.R /path/to/samples.folder\n")
  quit()
}

samples.folder = args[1]

trimmomatic <- "java -Xmx1G -jar /elaborazioni/sharedCO/Home_casiraghi/Prog/trimmomatic/Trimmomatic-0.32/trimmomatic-0.32.jar PE -threads 20 -phred33" 

trimmomatic.param <- "ILLUMINACLIP:/CIBIO/sharedCO/Exome_seq/Gandellini/preprocessing_data_Gandellini/trimmomatic_adapters/TruSeq3-PE.fa:3:35:7:5:true MAXINFO:40:0.6 LEADING:3 TRAILING:3 SLIDINGWINDOW:3:15 MINLEN:40 CROP:86 HEADCROP:3"

all.samples = sort(list.dirs(samples.folder,recursive = F))

for(sample in all.samples){
  cat("Trimming sample:\t",sample,"\n")
  fastq = list.files(sample,pattern = ".fastq.gz",full.names = T)
  
  R1 = sort(grep(fastq,pattern = "_R1_",value = T))
  R2 = sort(grep(fastq,pattern = "_R2_",value = T))
  
  paired.fastq = data.frame(R1,R2,stringsAsFactors = F)
  
  for(pair in 1:nrow(paired.fastq)){
    fastq_R1 = paired.fastq[pair,1] 
    fastq_R2 = paired.fastq[pair,2]
    
    fastq_R1_unpaired = gsub(fastq_R1,pattern = ".fastq.gz",replacement = ".unpaired.fastq.gz") 
    fastq_R1_trimmed = gsub(fastq_R1,pattern = ".fastq.gz",replacement = ".trimmed.fastq.gz") 
        
    fastq_R2_unpaired = gsub(fastq_R2,pattern = ".fastq.gz",replacement = ".unpaired.fastq.gz")
    fastq_R2_trimmed = gsub(fastq_R2,pattern = ".fastq.gz",replacement = ".trimmed.fastq.gz")
    
    cmd = paste(trimmomatic,fastq_R1,fastq_R2,fastq_R1_trimmed,fastq_R1_unpaired,fastq_R2_trimmed,fastq_R2_unpaired,trimmomatic.param)
    system(cmd)
  }
} 
cat("\n[ DONE ]\n")