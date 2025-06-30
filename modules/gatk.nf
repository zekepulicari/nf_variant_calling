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