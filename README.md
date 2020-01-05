# fortune
Create a Fortune (https://en.wikipedia.org/wiki/Fortune_(Unix)) : a random message print with a cowsay ascii image (https://en.wikipedia.org/wiki/Cowsay)




## Get the tools jp2a (https://csl.name/jp2a/) fortune and  cowsay

![Becareful](https://upload.wikimedia.org/wikipedia/en/thumb/f/f7/Nuvola_apps_important.svg/30px-Nuvola_apps_important.svg.png "Becareful") For Debian System use this command


`apt-get install fortune cowsay jp2a`


## Get brand logos of company, resize them for getting the core part 

`wget https://upload.wikimedia.org/wikipedia/fr/8/82/Adeo_logo.jpg -O adeo.jpg`
 
![Becareful](https://upload.wikimedia.org/wikipedia/en/thumb/f/f7/Nuvola_apps_important.svg/30px-Nuvola_apps_important.svg.png "Becareful") Convert if needed the Png images to Jpg one

## Transform images in Ascii Art and in Cow format

Use this script

```shell

#!/bin/sh

jp2a --colors --width=60  -i adeo.jpg        > adeo.asc
jp2a --colors --width=100 -i bricoman.jpg    > bricoman.asc
jp2a --colors --width=60  -i kbane.jpg       > kbane.asc
jp2a --colors --width=100 -i leroymerlin.jpg > leroymerlin.asc
jp2a --colors --width=60  -i zodio.jpg       > zodio.asc

for file in $(ls *.asc)
do
  
cat $file | awk 'BEGIN { printf("$the_cow = <<\"EOC\";\n");printf("$thoughts\n    $thoughts\n        $thoughts\n");} {print $0} END { print "EOC" }' >  $(echo $file | cut -f1 -d'.').cow

done  

#-- Add .cow files in library cowsay
cp *.cow /usr/share/cowsay/cows
```

## Test the cowsay images

Use this script

```shell
#!/bin/sh
for text in "adeo" "bricoman" "kbane" "leroymerlin" "zodio"
do
cowsay -f $text "Hello $text"
done
```

## Create its own fortunes with message gotten from Twitter on the brands 

You can follow that tutorial https://galeascience.wordpress.com/2016/03/18/collecting-twitter-data-with-python/

### Prerequisites : 

* Use Python 3
* Install Tweepy (python3 -m pip install tweepy)
* Declare the application on https://developer.twitter.com/en.html ![Stop](https://upload.wikimedia.org/wikipedia/en/thumb/f/f1/Stop_hand_nuvola.svg/30px-Stop_hand_nuvola.svg.png "Stop") you need a Twitter account for that!

### Get/Modify the Project

* Get the Github project twitter_search (https://github.com/agalea91/twitter_search)
* Modify the project 
	... set your Keys/SecretKeys for calling the Apis Twitter
  ... get the tweet having the keyword adeo , kbane , ...)  and not the RT ones
  ... modify the number of days authorized by Twitter for searching tweets (9 days) 
  ... Save text tweet info and its create date in a '|' separated file (.txt)


### Run the project

`python3 twitter_search.py`

* Dedouble lines in the .txt file 

![Becareful](https://upload.wikimedia.org/wikipedia/en/thumb/f/f7/Nuvola_apps_important.svg/30px-Nuvola_apps_important.svg.png "Becareful") Check messages and Keep the interesting ones

Use this script
 
```shell 
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
```

## Test the fortune  

```shell
export FORTUNEADEO=`ls /usr/share/cowsay/cows/adeo* /usr/share/cowsay/cows/bricoman* /usr/share/cowsay/cows/kbane* /usr/share/cowsay/cows/leroymerlin* /usr/share/cowsay/cows/zodio* | shuf -n 1 | xargs basename  | cut -f1 -d'.'` 
 
fortune $FORTUNEADEO | cowsay -f $FORTUNEADEO
```

## Add the fortune each time you launch your Shell 

Edit the file  .bashrc and add in add of the file these lines  

```shell
export FORTUNEADEO=`ls /usr/share/cowsay/cows/adeo* /usr/share/cowsay/cows/bricoman* /usr/share/cowsay/cows/kbane* /usr/share/cowsay/cows/leroymerlin* /usr/share/cowsay/cows/zodio* | shuf -n 1 | xargs basename  | cut -f1 -d'.'` 
 
fortune $FORTUNEADEO | cowsay -f $FORTUNEADEO
```
