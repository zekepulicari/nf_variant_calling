#!/usr/bin/env nextflow

/*
 * Pipeline parameters
 */

 // Primary Input
params.bams_dir = "${projectDir}/data/bam"
params.outdir    = "results_genomics"

// Output directories
params.outdir_bai = "${projectDir}/data/bai"
params.outdir_gatk = "${projectDir}/data/gatk"

// Secondary inputs
params.ref_fa = "${projectDir}/data/ref/ref.fasta"
params.ref_index = "${projectDir}/data/ref/ref.fasta.fai"
params.ref_dict = "${projectDir}/data/ref/ref.dict"
params.intervals = "${projectDir}/data/ref/intervals.bed"

// GenomicsDB params
params.cohort_name = "family_cohort"


// Import modules
include { SAMTOOLS_INDEX } from "${projectDir}/modules/samtools_index.nf"
include { GATK_HAPLOTYPE_CALLER } from "${projectDir}/modules/gatk_haplotypecaller.nf"
include { GATK_JOINTGENOTYPING  } from "${projectDir}/modules/gatk_genomicsdb.nf"

// Variant calling: genomic analysis method to identify variants in a genome sequence relative to a reference genome. Example of variants are SNPs, short variants, indels. 
workflow {

    ref_fa_ch = file(params.ref_fa)
    ref_index_ch = file(params.ref_index)
    ref_dict_ch = file(params.ref_dict)
    ref_intervals_ch = file(params.intervals)

    // Get input files
    Channel
    .fromPath("${params.bams_dir}/*.bam")
    .set { bam_files }
    outdir_bai_ch = Channel.fromPath(params.outdir_bai)

    // Run the module to create Index File
    SAMTOOLS_INDEX(bam_files)
    
    // Run the module to start the variant calling process
    gatk_variants = GATK_HAPLOTYPE_CALLER(
        SAMTOOLS_INDEX.out, 
        ref_fa_ch, 
        ref_index_ch, 
        ref_dict_ch, 
        ref_intervals_ch
    )

    // collect outputs and reformat for GenomicsDB
    all_gvcfs_files = gatk_variants.vcf.collect() 
    all_gvcfs_idxs = gatk_variants.idx.collect()

    // Build the genomicsDB
    GATK_JOINTGENOTYPING (
        all_gvcfs_files,  
        all_gvcfs_idxs,
        ref_intervals_ch,
        params.cohort_name,
        ref_fa_ch,
        ref_index_ch,
        ref_dict_ch
    )

}