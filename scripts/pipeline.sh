echo "*** INITIATING PIPELINE ***"

echo "* INITIATING Quality Control *"
mkdir -p out/fastqc
for sid in $(ls raw_data/*.fastq  | cut -d"." -f1 | sed "s:raw_data/::")
do
    if [! -f out/fastqc/${sid}_fastqc.html]
then
    ls raw_data/*.fastq
    fastqc raw_data/WEx_Normal_R1.fastq --outdir=out/fastqc
echo "* Quality Control FINALIZED *"

echo "*** PIPELINE FINALIZED ***"