#! /usr/bin/env bash

if type mogenerator > /dev/null;
then
  mogenerator --model ../MacMagazine/Classes/Models/MacMagazine.xcdatamodeld --machine-dir ../MacMagazine/Classes/Models/Machine --output-dir ../MacMagazine/Classes/Models
else
  echo "Please install mogenerator: http://rentzsch.github.io/mogenerator/"
fi
