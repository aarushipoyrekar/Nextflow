process VARIANT_CALLING {
    publishDir "results/variants", mode: 'copy'

    input: 
    path bam
    path ref

    output: 
    path "*_variant.vcf"

    script: 
    """
    ${params.bcftools_bin} mpileup -f ${ref} ${bam} | \
    ${params.bcftools_bin} call -mv -Ov -o ${bam.simpleName}_variant.vcf

    bcftools filter -i 'QUAL>30 && DP>10' ${bam.simpleName}.raw.vcf \
    -o ${bam.simpleName}.filtered.vcf
    """
}