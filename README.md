# Pre-process Haloplex WES PE Illumina data
from fastq to BAM

01. trimmomatic.R trimmomatic_config.R
02. RunBWA_mem.R RunBWA_mem_[id_sequencing_run].R
03. MergeSAM_SortBAM.R
04. MergeBAM.R
05. CREATE_process_BAMs_with_GATK.R
06. process_BAMs_with_GATK.R [this use preprocessing_inputBAM.vMB.sh]
