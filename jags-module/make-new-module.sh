#!/bin/bash

modulename=new-module
fname=ct

echo 'Extracting...'
mkdir -p $modulename
tar -xzf template.tar.gz -C $modulename

echo 'Editing...'
cp src-NAMESPACE.cc              $modulename/src/$fname.cc
cp src-distributions-HEADER.h    $modulename/src/distributions/D${fname^^}.h
cp src-distributions-SOURCE.cc   $modulename/src/distributions/D${fname^^}.cc
cp Makefile.am                   $modulename/Makefile.am

sed "s/#FNAME#/${fname^^}/g" configure.ac.tpl > \
  $modulename/configure.ac
sed "s/#fname#/$fname/g"     src-Makefile.am.tpl > \
  $modulename/src/Makefile.am
sed "s/#FNAME#/${fname^^}/g" src-distributions-Makefile.am.tpl | \
  sed "s/#fname#/$fname/g" > \
  $modulename/src/distributions/Makefile.am


cd $modulename

echo 'Compiling...'
autoreconf -fvi && ./configure --prefix=/usr

make && sudo make install
