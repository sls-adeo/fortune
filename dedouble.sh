#!/bin/sh
for files in $(find . -name "@adeo*.txt" -o -name "@bricoman*.txt" -o -name "@kbane*.txt" -o -name "@leroymerlin*.txt" -o -name "@zodio*.txt" -type f)
do
  	file=`basename $files`
	folder=`dirname $files`
	enseigne=`dirname $files | cut -c4-`  	
  	
	echo "Manage $file"
 
	#-- Supprimer tout ligne vide
	sed -i '/^$/d' $files 

  	#-- Supprimer tout ligne ne commençant pas par un chiffre
  	cat $files | awk 'BEGIN {FS="\t"} /^[0-9]/ { print $0 }' > $files.new	
  
  	#-- Trier le fichier par le texte
  	sort -u -t'	' -k2,2 -k1,1 $files.new > $files 

	rm $files.new

	#-- Produire la fortune https://askubuntu.com/questions/36523/creating-a-fortunes-file
	cat $files | awk 'BEGIN {FS="\t" ; oldtxt=""} {if (match(oldtxt,$2)==0) {print $1,$2 ;printf "%\n"}; oldtxt =$2} ' > $folder/$enseigne

	strfile -c % $folder/$enseigne $folder/$enseigne.dat

	sudo cp $folder/$enseigne /usr/share/games/fortunes

	sudo cp $folder/$enseigne.dat /usr/share/games/fortunes
done
