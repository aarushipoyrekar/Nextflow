process ALIGN {
    publishDir "results/aligned", mode: 'copy'

    input: 
    path reads
    path ref

    output: 
    path "*_aligned.sam"

    script: 
    """
    ${params.bwa_bin} mem ${ref} ${reads} > ${reads.simpleName}_aligned.sam
    """
}