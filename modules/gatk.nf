/*
// Accessory files
params.reference        = "${projectDir}/data/ref/ref.fasta"
params.reference_index  = "${projectDir}/data/ref/ref.fasta.fai"
params.reference_dict   = "${projectDir}/data/ref/ref.dict"
params.intervals        = "${projectDir}/data/ref/intervals.bed"

// Load the file paths for the accessory files (reference and intervals)
ref_file        = file(params.reference)
ref_index_file  = file(params.reference_index)
ref_dict_file   = file(params.reference_dict)
intervals_file  = file(params.intervals)
*/

process GATK_HAPLOTYPE_CALLER {
    conda '/home/kihonlinux/anaconda3/envs/gatk4'

    publishDir params.outdir, mode: 'symlink'

    input:
        tuple path(input_bam), path(input_bam_index)
        path ref_fasta
        path ref_index
        path ref_dict
        path interval_list    
    
    output:
        path "${input_bam}.vcf", emit: vcf
        path "${input_bam}.vcf.idx", emit: idx
    
    script:
        """
        gatk HaplotypeCaller \
            -R ${ref_fasta} \
            -I ${input_bam} \
            -O ${input_bam}.vcf \
            -L ${interval_list}
        """
    
}
/*
workflow {

    reads_ch = Channel.fromPath(params.reads_bam)

    // Call variants from the indexed BAM file
    GATK_HAPLOTYPECALLER(
        reads_ch,
        SAMTOOLS_INDEX.out,
        ref_file,
        ref_index_file,
        ref_dict_file,
        intervals_file
    )

}
*/