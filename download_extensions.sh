#!/bin/bash

mkdir new_extensions
for extension in OpenIDConnect-REL1_40-e9d47f2.tar.gz PluggableAuth-REL1_40-519c6d2.tar.gz; do
    wget https://extdist.wmflabs.org/dist/extensions/$extension
    tar -xvzf $extension -C new_extensions/
    mv new_extensions/* /var/www/html/extensions
done;

