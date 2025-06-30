#!/usr/bin/env nextflow

/*
 * Pipeline parameters
 */

 // Primary Input
params.bam = "${projectDir}/data/bam/*.bam"
params.reads_bam = "${projectDir}/data/bam/reads_mother.bam"
params.outdir    = "results_genomics"

// Output directories
params.outdir_bai = "${projectDir}/data/bai"
params.outdir_gatk = "${projectDir}/data/gatk"

// Secondary inputs
params.ref_fa = "${projectDir}/data/ref/ref.fasta"
params.ref_index = "${projectDir}/data/ref/ref.fasta.fai"
params.ref_dict = "${projectDir}/data/ref/ref.dict"
params.intervals = "${projectDir}/data/ref/intervals.bed"

// Import modules
include { SAMTOOLS_INDEX } from "${projectDir}/modules/samtools_index.nf"
include { GATK_HAPLOTYPECALLER } from "${projectDir}/modules/gatk.nf"

// Variant calling: genomic analysis method to identify variants in a genome sequence relative to a reference genome. Example of variants are SNPs, short variants, indels. 
workflow {

    ref_fa_ch = file(params.ref_fa)
    ref_index_ch = file(params.ref_index)
    ref_dict_ch = file(params.ref_dict)
    ref_intervals_ch = file(params.intervals)

    // Get input files
    bam_files_ch = Channel.fromPath(params.bam)
    outdir_bai_ch = Channel.fromPath(params.outdir_bai)

    // Run the module to create Index File
    SAMTOOLS_INDEX(bam_files_ch)
    SAMTOOLS_INDEX.out.view() // to check if the outputs are right
    
    // Run the module to start the variant calling process
    gatk_variants = GATK_HAPLOTYPECALLER(
        SAMTOOLS_INDEX.out, 
        ref_fa_ch, 
        ref_index_ch, 
        ref_dict_ch, 
        ref_intervals_ch
    )

}