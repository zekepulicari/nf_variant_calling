process GATK_JOINTGENOTYPING  {
    container 'quay.io/biocontainers/gatk4:4.6.2.0--py310hdfd78af_1'

    publishDir params.outdir, mode: 'move', overwrite: true

    input:
        path all_gvcfs
        path all_idxs
        path interval_list
        val cohort_name
        path ref_fasta
        path ref_fasta_index
        path ref_fasta_dict

    output:
        path "${cohort_name}_gdb", type: 'dir'
        path "${cohort_name}.joint.vcf", emit: vcf
        path "${cohort_name}.joint.vcf.idx", emit: idx
    
    script:
        def gvcfs_files_collected = all_gvcfs.collect { gvcf -> "-V ${gvcf}" }.join(' ')
        """
        gatk GenomicsDBImport \
            ${gvcfs_files_collected} \
            -L ${interval_list} \
            --genomicsdb-workspace-path ${cohort_name}_gdb

        gatk GenotypeGVCFs \
            -R ${ref_fasta} \
            -V gendb://${cohort_name}_gdb \
            -L ${interval_list} \
            -O ${cohort_name}.joint.vcf
        """

}