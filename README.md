# Pre-process Haloplex WES PE Illumina data
### scripts to merge and generate BAM file from multiple sequecning runs [ from raw fastq to BAM ]

Following an example for a test sample.

### 1. Trimming `fastq` files
```R
RScript trimmomatic.R trimmomatic_config_Sample11B_run_20141210.R
Rscript trimmomatic.R trimmomatic_config_Sample11B_run_20150113.R
```
### 2. Align `trimmed-fastq` with `bwa mem`
```R
Rscript RunBWA_mem.R RunBWA_mem_Config_Sample11B_run_20141210.R
Rscript RunBWA_mem.R RunBWA_mem_Config_Sample11B_run_20150113.R
```
### 3. Merge `SAMs` from multiple lanes and sort resulting `BAMs`
```R
Rscript MergeSAM_SortBAM.R [/path/to/folder_sequencing_run]
```
### 4. Merge `BAMs` from multiple sequencing runs
```R
Rscript MergeBAM.R [bams_to_merge.tsv]
```
### 5. Run `GATK best practices` on merged-BAMs
`CREATE_process_BAMs_with_GATK.R`
`process_BAMs_with_GATK.R [this use preprocessing_inputBAM.vMB.sh]`
