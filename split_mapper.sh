varname=    #add the date (/mm/day/year) and ID run

REF=
# listing all fastq files
cd ./   #where this script must be placed

find `pwd` -name \*.fastq.gz -exec ls {} \; > list.$varname.HiC.txt

find `pwd` -name \*.fastq.gz -exec dirname {} \; | sort | uniq > repository


# creating folders

dir=`pwd`
mkdir $dir/mapping
fastq=$(head repository)

# gunzipping 

tr '\n' '\0' < list.$varname.txt | xargs -0 -r gunzip --

### split-mapping 


cat filenames.txt | while read LINE; do 

	bwa mem -t 4 $REF $fastq/"${LINE}".R1.fastq $fastq/"${LINE}".R2.fastq > $dir/mapping/$varname.sam
	samtools view -b -S -o $dir/mapping/$varname.bam $dir/mapping/$varname.sam
	samtools flagstat $dir/mapping/$varname.bam | sed -i '${LINE}' > $dir/mapping/$varname.txt
	rm $dir/mapping/$varname.sam
	; done


cat $dir/mapping/*.txt > $dir/mapping/report.$varname.txt



