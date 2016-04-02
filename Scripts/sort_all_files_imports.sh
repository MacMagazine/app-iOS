#! /usr/bin/env bash

BASEDIR=$(dirname $0)
find $BASEDIR/.. -name "*.[hm]" ! -path "*/libs/*" ! -path "*.framework*" ! -path "*Pods/*" ! -path "*Submodules/*" -print0 | xargs -0 ruby $BASEDIR/sort_imports.rb
