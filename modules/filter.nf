process FILTER {
    publishDir "results/filtered", mode: 'copy'

    input :
    path vcf
    
    output :
    path "*_filtered_variant.vcf"

    script:
    """
    ${params.bcftools_bin} filter \
      -i 'QUAL>=30 && DP>=10' \
      ${vcf} \
      -Ov -o ${vcf.simpleName}_filtered.vcf
    """
}