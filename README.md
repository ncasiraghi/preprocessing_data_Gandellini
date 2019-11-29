# Pre-process Haloplex WES PE Illumina data
### scripts to merge and generate BAM file - from raw fastq to gatk-processed BAM -
This repository on the unitn server: `/CIBIO/sharedCO/Exome_seq/Gandellini/`

The alignment test on the unitn server: `/scratch/sharedCO/Casiraghi/Gandellini/alignment_test_Sample_11B/`

Data from https://doi.org/10.1016/j.euo.2018.08.010

Here is reported a step-by-step example for a sample that has been sequenced in 3 runs.

```
# sequencing runs folder:
SR1=alignment_test_Sample_11B/20141210_gandellini
SR2=alignment_test_Sample_11B/20150113_gandellini
SR3=alignment_test_Sample_11B/20150304_gandellini
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
> The `SampleSheet.csv`, present in each sample folder, is used to build up the @RG<br />
> In this study the alignment has been performed on the Human Reference Genome `humanG1Kv37` (`human_g1k_v37.fasta, GRCh37`)
```
# Usage example
Rscript RunBWA_mem.R $SR1
Rscript RunBWA_mem.R $SR2
Rscript RunBWA_mem.R $SR3
```
### 3. Merge `SAMs` from multiple lanes and sort resulting `BAMs`
In script `MergeSAM_SortBAM.R` update variable:
```R
MergeSamFiles <- /path/to/Picard/MergeSamFiles.jar 
```
```
# Usage example
Rscript MergeSAM_SortBAM.R $SR1
Rscript MergeSAM_SortBAM.R $SR2
Rscript MergeSAM_SortBAM.R $SR3
```
> `samtools` required.
### 4. Merge `BAMs` from multiple sequencing runs
In script `MergeBAM.R` update variable:
```R
MergeSamFiles <- /path/to/Picard/MergeSamFiles.jar 
```
> The `bams_to_merge.cvs` is a comma-separated file indicating multiple `BAMs` to be merged in a single one for each sample.  

Example of the `bams_to_merge.csv` file:
```
ID_SAMPLE,/path/to/ID_SAMPLE_SeqRun1.bam
ID_SAMPLE,/path/to/ID_SAMPLE_SeqRun2.bam
...
ID_SAMPLE,/path/to/ID_SAMPLE_SeqRunN.bam
```
> For each ID_SAMPLE present in the `bams_to_merge.csv` file, a folder named `ID_SAMPLE` will be created in the `output_folder` where the merged BAM file will be saved.
```
# Usage example
Rscript MergeBAM.R [bams_to_merge.csv] [output_folder]

Rscript MergeBAM.R alignment_test_Sample_11B/bams_merged/bams_to_merge.csv alignment_test_Sample_11B/bams_merged
```
> `samtools` required.

### 5. Run `GATK best practices` on merged-BAMs
In script `RunGATK.R` update variable:
```R
script.path <- /path/to/gatk/gatk_best_practices.sh 
```
> Script with GATK Best Practices is 'gatk/gatk_best_practices.sh' saved in this repository.
```
# Usage example
Rscript RunGATK.R [/path/to/folder_with_merged_BAMs] [output_folder]

Rscript RunGATK.R alignment_test_Sample_11B/bams_merged alignment_test_Sample_11B/bams_merged_gatk
```
