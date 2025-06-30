/*
 * Generate BAM index file
 */
/*
params.reads_bam = "${projectDir}/data/bam/*.bam"
params.outdir    = "results_genomics"
*/
process SAMTOOLS_INDEX {

    conda '/home/kihonlinux/anaconda3/envs/samtools'

    publishDir params.outdir, mode: 'symlink'

    input:
        path input_bam

    output:
        tuple path(input_bam), path("${input_bam}.bai")

    script:
    """
    samtools index '$input_bam'
    """
}
/*
workflow {

    reads_ch = Channel.fromPath(params.reads_bam)
    
    // Create index file for input BAM file
    SAMTOOLS_INDEX(reads_ch)

}
*/