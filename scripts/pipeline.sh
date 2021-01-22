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

echo "*** PIPELINE FINALIZED ***"