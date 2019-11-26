# Pre-process Haloplex WES PE Illumina data
### scripts to merge and generate BAM file from multiple sequecning runs [ from raw fastq to BAM ]

Following an example for a test sample.

### 1. Trimming `fastq` files
```
RScript trimmomatic.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20141210_gandellini
Rscript trimmomatic.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150113_gandellini
Rscript trimmomatic.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150304_gandellini
```
### 2. Align `trimmed-fastq` with `bwa mem`
```
Rscript RunBWA_mem.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20141210_gandellini
Rscript RunBWA_mem.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150113_gandellini
Rscript RunBWA_mem.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150304_gandellini
```
### 3. Merge `SAMs` from multiple lanes and sort resulting `BAMs`
```
Rscript MergeSAM_SortBAM.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20141210_gandellini
Rscript MergeSAM_SortBAM.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150113_gandellini
Rscript MergeSAM_SortBAM.R /CIBIO/sharedCO/Exome_seq/Gandellini/alignment_test_Sample_11B/20150304_gandellini
```
### 4. Merge `BAMs` from multiple sequencing runs
```
Rscript MergeBAM.R [bams_to_merge.tsv]
```
### 5. Run `GATK best practices` on merged-BAMs
`CREATE_process_BAMs_with_GATK.R`
`process_BAMs_with_GATK.R [this use preprocessing_inputBAM.vMB.sh]`
