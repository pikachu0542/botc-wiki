#wget https://github.com/Telshin/Spoilers/archive/master.zip; \
#unzip master.zip; \
#mv Spoilers-master /var/www/html/extensions/Spoilers; \
#rm master.zip; \
#wget https://github.com/Pavelovich/WikiBanner/archive/master.zip; \
#unzip master.zip; \
#mv WikiBanner-master /var/www/html/extensions/WikiBanner; \
#rm master.zip; \
#wget https://github.com/wikimedia/mediawiki-extensions-OpenIDConnect/archive/refs/heads/master.zip; \
#unzip master.zip; \
#mv mediawiki-extensions-OpenIDConnect-master /var/www/html/extensions/OpenIDConnect; \
#rm master.zip; \
#wget https://github.com/WillNilges/mediawiki-aws-s3/archive/refs/heads/master.zip; \
#unzip master.zip; \
#mv mediawiki-aws-s3-master /var/www/html/extensions/AWS; \
#rm master.zip; 

extensions=( Telshin/Spoilers Pavelovich/WikiBanner wikimedia/mediawiki-extensions-OpenIDConnect WillNilges/mediawiki-aws-s3 )
targets=( Spoilers WikiBanner OpenIDConnect AWS )

for i in "${!extensions[@]}"; do
    extension=${extensions[$i]}
    target=${targets[$i]}
    echo Downloading $extension...
    wget https://github.com/$extension/archive/master.zip
    unzip master.zip
    rm master.zip

    unzipped=${extension#*/}"-master"
    echo Moving $unzipped to extensions folder...
    mv $unzipped /var/www/html/extensions/$target
    echo
done
