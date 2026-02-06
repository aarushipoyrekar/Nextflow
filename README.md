--> Variant Calling Workflow

--> Overview
This repository contains a step-by-step *variant calling workflow* for identifying genomic variants from (NGS) data.
The pipeline performs quality control, read trimming, alignment to a reference genome, and variant calling followed by filtering.

The workflow is demonstrated using *Escherichia coli* sequencing data.

--> Requirements
- Linux operating system (Ubuntu used)
- Conda (Miniconda or Anaconda)
- Bioinformatics tools installed via *bioconda*:
  - FastQC
  - Trimmomatic
  - BWA
  - SAMtools
  - BCFtools
---

--> Input Data
- *Raw sequencing reads:*
  `SRR2584863_1.fastq.gz`
- *Reference genome:*
  `GCF_000005845.2_ASM584v2_genomic.fna` (E. coli)
---

--> Directory Structure
```text
.
├── raw/        // Raw FASTQ files
├── trimmed/    // Trimmed FASTQ files
├── qc/         // Quality control reports
├── ref/        // Reference genome files
├── aligned/    // Alignment files (SAM/BAM)
├── variants/   // Variant call files (VCF)
└── README.md   // Workflow documentation
```
--> Workflow

Step 1: Organizing Input Data

`cp /mnt/d/SRR2584863_1.fastq.gz raw/`

The raw sequencing reads (FASTQ format) were copied into the project’s raw/ directory. This step ensures that all inputs are organized within a single working directory, which is essential for reproducibility and clarity in a pipeline.

Step 2: Quality Control of Raw Reads

`fastqc raw/SRR2584863_1.fastq.gz -o qc/`

FastQC was used to assess the quality of the raw sequencing reads. The output includes reports on per-base quality scores, GC content, sequence length distribution, and presence of adapters. These reports help determine whether trimming or other preprocessing steps are required.

Step 3: Trimming Low-Quality Bases and Adapters

`trimmomatic SE \
  raw/SRR2584863_1.fastq.gz \
  trimmed/SRR2584863_trimmed.fastq.gz \
  SLIDINGWINDOW:4:20 \
  MINLEN:36`

Trimmomatic was used to remove low-quality bases from the reads. A sliding window approach trims regions where the average quality drops below a threshold, and very short reads are discarded. This step improves alignment accuracy by cleaning the data.

Step 4: Quality Control After Trimming

`fastqc trimmed/SRR2584863_trimmed.fastq.gz -o qc/`

FastQC was run again on the trimmed reads to confirm that quality issues identified earlier were resolved. Improved base quality and reduced adapter content indicate successful trimming.

Step 5: Indexing the Reference Genome

`bwa index ref/ref.fa`
`samtools faidx ref/ref.fa`

The reference genome (FASTA format) was indexed. BWA indexing prepares the reference for efficient alignment, while samtools faidx creates an index that allows fast random access to reference sequences. These index files are required for downstream alignment and variant calling.

Step 6: Aligning Reads to the Reference Genome

`bwa mem ref/ref.fa \
  trimmed/SRR2584863_trimmed.fastq.gz \
  > aligned/SRR2584863.sam`

BWA-MEM aligned the cleaned sequencing reads to the reference genome. The output is a SAM file containing alignment information for each read, including mapping position and alignment quality.

Step 7: Converting SAM to BAM

`samtools view -Sb aligned/SRR2584863.sam > aligned/SRR2584863.bam`

The SAM file was converted to BAM format. BAM is a compressed binary version of SAM that is smaller and faster to process, making it suitable for downstream analyses.

Step 8: Sorting the BAM File

`samtools sort aligned/SRR2584863.bam -o aligned/SRR2584863.sorted.bam`

The BAM file was sorted by genomic coordinates. Sorting is required so that reads aligned to the same genomic regions are grouped together, which is essential for variant calling.

Step 9: Indexing the Sorted BAM File

`samtools index aligned/SRR2584863.sorted.bam`

An index file for the sorted BAM was generated. This allows rapid access to specific genomic regions and is required by many downstream tools.

Step 10: Evaluating Alignment Success

`samtools flagstat aligned/SRR2584863.sorted.bam`

This step produced alignment statistics, including the total number of reads and the percentage mapped to the reference genome. A high mapping percentage (~94%) confirmed that the reads matched the reference and that alignment was successful.

Step 11: Variant Calling

`bcftools mpileup -f ref/ref.fa \
  aligned/SRR2584863.sorted.bam | \
bcftools call -mv -Ov \
  -o variants/SRR2584863_raw.vcf`

Bcftools was used to identify genomic variants by comparing the aligned reads to the reference genome. The mpileup step summarizes read evidence at each position, and call identifies SNPs and indels. The output is a VCF file containing raw variant calls.

Step 12: Filtering Variants

`bcftools filter -i 'QUAL>30 && DP>10' \
  variants/SRR2584863_raw.vcf \
  -o variants/SRR2584863_filtered.vcf`

Low-confidence variants were filtered out based on quality score and read depth. This step retains only high-confidence variants that are more likely to represent true biological differences rather than sequencing noise.

--> Output

 - Quality control reports (qc/)

 - Aligned and indexed BAM files (aligned/)

 - Raw and filtered VCF files (variants/)

--> Notes on Reproducibility

 - All steps are command-line based and can be reproduced on any Linux system

 - Conda and bioconda ensure consistent tool versions

 - Clear directory organization improves transparency and repeatability
