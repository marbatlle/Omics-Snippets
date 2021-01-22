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

echo "* INITIATING Referemce Genome Indexing *"
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



echo "*** PIPELINE FINALIZED ***"