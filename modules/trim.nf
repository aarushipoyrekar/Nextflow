process TRIMMOMATIC {
    publishDir "results/trimmed", mode: 'copy'

    input: 
    path reads

    output: 
    path "${reads.simpleName}_trimmed.fastq.gz"
    
    script: """
    ${params.trimmomatic_bin} SE \
    ${reads} \
    ${reads.simpleName}_.trimmed.fastq.gz \
    SLIDINGWINDOW:4:20 \
    MINLEN:36
    """
}
