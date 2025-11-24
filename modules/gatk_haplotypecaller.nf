// GATK pipelines

process GATK_HAPLOTYPE_CALLER {
    container 'quay.io/biocontainers/gatk4:4.6.2.0--py310hdfd78af_1'

    publishDir params.outdir, mode: 'symlink'

    input:
        tuple path(input_bam), path(input_bam_index)
        path ref_fasta
        path ref_index
        path ref_dict
        path interval_list    
    
    output:
        path "${input_bam}.g.vcf", emit: vcf
        path "${input_bam}.g.vcf.idx", emit: idx
    
    script:
        """
        gatk HaplotypeCaller \
            -R ${ref_fasta} \
            -I ${input_bam} \
            -O ${input_bam}.g.vcf \
            -L ${interval_list} \
            -ERC GVCF  
        """
    // -ERC GVCF to produce a genomic vcf .g.vcf 
}

/*
process GATK_JOINTGENOTYPING {



}
*/