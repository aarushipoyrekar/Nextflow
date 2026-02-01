process SORT {
    publishDir "results/sorted", mode: 'copy'

    input: 
    path sam

    output: 
    path "*_sorted.bam"
    path "*.sorted.bam.bai"

    script: 
    """
    ${params.samtools_bin} sort ${sam} -o ${sam.simpleName}_sorted.bam
    ${params.samtools_bin} index ${sam.simpleName}_sorted.bam
    """
}