# run: Rscript trimmomatic.R
# samples.folder is the folder with raw fastq files [NOT add / at end pathway]; there is a subfolder for each sample.

# Multiple sequencing runs
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20140929_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20141210_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20150113_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20150304_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20150424_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20150528_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20150619_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20150723_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20161201_run164_gandellini"
# samples.folder = "/CIBIO/sharedCO/Exome_seq/Gandellini/20170113_run174_gandellini"

# test alignment
samples.folder <- "/CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20141210_gandellini"
# samples.folder <- "/CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150113_gandellini"

threads=20

# trimmmomatic params
trimmomatic = paste("java -Xmx1G -jar /elaborazioni/sharedCO/Home_casiraghi/Prog/trimmomatic/Trimmomatic-0.32/trimmomatic-0.32.jar PE -threads",threads,"-phred33") 
trimmomatic.param = "ILLUMINACLIP:/CIBIO/sharedCO/Exome_seq/Gandellini/preprocessing_data_Gandellini/trimmomatic_adapters/TruSeq3-PE.fa:3:35:7:5:true MAXINFO:40:0.6 LEADING:3 TRAILING:3 SLIDINGWINDOW:3:15 MINLEN:40 CROP:86 HEADCROP:3"
