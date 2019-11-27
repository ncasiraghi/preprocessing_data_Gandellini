# Pre-process Haloplex WES PE Illumina data
### scripts to merge and generate BAM file from multiple sequecning runs [ from raw fastq to gatk-processed BAM ]

Here is reported an example for a sample.

```
# sequencing runs folder:
SR1=/CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20141210_gandellini
SR2=/CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150113_gandellini
SR3=/CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150304_gandellini
```
Each sequencing run folder contains a subfolder for each sample with raw fastq files:
```
SR1
  Sample_1
    L01_R1.fastq.gz
    L01_R2.fastq.gz
    L02_R1.fastq.gz
    L02_R2.fastq.gz

  Sample_2
    L02_R1.fastq.gz
    L02_R2.fastq.gz
```

### 1. Trimming `fastq` files
In script `trimmomatic.R` update variables:
```R
trimmomatic <- /path/to/trimmomatic-version.jar
trimmomatic.param <- /path/to/trimmomatic_adapters/TruSeq3-PE.fa
```
> `TruSeq3-PE.fa` can be found in the `trimmomatic_adapters` folder of this repository.
```
# Usage example
Rscript trimmomatic.R $SR1
Rscript trimmomatic.R $SR2
Rscript trimmomatic.R $SR3
```
### 2. Align `trimmed-fastq` with `bwa mem`
In script `RunBWA_mem.R` update variables:
```R
BWA_mem <- /path/to/bwa 
ReferenceFasta <- path/to/reference.fa
```
> In this study alignemnt has been performed on Human Genome humanG1Kv37 (human_g1k_v37.fasta, GRCh37)
```
# Usage example
Rscript RunBWA_mem.R $SR1
Rscript RunBWA_mem.R $SR2
Rscript RunBWA_mem.R $SR3
```
### 3. Merge `SAMs` from multiple lanes and sort resulting `BAMs`
```
# Usage example
Rscript MergeSAM_SortBAM.R $SR1
Rscript MergeSAM_SortBAM.R $SR2
Rscript MergeSAM_SortBAM.R $SR3
```
### 4. Merge `BAMs` from multiple sequencing runs
```
# Usage example
Rscript MergeBAM.R [bams_to_merge.csv] [output_folder]
```
The `bams_to_merge.cvs` is a comma-separated file indicating multiple `BAMs` to be merged in a single one for each sample.  
```
# example of .csv file

ID_SAMPLE,/path/to/ID_SAMPLE_A.bam
ID_SAMPLE,/path/to/ID_SAMPLE_B.bam
...
ID_SAMPLE,/path/to/ID_SAMPLE_N.bam
```
> For each ID_SAMPLE present in the .csv file, a folder named `ID_SAMPLE` will be created in the `output_folder` where the merged BAM file will be saved.

### 5. Run `GATK best practices` on merged-BAMs
`CREATE_process_BAMs_with_GATK.R`
`process_BAMs_with_GATK.R [this use preprocessing_inputBAM.vMB.sh]`
