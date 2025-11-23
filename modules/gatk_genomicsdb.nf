process GATK_GENOMICSDB {
    conda '/home/kihonlinux/anaconda3/envs/gatk4'

    publishDir params.outdir, mode: 'copy'

    input:
        path all_gvcfs
        path all_idxs
        path interval_list
        path cohort_name

    output:
        path "${cohort_name}_gdb"
    
    script:
        """
        gatk GenomicsDBImport \
            -V ${all_gvcfs} \
            -L ${interval_list} \
            --genomicsdb-workspace-path ${cohort_name}_gdb
        """

}