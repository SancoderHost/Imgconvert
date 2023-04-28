#!/bin/bash 
resize=250

if [[ $#  -ne 2  ]]
then
	echo "no args "
	exit 1
fi 


inputdir="$(realpath $1)"
outputdir="$(realpath $2)"
files="$(find "$inputdir"  -not -path '*/.*'  -name "*.jpg" )"
filecount=$(echo "$files" |wc -l )
mapfile -t input  < <( echo "$files" )

count=0
for i in "${input[@]}"
do 
		((count++))
		echo "processing $count/$filecount"
		#${variable//search/replace}
		echo "$i"
		inputpath="$(realpath "$i")"	
		
		#jpegoptim  -f --size 25k "$inputpath" -d "$outputdir/"
		convert -resize "$resize"x -define jpeg:extent=30kb  "$inputpath" "$outputdir/$(echo "$i" |awk -F / '{print $NF}' | sed 's/\.jpg$//' ).jpg"

done 
echo "zipping" 
cd "$outputdir" 
zip  -r  -9 "$inputdir/scanned.zip"  *
