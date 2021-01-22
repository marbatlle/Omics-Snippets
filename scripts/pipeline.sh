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

echo "* INITIATING Referece Genome Indexing *"
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
for fname in $(ls raw_data/*_R1.fastq | cut -d"." -f1 | sed "s:raw_data/::" | cut -d"_" -f2 )
do 
    if [ ! -f out/alignment/${fname}.sam ]
    then 
        bwa mem -R '@RG\tID:OVCA\tSM:${fname}' \
        human_genome/hg19_chr17.fa \
        raw_data/${fname}_R1.fastq \
        raw_data/${fname}_R2.fastq > out/alignment/${fname}.sam
        echo "* Alignment FINALIZED *"
    else 
        echo "* PROCESS EXITED. Alignment of $fname OUTPUT ALREADY EXISTS *"
    fi
done

echo "*** PIPELINE FINALIZED ***"