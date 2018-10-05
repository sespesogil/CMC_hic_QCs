

# load dependencies 

module load bwa samtools


varname=    #add the date (/mm/day/year) and ID run

REF=   # add reference genome
dir=    # fastq directories

# listing all fastq files

find $dir -name \*.fastq -exec ls {} \; | sort >  list.$varname.HiC.txt

# creating folders

mkdir $dir/mapping

# gunzipping

tr '\n' '\0' < list.$varname.txt | xargs -0 -r gunzip --

### split-mapping
find $dir -name \*.fastq -printf '%f\n' | cut -d"." -f1 | sort | uniq > filenames.txt
cat filenames.txt | while read LINE; do

        bwa mem -t 4 $REF $dir/${LINE}.R1.fastq $dir/${LINE}.R2.fastq > $dir/mapping/$varname.sam
        samtools view -b -S -o $dir/mapping/$varname.bam $dir/mapping/$varname.sam
        samtools flagstat $dir/mapping/$varname.bam | sed -i '${LINE}' > $dir/mapping/$varname.txt
        rm $dir/mapping/$varname.sam

done


cat $dir/mapping/*.txt > $dir/mapping/report.$varname.txt
