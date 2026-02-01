include { FASTQC } from '../modules/fastqc'
include { TRIMMOMATIC } from '../modules/trimmomatic'
include { BWA_ALIGN } from '../modules/bwa'
include { SAMTOOLS_SORT } from '../modules/samtools_sort'
include { MARK_DUPLICATES } from '../modules/mark_duplicates'
include { VARIANT_CALLING } from '../modules/variant_calling'

workflow VARIANT_PIPELINE {
    reads = Channel.fromPath("${params.fastq_dir}/*.fastq.gz")
    reference = file(params.reference_genome)

    FASTQC(reads)
    trimmed = TRIMMOMATIC(reads)
    FASTQC(trimmed)
    
    ref_index = INDEX_REF(reference)
    aligned = BWA_ALIGN(trimmed, reference)
    sorted = SAMTOOLS_SORT(aligned)
    FLAGSTAT(sorted)
    variants = VARIANT_CALLING(sorted, reference)
    VALIDATE(variants, sorted)

}