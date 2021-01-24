echo "*** INITIATING PIPELINE ***"

echo "* INITIATING Quality Control *"
mkdir -p out/fastqc
for sid in $(ls raw_data/*.fastq | cut -d"." -f1 | sed "s:raw_data/::")
do
    if [ ! -f out/fastqc/${sid}_fastqc.html ]
    then
        fastqc raw_data/${sid}.fastq --outdir=out/fastqc
        echo "* Quality Control FINALIZED *"
    else
        echo "* PROCESS EXITED. Sample $sid Quality Control OUTPUT ALREADY EXISTS *"
    fi
done

echo "* INITIATING Reference Genome Indexing *"
for refgen in $(ls human_genome/*.fa | cut -d"." -f1 | sed "s:human_genome/::")
do 
    if [ ! -f human_genome/${refgen}.fa.bwt ]
    then
        bwa index human_genome/${refgen}.fa
        echo "* Reference Genome Indexing FINALIZED *"
    else
        echo "* PROCESS EXITED. Reference genome $refgen Indexing OUTPUT ALREADY EXISTS *"
    fi
done

echo "* INITIATING Alignment *"
mkdir -p out/alignment
for fname in $(ls raw_data/*_R1.fastq | cut -d"." -f1 | sed "s:raw_data/::" | cut -d"_" -f2)
do 
    if [ ! -f out/alignment/${fname}.sam ]
    then 
        bwa mem -R '@RG\tID:OVCA\tSM:${fname}' human_genome/hg19_chr17.fa raw_data/WEx_${fname}_R1.fastq raw_data/WEx_${fname}_R2.fastq > out/alignment/${fname}.sam
        echo "* Alignment of $fname FINALIZED *"
    else 
        echo "* PROCESS EXITED. Alignment of $fname OUTPUT ALREADY EXISTS *"
    fi
done

echo "* INITIATING Alignment Refinement *"
for fname in $(ls raw_data/*_R1.fastq | cut -d"." -f1 | sed "s:raw_data/::" | cut -d"_" -f2)
do 
    if [ ! -f out/alignment/${fname}_refined.bam ]
    then
        samtools fixmate -O bam out/alignment/${fname}.sam out/alignment/${fname}_fixmate.bam
        samtools sort -O bam -o out/alignment/${fname}_sorted.bam out/alignment/${fname}_fixmate.bam
        samtools rmdup -S out/alignment/${fname}_sorted.bam out/alignment/${fname}_refined.bam
        samtools index out/alignment/${fname}_refined.bam
        echo "* Alignment Refinement for $fname FINALIZED *"
    else
        echo "* PROCESS EXITED. Alignment refinement of $fname OUTPUT ALREADY EXISTS *"
    fi
done

echo "* INITIATING Variant Calling *"
mkdir -p out/calling
for fname in $(ls raw_data/*_R1.fastq | cut -d"." -f1 | sed "s:raw_data/::" | cut -d"_" -f2)
do 
    if [ ! -f out/calling/${fname}_rawcalls.vcf.gz ]
    then
        bcftools mpileup -Ou -f human_genome/hg19_chr17.fa out/alignment/${fname}_refined.bam | bcftools call -vmO z -o out/calling/${fname}_rawcalls.vcf.gz
        bcftools index out/calling/${fname}_rawcalls.vcf.gz
        echo "* Variant Calling for $fname FINALIZED *"
    else
        echo "* PROCESS EXITED. Variant calling for $fname OUTPUT ALREADY EXISTS *"
    fi
done

echo "* INITIATING Intersection of Variants *"
mkdir -p out/calling/intersection
if [ ! -f out/calling/intersection/README.txt ]
then
    bcftools isec out/calling/Tumour_rawcalls.vcf.gz out/calling/Normal_rawcalls.vcf.gz -p out/calling/intersection
    cat out/calling/intersection/README.txt
    echo "* Variant Intersection Analysis for $fname FINALIZED *"
else
    echo "* PROCESS EXITED. Variant Intersection Analysis OUTPUT ALREADY EXISTS *"
fi

echo "*** PIPELINE FINALIZED ***"