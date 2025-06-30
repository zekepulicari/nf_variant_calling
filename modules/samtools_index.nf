/*
 * Generate BAM index file
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