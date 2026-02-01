process INDEX {
    publishDir "results/index", mode: 'copy'

    input: 
    path ref

    output: 
    path "*.amb"
    path "*.ann"
    path "*.bwt"
    path "*.pac"
    path "*.sa"
    path "*.fai"

    script: 
    """
    ${params.bwa_bin} index ${ref}
    ${params.samtools_bin} faidx ${ref}
    """
}