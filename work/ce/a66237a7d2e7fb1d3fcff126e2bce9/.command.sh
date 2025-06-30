#!/bin/bash -ue
gatk HaplotypeCaller             -R ref.fasta             -I reads_son.bam             -O reads_son.bam.vcf             -L intervals.bed
