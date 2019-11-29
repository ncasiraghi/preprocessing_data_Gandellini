#!/bin/bash

## Version: N.Casiraghi & M.Benelli
## remove dedup: Haloplex kit.

## Data pre-processing (GATK best practices)
printf "\n#### Data preprocessing following GATK best practices:\n\n"

# sorted BAM file to clean
sortBAM=$1
# Output folder
outFOLDER=$2
# N. of threads
ncores=$3

if [ "$#" -ne 3 ]; then
    printf "#### ERROR\tIncorrect number of arguments supplied\n#### USAGE\tpreprocessing_inputBAM.sh <input.BAM> <path/to/outfolder> <N.threads>\n\n"
    exit
fi

# Reference fasta
REF=/elaborazioni/sharedCO/Home_casiraghi/Reference_b37/human_g1k_v37.fasta
printf '[ FASTA ]\tReference Genome:\t'$REF'\n'
printf '[ BAM ]  \tSorted BAM file: \t'$sortBAM'\n\n'

# create temp directory
mkdir -p $outFOLDER'/temp_dir'

## Remove duplicated reads
#dedupBAM=$outFOLDER'/'$(basename "$sortBAM" .bam).dedup.bam
#cmd=(java -Xmx20G -jar /scratch/Tools/Picard/MarkDuplicates.jar I=$sortBAM O=$dedupBAM REMOVE_DUPLICATES=true TMP_DIR=temp_dir MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=2000 VALIDATION_STRINGENCY=SILENT METRICS_FILE=$outFOLDER/metrics_file.txt ASSUME_SORTED=true)
#echo "${cmd[@]}"
#"${cmd[@]}"
#
#cmd=(samtools index $dedupBAM)
#echo "${cmd[@]}"
#"${cmd[@]}"

# remove temp_dir
#rm -r temp_dir

dedupBAM=$sortBAM

## Local realignment around indels
#  Realign BAM around indels > STEP1 <
cmd=(singularity exec -B /CIBIO -B /scratch -B /elaborazioni -B /SPICE /CIBIO/sharedCO/Exome_seq/Gandellini/preprocessing_data_Gandellini/gatk/openjdk-7-slim.simg /usr/lib/jvm/java-1.7.0-openjdk-amd64/bin/java -Xmx16G -jar /scratch/Tools/GATK/GenomeAnalysisTK.jar -S SILENT -I $dedupBAM -R $REF -T RealignerTargetCreator -o $outFOLDER'/'target.intervals -nt $ncores)
echo "${cmd[@]}"
"${cmd[@]}"

# realign BAM around indels > STEP2 <
realBAM=$outFOLDER'/'$(basename "$dedupBAM" .bam).realigned.bam
cmd=(singularity exec -B /CIBIO -B /scratch -B /elaborazioni -B /SPICE /CIBIO/sharedCO/Exome_seq/Gandellini/preprocessing_data_Gandellini/gatk/openjdk-7-slim.simg /usr/lib/jvm/java-1.7.0-openjdk-amd64/bin/java -Xmx16G -jar /scratch/Tools/GATK/GenomeAnalysisTK.jar -S SILENT -I $dedupBAM -R $REF -T IndelRealigner -targetIntervals $outFOLDER'/'target.intervals -o $realBAM)
echo "${cmd[@]}"
"${cmd[@]}"

# rm dedup bam file
#rm *.dedup.bam *.dedup.bam.bai

## Base quality score recalibration
cmd=(singularity exec -B /CIBIO -B /scratch -B /elaborazioni -B /SPICE /CIBIO/sharedCO/Exome_seq/Gandellini/preprocessing_data_Gandellini/gatk/openjdk-7-slim.simg /usr/lib/jvm/java-1.7.0-openjdk-amd64/bin/java -Xmx16G -jar /scratch/Tools/GATK/GenomeAnalysisTK.jar -T BaseRecalibrator -R $REF -I $realBAM -knownSites /elaborazioni/sharedCO/CO_Shares/referenceTables/BQS_recalibration_knownSites/hapmap_3.3.b37.vcf -knownSites /elaborazioni/sharedCO/CO_Shares/referenceTables/BQS_recalibration_knownSites/1000G_phase1.snps.high_confidence.b37.vcf  -knownSites /elaborazioni/sharedCO/CO_Shares/referenceTables/BQS_recalibration_knownSites/1000G_omni2.5.b37.vcf -o $outFOLDER'/'base_quality_scores.txt -nct $ncores) 
echo "${cmd[@]}"
"${cmd[@]}"

recalBAM=$outFOLDER'/'$(basename $realBAM .bam).recalibrated.bam
cmd=(singularity exec -B /CIBIO -B /scratch -B /elaborazioni -B /SPICE /CIBIO/sharedCO/Exome_seq/Gandellini/preprocessing_data_Gandellini/gatk/openjdk-7-slim.simg /usr/lib/jvm/java-1.7.0-openjdk-amd64/bin/java -Xmx16G -jar /scratch/Tools/GATK/GenomeAnalysisTK.jar -T PrintReads -R $REF -I $realBAM -o $recalBAM --BQSR $outFOLDER'/'base_quality_scores.txt -nct $ncores)
echo "${cmd[@]}"
"${cmd[@]}"

mdBAM=$outFOLDER'/'$(basename "$recalBAM" .bam).md.bam
cmdMD() {
	samtools fillmd -b $recalBAM $REF > $mdBAM
}
cmdMD

# indexing final BAM
cmd=(samtools index $mdBAM)
echo "${cmd[@]}"
"${cmd[@]}"

printf "\n\n[DONE]"
