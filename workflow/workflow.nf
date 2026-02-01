
include { FASTQC as FASTQC_RAW } from '../modules/fastqc.nf'
include { TRIMMOMATIC } from '../modules/trim.nf'
include { FASTQC as FASTQC_TRIMMED } from '../modules/fastqc.nf'
include { INDEX } from '../modules/index.nf'
include { ALIGN } from '../modules/align.nf'
include { SORT } from '../modules/sort.nf'
include { VARIANT_CALLING } from '../modules/varcall.nf'

workflow VARIANT_PIPELINE {
    reads_ch = Channel.fromPath(params.reads)
    ref_ch   = Channel.fromPath(params.ref)

    FASTQC_RAW(reads_ch)
    trimmed_ch = TRIMMOMATIC(reads_ch)
    FASTQC_TRIMMED(trimmed_ch)
    INDEX(ref_ch)
    aligned_ch = ALIGN(trimmed_ch, ref_ch)
    sorted_ch = SORT(aligned_ch)
    VARIANT_CALLING(sorted_ch, ref_ch)
}